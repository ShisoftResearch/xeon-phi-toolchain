#include "ggml.h"
#include "ggml-alloc.h"
#include "ggml-backend.h"
#include "ggml-rpc.h"
#include <cstdio>
#include <cstring>
#include <vector>

int main(int argc, char ** argv) {
    if (argc != 3) return 2;
    ggml_backend_load_all();
    ggml_backend_t backends[2] = {ggml_backend_rpc_init(argv[1], 0), ggml_backend_rpc_init(argv[2], 0)};
    if (!backends[0] || !backends[1]) return 3;
    auto reg = ggml_backend_dev_backend_reg(ggml_backend_get_device(backends[0]));
    auto init = (ggml_backend_comm_init_t)ggml_backend_reg_get_proc_address(reg, "ggml_backend_comm_init");
    auto reduce = (ggml_backend_comm_allreduce_tensor_t)ggml_backend_reg_get_proc_address(reg, "ggml_backend_comm_allreduce_tensor");
    auto release = (ggml_backend_comm_free_t)ggml_backend_reg_get_proc_address(reg, "ggml_backend_comm_free");
    if (!init || !reduce || !release) return 4;
    void * comm = init(backends, 2);
    if (!comm) return 5;
    size_t checks = 0;
    for (int n : {16, 32768, 65537}) {
        ggml_context * contexts[2];
        ggml_tensor * tensors[2];
        ggml_backend_buffer_t buffers[2];
        std::vector<float> a(n), b(n), expected(n), output(n);
        for (int i = 0; i < n; ++i) {
            a[i] = 1.00001f + (i % 7) * 0.000127f;
            b[i] = (i % 17 - 8) * 0.000123f;
            expected[i] = a[i] + b[i];
        }
        for (int rank = 0; rank < 2; ++rank) {
            contexts[rank] = ggml_init({1024 * 1024, nullptr, true});
            tensors[rank] = ggml_new_tensor_1d(contexts[rank], GGML_TYPE_F32, n);
            tensors[rank]->flags |= GGML_TENSOR_FLAG_COMPUTE;
            buffers[rank] = ggml_backend_alloc_ctx_tensors(contexts[rank], backends[rank]);
            if (!buffers[rank]) return 6;
            ggml_backend_tensor_set(tensors[rank], rank ? b.data() : a.data(), 0, n * sizeof(float));
        }
        if (!reduce(comm, tensors)) return 7;
        for (int rank = 0; rank < 2; ++rank) {
            ggml_backend_synchronize(backends[rank]);
            ggml_backend_tensor_get(tensors[rank], output.data(), 0, n * sizeof(float));
            if (std::memcmp(output.data(), expected.data(), n * sizeof(float))) return 8;
            checks += n;
            ggml_backend_buffer_free(buffers[rank]);
            ggml_free(contexts[rank]);
        }
    }
    release(comm);
    ggml_backend_free(backends[1]);
    ggml_backend_free(backends[0]);
    std::printf("PASS two KNC ranks: %zu bit-exact F32 collective outputs, including BF16-threshold cases\n", checks);
}

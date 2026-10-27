#include "ggml.h"
#include "ggml-cpu.h"
#include "ggml-backend.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

static size_t checks;
static void fill(ggml_tensor * t, unsigned seed) {
    for (int64_t row=0; row<t->ne[1]; ++row) {
        float * p=(float *)((char *)t->data+row*t->nb[1]);
        for (int64_t col=0; col<t->ne[0]; ++col) {
            seed^=seed<<13;seed^=seed>>17;seed^=seed<<5;
            p[col]=(int(seed%80001)-40000)/2000.0f;
        }
    }
}
static bool one(ggml_backend_t backend,int nc,int nr,int kind,bool strided,bool inplace) {
    ggml_init_params init={64*1024*1024,nullptr,false};
    ggml_context * ctx=ggml_init(init);
    const int width=kind==1||kind==2 ? 2*nc:nc;
    ggml_tensor * a=ggml_new_tensor_2d(ctx,GGML_TYPE_F32,width+(strided?32:0),nr);
    if(strided) a=ggml_view_2d(ctx,a,width,nr,a->nb[1],0);
    ggml_tensor * b=kind==3?ggml_new_tensor_2d(ctx,GGML_TYPE_F32,nc,nr):nullptr;
    ggml_tensor * out=kind==0?(inplace?ggml_silu_inplace(ctx,a):ggml_silu(ctx,a)):
        kind==1?ggml_swiglu(ctx,a):kind==2?ggml_swiglu_swapped(ctx,a):ggml_swiglu_split(ctx,a,b);
    ggml_cgraph * graph=ggml_new_graph(ctx);ggml_build_forward_expand(graph,out);
    std::vector<float> expected(size_t(nc)*nr);
    for(int pass=0;pass<3;pass++) {
        fill(a,0x12345678);if(b)fill(b,0x456789ab);
        ggml_backend_cpu_set_n_threads(backend,pass==0?1:236);
        // Explicit reference bypasses the new partitioning even with 236 workers.
        ggml_backend_cpu_set_use_ref(backend,pass==2);
        if(ggml_backend_graph_compute(backend,graph)!=GGML_STATUS_SUCCESS)std::abort();
        for(int r=0;r<nr;r++) {
            const float * p=(float *)((char *)out->data+r*out->nb[1]);
            if(pass==0)memcpy(expected.data()+size_t(r)*nc,p,nc*sizeof(float));
            else {
                for(int c=0;c<nc;c++) {
                    ++checks;
                    if(memcmp(p+c,expected.data()+size_t(r)*nc+c,4)) {
                        printf("FAIL nc=%d nr=%d kind=%d strided=%d inplace=%d pass=%d row=%d col=%d\n",nc,nr,kind,strided,inplace,pass,r,c);
                        ggml_free(ctx);return false;
                    }
                }
            }
        }
    }
    ggml_free(ctx);return true;
}
int main() {
    ggml_backend_t backend=ggml_backend_cpu_init();
    int cases=0;
    for(int nc:{127,128,129,8192,14336})for(int nr:{1,3,23})for(int kind=0;kind<4;kind++) {
        if(!one(backend,nc,nr,kind,false,false))return 1;++cases;
    }
    for(int kind=0;kind<4;kind++) {
        if(!one(backend,129,3,kind,true,false))return 1;++cases;
    }
    for(bool strided:{false,true}) {
        if(!one(backend,8192,1,0,strided,true))return 1;++cases;
    }
    if(!one(backend,128,236,0,false,false))return 1;++cases;
    ggml_backend_free(backend);
    printf("PASS activation partition: %d cases, %zu bit-exact element checks; 1 versus 236 workers and explicit reference, SiLU/SwiGLU split/packed/swapped, tails, strided and in-place\n",cases,checks);
}

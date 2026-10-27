#include "ggml.h"
#include "ggml-cpu.h"
#include "ggml-cpu/quants.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    ggml_cpu_init();
    unsigned checks = 0, cases = 0;
    const int ms[] = {1,3,4,5,7,16,17,33}, ns[] = {1,2,3,17}, ks[] = {32,96,256};
    for (unsigned mi=0; mi<8; ++mi) for (unsigned ni=0; ni<4; ++ni) for (unsigned ki=0; ki<3; ++ki) {
        int m=ms[mi], n=ns[ni], k=ks[ki];
        struct ggml_init_params ip = {16*1024*1024, NULL, false};
        struct ggml_context * ctx=ggml_init(ip);
        if (!ctx) return 2;
        struct ggml_tensor * a=ggml_new_tensor_2d(ctx,GGML_TYPE_Q4_0,k,m);
        struct ggml_tensor * b=ggml_new_tensor_2d(ctx,GGML_TYPE_F32,k,n);
        float * weights=malloc(k*m*sizeof(float));
        block_q8_0 * y=malloc(k/32*sizeof(block_q8_0));
        for (int i=0;i<k*m;++i) weights[i]=sinf(i*0.173f)*3.0f;
        for (int i=0;i<k*n;++i) ((float *)b->data)[i]=cosf(i*0.297f)*2.0f;
        ggml_quantize_chunk(GGML_TYPE_Q4_0,weights,a->data,0,m,k,NULL);
        struct ggml_tensor * out=ggml_mul_mat(ctx,a,b);
        struct ggml_cgraph * graph=ggml_new_graph(ctx);
        ggml_build_forward_expand(graph,out);
        for (int threads=1;threads<=4;threads*=4) {
            if (ggml_graph_compute_with_ctx(ctx,graph,threads)!=GGML_STATUS_SUCCESS) return 3;
            for (int col=0;col<n;++col) {
                quantize_row_q8_0((float *)b->data+col*k,y,k);
                for (int row=0;row<m;++row) {
                    float expected;
                    ggml_vec_dot_q4_0_q8_0(k,&expected,0,(char *)a->data+row*a->nb[1],0,y,0,1);
                    float actual=((float *)out->data)[col*m+row];
                    if (!isfinite(actual) || fabsf(actual-expected)>1e-5f*(1+fabsf(expected))) {
                        printf("FAIL m=%d n=%d k=%d threads=%d row=%d col=%d actual=%g expected=%g\n",m,n,k,threads,row,col,actual,expected); return 1;
                    }
                    ++checks;
                }
            }
            ++cases;
        }
        free(weights);free(y);ggml_free(ctx);
    }
    printf("PASS KNL Q4 dispatcher: %u shapes/thread cases, %u output checks including row/column tails\n",cases,checks);
}

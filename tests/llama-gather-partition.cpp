#include "ggml.h"
#include "ggml-cpu.h"
#include "ggml-backend.h"
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
static size_t checks;
static bool one(ggml_backend_t backend,int nc,int count,bool strided) {
    ggml_init_params init={128*1024*1024,nullptr,false};
    auto *ctx=ggml_init(init);
    auto *base=ggml_new_tensor_4d(ctx,GGML_TYPE_F32,nc+(strided?17:0),4,2,2);
    auto *a=strided?ggml_view_4d(ctx,base,nc,4,2,2,base->nb[1],base->nb[2],base->nb[3],16):base;
    auto *ibase=ggml_new_tensor_3d(ctx,GGML_TYPE_I32,count+(strided?3:0),2,2);
    auto *idx=strided?ggml_view_3d(ctx,ibase,count,2,2,ibase->nb[1],ibase->nb[2],4):ibase;
    uint32_t seed=0x123489af;
    auto *raw=(uint32_t *)base->data;
    for(size_t n=0;n<ggml_nbytes(base)/4;n++) { seed^=seed<<13;seed^=seed>>17;seed^=seed<<5;raw[n]=seed; }
    const uint32_t special[]={0,0x80000000,0x7f800000,0xff800000,0x7fc12345,0x7fa12345,1,0x80000001};
    for(int k=0;k<2;k++)for(int j=0;j<2;j++)for(int row=0;row<4;row++) {
        auto *p=(uint32_t *)((char *)a->data+row*a->nb[1]+j*a->nb[2]+k*a->nb[3]);
        memcpy(p,special,sizeof(special));
    }
    std::vector<uint32_t> preserved(raw,raw+ggml_nbytes(base)/4);
    for(int k=0;k<2;k++)for(int j=0;j<2;j++)for(int i=0;i<count;i++)
        *(int32_t *)((char *)idx->data+i*idx->nb[0]+j*idx->nb[1]+k*idx->nb[2])=(i*7+j+k)%4;
    auto *out=ggml_get_rows(ctx,a,idx);
    const size_t elements=ggml_nelements(out);
    auto *guard=ggml_new_tensor_1d(ctx,GGML_TYPE_F32,elements+32);
    auto *storage=(uint32_t *)guard->data;out->data=storage+16;
    auto *graph=ggml_new_graph(ctx);ggml_build_forward_expand(graph,out);
    for(int pass=0;pass<3;pass++) {
        for(size_t n=0;n<elements+32;n++)storage[n]=0x7fa12345;
        ggml_backend_cpu_set_n_threads(backend,pass==0?1:236);
        ggml_backend_cpu_set_use_ref(backend,pass==2);
        if(ggml_backend_graph_compute(backend,graph)!=GGML_STATUS_SUCCESS)std::abort();
        for(int k=0;k<2;k++)for(int j=0;j<2;j++)for(int i=0;i<count;i++) {
            const int row=(i*7+j+k)%4;
            auto *expected=(const uint32_t *)((const char *)a->data+row*a->nb[1]+j*a->nb[2]+k*a->nb[3]);
            auto *actual=(const uint32_t *)((const char *)out->data+i*out->nb[1]+j*out->nb[2]+k*out->nb[3]);
            for(int c=0;c<nc;c++) { ++checks;if(actual[c]!=expected[c]) { printf("FAIL gather nc=%d count=%d stride=%d pass=%d col=%d\n",nc,count,strided,pass,c);ggml_free(ctx);return false;} }
        }
        for(int n=0;n<16;n++)if(storage[n]!=0x7fa12345||storage[elements+16+n]!=0x7fa12345)std::abort();
        if(memcmp(base->data,preserved.data(),ggml_nbytes(base)))std::abort();
    }
    ggml_free(ctx);return true;
}
int main() {
    auto backend=ggml_backend_cpu_init();int cases=0;
    for(int nc:{4095,4096,4097,8192,262145})for(int count:{1,3,8})for(bool stride:{false,true}) {
        if(!one(backend,nc,count,stride))return 1;++cases;
    }
    if(!one(backend,4097,236,false))return 1;++cases;
    ggml_backend_free(backend);
    printf("PASS gather partition: %d cases, %zu exact raw-bit checks; 1/236/reference workers, four-dimensional sources, strided indices/data, repeated/unsorted rows, tails, input and output guards\n",cases,checks);
}

#include "llama.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <string>
static void set_batch(llama_batch_ext *b,const llama_token *tokens,int count,int start) {
    llama_batch_ext_clear(b);
    for(int i=0;i<count;i++) {
        int index=llama_batch_ext_add_token(b,0,tokens[i]);llama_pos pos=start+i;
        llama_batch_ext_set_pos(b,index,&pos);
    }
    llama_batch_ext_set_output_logits(b,count-1,true);
}
int main(int argc,char **argv) {
    if(argc!=3)return 2;
    llama_backend_init();auto mp=llama_model_default_params();mp.n_gpu_layers=0;mp.load_mode=LLAMA_LOAD_MODE_MMAP;mp.use_extra_bufts=false;
    auto model=llama_model_load_from_file(argv[1],mp);if(!model)return 3;
    auto vocab=llama_model_get_vocab(model);
    const std::string prompt="<|im_start|>user\nIn one sentence, explain why the sky appears blue.<|im_end|>\n<|im_start|>assistant\n<think>\n\n</think>\n\n";
    int count=-llama_tokenize(vocab,prompt.data(),prompt.size(),nullptr,0,true,true);std::vector<llama_token> tokens(count);
    if(llama_tokenize(vocab,prompt.data(),prompt.size(),tokens.data(),count,true,true)!=count)return 4;
    auto cp=llama_context_default_params();cp.n_ctx=256;cp.n_batch=32;cp.n_ubatch=32;cp.n_threads=std::atoi(argv[2]);cp.n_threads_batch=cp.n_threads;cp.flash_attn_type=LLAMA_FLASH_ATTN_TYPE_DISABLED;
    auto ctx=llama_init_from_model(model,cp);if(!ctx)return 5;auto batch=llama_batch_ext_init(ctx);
    set_batch(batch,tokens.data(),count,0);int pos=count;
    for(int step=0;step<32;step++) {
        if(llama_process(ctx,LLAMA_PROCESS_TYPE_DECODE,batch))return 6;
        float *logits=llama_get_logits_ith(ctx,-1);int best=-1,second=-1;
        for(int i=0;i<llama_vocab_n_tokens(vocab);i++) {
            if(best<0||logits[i]>logits[best]) {second=best;best=i;}
            else if(second<0||logits[i]>logits[second])second=i;
        }
        char piece[256];int n=llama_token_to_piece(vocab,best,piece,sizeof(piece),0,true);if(n<0||n>=256)return 7;piece[n]=0;
        std::printf("LOGIT step=%d token=%d score=%.9g second=%d score2=%.9g gap=%.9g piece_hex=",step,best,(double)logits[best],second,(double)logits[second],(double)(logits[best]-logits[second]));
        for(int i=0;i<n;i++)std::printf("%02x",(unsigned char)piece[i]);std::printf("\n");std::fflush(stdout);
        if(llama_vocab_is_eog(vocab,best))break;
        llama_token token=best;set_batch(batch,&token,1,pos++);
    }
    llama_batch_ext_free(batch);llama_free(ctx);llama_model_free(model);llama_backend_free();
}

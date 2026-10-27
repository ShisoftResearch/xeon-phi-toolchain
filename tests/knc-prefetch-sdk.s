.text
.globl knc_prefetch_encoding_oracle
knc_prefetch_encoding_oracle:
    vprefetch0 (%rax)
    ret

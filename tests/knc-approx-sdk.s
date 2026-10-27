.text
.globl approx_encoding
approx_encoding:
 vrcp23ps %zmm1,%zmm2
 vrcp23ps %zmm17,%zmm31
 vrsqrt23ps %zmm1,%zmm2
 vrsqrt23ps %zmm17,%zmm31
 ret

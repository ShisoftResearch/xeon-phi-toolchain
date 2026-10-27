.text
.globl i32_f64_encoding
i32_f64_encoding:
 vcvtdq2pd %zmm1,%zmm2
 vcvtdq2pd %zmm17,%zmm31
 vcvtudq2pd %zmm1,%zmm2
 vcvtudq2pd %zmm17,%zmm31
 vcvtfxpntpd2dq $3,%zmm1,%zmm2
 vcvtfxpntpd2dq $3,%zmm17,%zmm31
 vcvtfxpntpd2udq $3,%zmm1,%zmm2
 vcvtfxpntpd2udq $3,%zmm17,%zmm31
 ret

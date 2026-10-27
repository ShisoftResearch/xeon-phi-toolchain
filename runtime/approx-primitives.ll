; Native IMCI seed primitives. These deliberately expose hardware estimates,
; including DAZ/FTZ behavior, rather than pretending to be exact div/sqrt.
target triple = "x86_64-unknown-linux-gnu"
define void @__knc_rcp23_f32(ptr %out,ptr %in) {
 %x=load <16 x float>,ptr %in,align 64
 %r=call <16 x float> @llvm.x86.knc.rcp23.ps(<16 x float> %x)
 store <16 x float> %r,ptr %out,align 64
 ret void
}
define void @__knc_rsqrt23_f32(ptr %out,ptr %in) {
 %x=load <16 x float>,ptr %in,align 64
 %r=call <16 x float> @llvm.x86.knc.rsqrt23.ps(<16 x float> %x)
 store <16 x float> %r,ptr %out,align 64
 ret void
}
declare <16 x float> @llvm.x86.knc.rcp23.ps(<16 x float>)
declare <16 x float> @llvm.x86.knc.rsqrt23.ps(<16 x float>)

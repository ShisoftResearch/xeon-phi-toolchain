// Generated SIMD cast clients; float-to-int inputs must satisfy simd_cast preconditions.
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f32_2([f32; 2]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f32_4([f32; 4]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f32_8([f32; 8]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f32_16([f32; 16]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f32_32([f32; 32]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f64_2([f64; 2]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f64_4([f64; 4]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f64_8([f64; 8]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f64_16([f64; 16]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_f64_32([f64; 32]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i32_2([i32; 2]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i32_4([i32; 4]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i32_8([i32; 8]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i32_16([i32; 16]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i32_32([i32; 32]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i64_2([i64; 2]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i64_4([i64; 4]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i64_8([i64; 8]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i64_16([i64; 16]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_i64_32([i64; 32]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u32_2([u32; 2]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u32_4([u32; 4]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u32_8([u32; 8]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u32_16([u32; 16]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u32_32([u32; 32]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u64_2([u64; 2]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u64_4([u64; 4]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u64_8([u64; 8]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u64_16([u64; 16]);
#[repr(simd)]
#[derive(Clone, Copy)]
struct V_u64_32([u64; 32]);
#[no_mangle]
pub unsafe extern "C" fn convert_fpext_f32_f64_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_2>().read_unaligned();
    let y: V_f64_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fpext_f32_f64_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_4>().read_unaligned();
    let y: V_f64_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fpext_f32_f64_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_8>().read_unaligned();
    let y: V_f64_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fpext_f32_f64_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_16>().read_unaligned();
    let y: V_f64_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fpext_f32_f64_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_32>().read_unaligned();
    let y: V_f64_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptrunc_f64_f32_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_2>().read_unaligned();
    let y: V_f32_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptrunc_f64_f32_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_4>().read_unaligned();
    let y: V_f32_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptrunc_f64_f32_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_8>().read_unaligned();
    let y: V_f32_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptrunc_f64_f32_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_16>().read_unaligned();
    let y: V_f32_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptrunc_f64_f32_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_32>().read_unaligned();
    let y: V_f32_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f32_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_2>().read_unaligned();
    let y: V_f32_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f32_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_4>().read_unaligned();
    let y: V_f32_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f32_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_8>().read_unaligned();
    let y: V_f32_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f32_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_16>().read_unaligned();
    let y: V_f32_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f32_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_32>().read_unaligned();
    let y: V_f32_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f64_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_2>().read_unaligned();
    let y: V_f64_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f64_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_4>().read_unaligned();
    let y: V_f64_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f64_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_8>().read_unaligned();
    let y: V_f64_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f64_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_16>().read_unaligned();
    let y: V_f64_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i32_f64_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i32_32>().read_unaligned();
    let y: V_f64_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f32_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_2>().read_unaligned();
    let y: V_f32_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f32_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_4>().read_unaligned();
    let y: V_f32_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f32_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_8>().read_unaligned();
    let y: V_f32_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f32_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_16>().read_unaligned();
    let y: V_f32_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f32_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_32>().read_unaligned();
    let y: V_f32_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f64_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_2>().read_unaligned();
    let y: V_f64_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f64_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_4>().read_unaligned();
    let y: V_f64_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f64_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_8>().read_unaligned();
    let y: V_f64_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f64_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_16>().read_unaligned();
    let y: V_f64_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_sitofp_i64_f64_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_i64_32>().read_unaligned();
    let y: V_f64_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f32_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_2>().read_unaligned();
    let y: V_f32_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f32_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_4>().read_unaligned();
    let y: V_f32_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f32_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_8>().read_unaligned();
    let y: V_f32_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f32_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_16>().read_unaligned();
    let y: V_f32_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f32_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_32>().read_unaligned();
    let y: V_f32_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f64_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_2>().read_unaligned();
    let y: V_f64_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f64_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_4>().read_unaligned();
    let y: V_f64_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f64_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_8>().read_unaligned();
    let y: V_f64_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f64_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_16>().read_unaligned();
    let y: V_f64_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i32_f64_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u32_32>().read_unaligned();
    let y: V_f64_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f32_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_2>().read_unaligned();
    let y: V_f32_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f32_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_4>().read_unaligned();
    let y: V_f32_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f32_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_8>().read_unaligned();
    let y: V_f32_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f32_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_16>().read_unaligned();
    let y: V_f32_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f32_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_32>().read_unaligned();
    let y: V_f32_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f32_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f64_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_2>().read_unaligned();
    let y: V_f64_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f64_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_4>().read_unaligned();
    let y: V_f64_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f64_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_8>().read_unaligned();
    let y: V_f64_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f64_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_16>().read_unaligned();
    let y: V_f64_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_uitofp_i64_f64_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_u64_32>().read_unaligned();
    let y: V_f64_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_f64_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i32_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_2>().read_unaligned();
    let y: V_i32_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i32_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_4>().read_unaligned();
    let y: V_i32_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i32_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_8>().read_unaligned();
    let y: V_i32_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i32_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_16>().read_unaligned();
    let y: V_i32_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i32_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_32>().read_unaligned();
    let y: V_i32_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i64_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_2>().read_unaligned();
    let y: V_i64_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i64_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_4>().read_unaligned();
    let y: V_i64_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i64_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_8>().read_unaligned();
    let y: V_i64_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i64_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_16>().read_unaligned();
    let y: V_i64_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f32_i64_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_32>().read_unaligned();
    let y: V_i64_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i32_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_2>().read_unaligned();
    let y: V_i32_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i32_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_4>().read_unaligned();
    let y: V_i32_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i32_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_8>().read_unaligned();
    let y: V_i32_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i32_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_16>().read_unaligned();
    let y: V_i32_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i32_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_32>().read_unaligned();
    let y: V_i32_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i32_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i64_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_2>().read_unaligned();
    let y: V_i64_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i64_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_4>().read_unaligned();
    let y: V_i64_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i64_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_8>().read_unaligned();
    let y: V_i64_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i64_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_16>().read_unaligned();
    let y: V_i64_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptosi_f64_i64_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_32>().read_unaligned();
    let y: V_i64_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_i64_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i32_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_2>().read_unaligned();
    let y: V_u32_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i32_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_4>().read_unaligned();
    let y: V_u32_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i32_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_8>().read_unaligned();
    let y: V_u32_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i32_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_16>().read_unaligned();
    let y: V_u32_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i32_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_32>().read_unaligned();
    let y: V_u32_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i64_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_2>().read_unaligned();
    let y: V_u64_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i64_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_4>().read_unaligned();
    let y: V_u64_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i64_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_8>().read_unaligned();
    let y: V_u64_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i64_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_16>().read_unaligned();
    let y: V_u64_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f32_i64_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f32_32>().read_unaligned();
    let y: V_u64_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i32_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_2>().read_unaligned();
    let y: V_u32_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i32_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_4>().read_unaligned();
    let y: V_u32_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i32_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_8>().read_unaligned();
    let y: V_u32_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i32_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_16>().read_unaligned();
    let y: V_u32_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i32_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_32>().read_unaligned();
    let y: V_u32_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u32_32>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i64_2(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_2>().read_unaligned();
    let y: V_u64_2 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_2>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i64_4(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_4>().read_unaligned();
    let y: V_u64_4 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_4>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i64_8(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_8>().read_unaligned();
    let y: V_u64_8 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_8>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i64_16(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_16>().read_unaligned();
    let y: V_u64_16 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_16>().write_unaligned(y);
}
#[no_mangle]
pub unsafe extern "C" fn convert_fptoui_f64_i64_32(out: *mut u8, input: *const u8) {
    let x = input.cast::<V_f64_32>().read_unaligned();
    let y: V_u64_32 = core::intrinsics::simd::simd_cast(x);
    out.cast::<V_u64_32>().write_unaligned(y);
}

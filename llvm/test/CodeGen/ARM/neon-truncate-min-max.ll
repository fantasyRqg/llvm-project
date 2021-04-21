; RUN: llc < %s -mtriple=armv7-none-linux-gnueabihf -mattr=+neon | FileCheck %s

; test PerformNeonTruncateMinMaxCombine


; Test truncate(smin(smax(a,b),c)) ---> vqmovns(a)


; CHECK-LABEL: @t0
; CHECK: vqmovn.s16 d{{[0-9]+}}, q{{[0-9]+}}
; CHECK: bx lr
define <8 x i8> @t0(<8 x i16> %in) {
  %slt.i = icmp slt <8 x i16> %in, <i16 127, i16 127, i16 127, i16 127, i16 127, i16 127, i16 127, i16 127>
  %min.i = select <8 x i1> %slt.i, <8 x i16> %in, <8 x i16> <i16 127, i16 127, i16 127, i16 127, i16 127, i16 127, i16 127, i16 127>
  %slt.j = icmp sgt <8 x i16> %min.i, <i16 -128, i16 -128, i16 -128, i16 -128, i16 -128, i16 -128, i16 -128, i16 -128>
  %max.i = select <8 x i1> %slt.j, <8 x i16> %min.i, <8 x i16> <i16 -128, i16 -128, i16 -128, i16 -128, i16 -128, i16 -128, i16 -128, i16 -128>
  %trunc.i = trunc <8 x i16> %max.i to <8 x i8>
  ret <8 x i8> %trunc.i
}

; CHECK-LABEL: @t1
; CHECK: vqmovn.s32 d{{[0-9]+}}, q{{[0-9]+}}
; CHECK: bx lr
define <4 x i16> @t1(<4 x i32> %in) {
  %slt.i = icmp slt <4 x i32> %in, <i32 32767, i32 32767, i32 32767, i32 32767>
  %min.i = select <4 x i1> %slt.i, <4 x i32> %in, <4 x i32> <i32 32767, i32 32767, i32 32767, i32 32767>
  %slt.j = icmp sgt <4 x i32> %min.i, <i32 -32768, i32 -32768, i32 -32768, i32 -32768>
  %max.i = select <4 x i1> %slt.j, <4 x i32> %min.i, <4 x i32> <i32 -32768, i32 -32768, i32 -32768, i32 -32768>
  %trunc.i = trunc <4 x i32> %max.i to <4 x i16>
  ret <4 x i16> %trunc.i
}



; Test truncate(umin(a,b)) ---> vqmovnu(a)

; CHECK-LABEL: @t2
; CHECK: vqmovn.u16 d{{[0-9]+}}, q{{[0-9]+}}
; CHECK: bx lr
define <8 x i8> @t2(<8 x i16> %in) {
  %slt.i = icmp ult <8 x i16> %in, <i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255>
  %min.i = select <8 x i1> %slt.i, <8 x i16> %in, <8 x i16> <i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255>
  %trunc.i = trunc <8 x i16> %min.i to <8 x i8>
  ret <8 x i8> %trunc.i
}


; Test truncate(umin(a,b)) ---> vqmovnu(a)

; CHECK-LABEL: @t3
; CHECK: vqmovn.u32 d{{[0-9]+}}, q{{[0-9]+}}
; CHECK: bx lr
define <4 x i16> @t3(<4 x i32> %in) {
  %slt.i = icmp ult <4 x i32> %in, <i32 65535, i32 65535, i32 65535, i32 65535>
  %min.i = select <4 x i1> %slt.i, <4 x i32> %in, <4 x i32> <i32 65535, i32 65535, i32 65535, i32 65535>
  %trunc.i = trunc <4 x i32> %min.i to <4 x i16>
  ret <4 x i16> %trunc.i
}
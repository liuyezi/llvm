; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s

; This file tests cases where simple floating point operations can be
; profitably handled though bit manipulation if a soft-float ABI is being used
; (e.g. fneg implemented by XORing the sign bit). This is typically handled in
; DAGCombiner::visitBITCAST, but this target-independent code may not trigger
; in cases where we perform custom legalisation (e.g. RV64F).

define float @fneg(float %a) nounwind {
; RV32I-LABEL: fneg:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fneg:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
  %1 = fneg float %a
  ret float %1
}

declare float @llvm.fabs.f32(float)

define float @fabs(float %a) nounwind {
; RV32I-LABEL: fabs:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fabs:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
  %1 = call float @llvm.fabs.f32(float %a)
  ret float %1
}
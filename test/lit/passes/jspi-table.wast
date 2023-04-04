;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.

;; RUN: wasm-opt %s --jspi -all -S -o - | filecheck %s

(module
  ;; CHECK:      (type $f64_=>_i32 (func (param f64) (result i32)))

  ;; CHECK:      (type $externref_f64_=>_i32 (func (param externref f64) (result i32)))

  ;; CHECK:      (global $suspender (mut externref) (ref.null noextern))

  ;; CHECK:      (table $0 1 1 funcref)
  (table $0 1 1 funcref)
  (elem (i32.const 1) func $update_state)
  ;; CHECK:      (elem $0 (i32.const 1) $export$update_state)

  ;; CHECK:      (export "update_state" (func $export$update_state))
  (export "update_state" (func $update_state))

  ;; CHECK:      (func $update_state (type $f64_=>_i32) (param $param f64) (result i32)
  ;; CHECK-NEXT:  (i32.const 42)
  ;; CHECK-NEXT: )
  (func $update_state (param $param f64) (result i32)
    (i32.const 42)
  )
)
;; CHECK:      (func $export$update_state (type $externref_f64_=>_i32) (param $susp externref) (param $param f64) (result i32)
;; CHECK-NEXT:  (global.set $suspender
;; CHECK-NEXT:   (local.get $susp)
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (call $update_state
;; CHECK-NEXT:   (local.get $param)
;; CHECK-NEXT:  )
;; CHECK-NEXT: )

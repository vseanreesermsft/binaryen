;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; RUN: wasm-opt %s --post-emscripten -all -S -o - | filecheck %s

;; Test we do not error on invoke calls that take an i64 index (which is the
;; case in wasm64). Nothing should change here.

(module
 ;; CHECK:      (type $0 (func (param i64)))

 ;; CHECK:      (type $1 (func))

 ;; CHECK:      (import "env" "invoke_v" (func $invoke (type $0) (param i64)))
 (import "env" "invoke_v" (func $invoke (param i64)))

 ;; CHECK:      (table $0 269 269 funcref)
 (table $0 269 269 funcref)
 ;; CHECK:      (elem $0 (i32.const 1))
 (elem $0 (i32.const 1))

 ;; CHECK:      (func $0 (type $1)
 ;; CHECK-NEXT:  (call $invoke
 ;; CHECK-NEXT:   (i64.const 42)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $0
  (call $invoke
   (i64.const 42)
  )
 )
)


;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --simplify-locals --traps-never-happen -all -S -o - | filecheck %s --check-prefix TNH
;; RUN: wasm-opt %s --simplify-locals                      -all -S -o - | filecheck %s --check-prefix NO_TNH


(module
  (memory 1 1)

  ;; TNH:      (global $glob (mut i32) (i32.const 0))
  ;; NO_TNH:      (global $glob (mut i32) (i32.const 0))
  (global $glob (mut i32) (i32.const 0))

  ;; TNH:      (func $optimize-past-global.set (type $0) (result i32)
  ;; TNH-NEXT:  (local $temp i32)
  ;; TNH-NEXT:  (nop)
  ;; TNH-NEXT:  (global.set $glob
  ;; TNH-NEXT:   (i32.const 1)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (i32.load
  ;; TNH-NEXT:   (i32.const 0)
  ;; TNH-NEXT:  )
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $optimize-past-global.set (type $0) (result i32)
  ;; NO_TNH-NEXT:  (local $temp i32)
  ;; NO_TNH-NEXT:  (local.set $temp
  ;; NO_TNH-NEXT:   (i32.load
  ;; NO_TNH-NEXT:    (i32.const 0)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (global.set $glob
  ;; NO_TNH-NEXT:   (i32.const 1)
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (local.get $temp)
  ;; NO_TNH-NEXT: )
  (func $optimize-past-global.set (result i32)
    (local $temp i32)
    ;; This load might trap, and so normally we can't move it past a global.set,
    ;; which has a global effect that could be noticed. However, in TNH mode we
    ;; can assume it doesn't trap and push it forward.
    (local.set $temp
      (i32.load
        (i32.const 0)
      )
    )
    (global.set $glob
      (i32.const 1)
    )
    (local.get $temp)
  )

  ;; TNH:      (func $no-optimize-past-return (type $0) (result i32)
  ;; TNH-NEXT:  (local $temp i32)
  ;; TNH-NEXT:  (local.set $temp
  ;; TNH-NEXT:   (i32.load
  ;; TNH-NEXT:    (i32.const 0)
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (if
  ;; TNH-NEXT:   (i32.const 0)
  ;; TNH-NEXT:   (then
  ;; TNH-NEXT:    (return
  ;; TNH-NEXT:     (i32.const 1)
  ;; TNH-NEXT:    )
  ;; TNH-NEXT:   )
  ;; TNH-NEXT:  )
  ;; TNH-NEXT:  (local.get $temp)
  ;; TNH-NEXT: )
  ;; NO_TNH:      (func $no-optimize-past-return (type $0) (result i32)
  ;; NO_TNH-NEXT:  (local $temp i32)
  ;; NO_TNH-NEXT:  (local.set $temp
  ;; NO_TNH-NEXT:   (i32.load
  ;; NO_TNH-NEXT:    (i32.const 0)
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (if
  ;; NO_TNH-NEXT:   (i32.const 0)
  ;; NO_TNH-NEXT:   (then
  ;; NO_TNH-NEXT:    (return
  ;; NO_TNH-NEXT:     (i32.const 1)
  ;; NO_TNH-NEXT:    )
  ;; NO_TNH-NEXT:   )
  ;; NO_TNH-NEXT:  )
  ;; NO_TNH-NEXT:  (local.get $temp)
  ;; NO_TNH-NEXT: )
  (func $no-optimize-past-return (result i32)
    (local $temp i32)
    ;; As above, but now the thing in the middle may transfer control flow. We
    ;; can in principle optimize here (moving a trap to possibly not happen
    ;; later is fine, in TNH mode), but SimplifyLocals only works in a single
    ;; basic block so we don't atm.
    (local.set $temp
      (i32.load
        (i32.const 0)
      )
    )
    (if
      (i32.const 0)
      (then
        (return
          (i32.const 1)
        )
      )
    )
    (local.get $temp)
  )
)

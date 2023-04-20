;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --code-pushing -all -S -o - | filecheck %s

(module
  ;; CHECK:      (func $br_on (type $none_=>_none)
  ;; CHECK-NEXT:  (local $x funcref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block $out (result (ref func))
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (br_on_func $out
  ;; CHECK-NEXT:      (ref.func $br_on)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (ref.func $br_on)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (ref.func $br_on)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $br_on
    (local $x (ref null func))
    (drop
      (block $out (result (ref func))
        ;; We can push the local.set past the br_on.
        (local.set $x (ref.func $br_on))
        (drop
          (br_on_func $out
            (ref.func $br_on)
          )
        )
        (drop
          (local.get $x)
        )
        (ref.func $br_on)
      )
    )
  )

  ;; CHECK:      (func $br_on_no (type $none_=>_none)
  ;; CHECK-NEXT:  (local $x funcref)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (block $out (result (ref func))
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (ref.func $br_on_no)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (br_on_func $out
  ;; CHECK-NEXT:      (ref.func $br_on_no)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (ref.func $br_on_no)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $br_on_no
    (local $x (ref null func))
    ;; We can't push here since the local.get is outside of the loop.
    (drop
      (block $out (result (ref func))
        (local.set $x (ref.func $br_on_no))
        (drop
          (br_on_func $out
            (ref.func $br_on_no)
          )
        )
        (ref.func $br_on_no)
      )
    )
    (drop
      (local.get $x)
    )
  )
)

;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; Test that a trivial recursive type works properly

;; RUN: wasm-opt %s -all --name-types -S -o - | filecheck %s

(module
  (type (func (param (ref null 0)) (result (ref null 0))))
  (type (func (param (ref null 1)) (result (ref null 1))))
  (type (func (param (ref null 0)) (result (ref null 1))))
  (rec
    ;; CHECK:      (type $type$0 (func (param (ref null $type$0)) (result (ref null $type$0))))

    ;; CHECK:      (rec
    ;; CHECK-NEXT:  (type $f3 (func (param (ref null $type$2)) (result (ref null $f3))))
    (type $f3 (func (param (ref null 4)) (result (ref null 3))))
    (type (func_subtype (param (ref null 3)) (result (ref null 4)) $f3))
  )

  ;; CHECK:       (type $type$2 (sub $f3 (func (param (ref null $f3)) (result (ref null $type$2)))))

  ;; CHECK:      (type $type$1 (func (param (ref null $type$0)) (result (ref null $type$0))))

  ;; CHECK:      (func $foo (type $type$0) (param $0 (ref null $type$0)) (result (ref null $type$0))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $foo (type 0)
    (unreachable)
  )

  ;; CHECK:      (func $bar (type $type$0) (param $0 (ref null $type$0)) (result (ref null $type$0))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $bar (type 1)
    (unreachable)
  )

  ;; CHECK:      (func $baz (type $type$1) (param $0 (ref null $type$0)) (result (ref null $type$0))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $baz (type 2)
    (unreachable)
  )

  ;; CHECK:      (func $qux (type $f3) (param $0 (ref null $type$2)) (result (ref null $f3))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $qux (type 3)
    (unreachable)
  )

  ;; CHECK:      (func $quux (type $type$2) (param $0 (ref null $f3)) (result (ref null $type$2))
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $quux (type 4)
    (unreachable)
  )
)

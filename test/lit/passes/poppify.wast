;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; TODO: enable validation
;; RUN: wasm-opt %s --poppify --no-validation -all -S -o - | filecheck %s

(module
  ;; CHECK:      (tag $e (param i32))
  (tag $e (param i32))

  ;; CHECK:      (func $id (type $4) (param $x i32) (result i32)
  ;; CHECK-NEXT:  (local.get $x)
  ;; CHECK-NEXT: )
  (func $id (param $x i32) (result i32)
    (local.get $x)
  )

  ;; CHECK:      (func $add (type $5) (param $x i32) (param $y i32) (result i32)
  ;; CHECK-NEXT:  (local.get $x)
  ;; CHECK-NEXT:  (local.get $y)
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $add (param $x i32) (param $y i32) (result i32)
    (i32.add
      (local.get $x)
      (local.get $y)
    )
  )

  ;; CHECK:      (func $expr-tree (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i32.const 1)
  ;; CHECK-NEXT:  (i32.mul
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.const 2)
  ;; CHECK-NEXT:  (i32.const 3)
  ;; CHECK-NEXT:  (i32.mul
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $expr-tree (result i32)
    (i32.add
      (i32.mul
        (i32.const 0)
        (i32.const 1)
      )
      (i32.mul
        (i32.const 2)
        (i32.const 3)
      )
    )
  )

  ;; CHECK:      (func $block (type $0) (result i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $block (result i32)
    (block i32
      (nop)
      (i32.const 0)
    )
  )

  ;; CHECK:      (func $nested (type $0) (result i32)
  ;; CHECK-NEXT:  (block $block (result i32)
  ;; CHECK-NEXT:   (block $block0 (result i32)
  ;; CHECK-NEXT:    (block $block1 (result i32)
  ;; CHECK-NEXT:     (i32.const 0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $nested (result i32)
    (block $block i32
      (block $block0 i32
        (block $block1 i32
          (i32.const 0)
        )
      )
    )
  )

  ;; CHECK:      (func $nested-nonames (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $nested-nonames (result i32)
    (block i32
      (block i32
        (block i32
          (i32.const 0)
        )
      )
    )
  )

  ;; CHECK:      (func $child-blocks (type $0) (result i32)
  ;; CHECK-NEXT:  (block $block (result i32)
  ;; CHECK-NEXT:   (block $block0 (result i32)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block $block1 (result i32)
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (i32.add
  ;; CHECK-NEXT:    (pop i32)
  ;; CHECK-NEXT:    (pop i32)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $child-blocks (result i32)
    (block $block (result i32)
      (i32.add
        (block $block0 (result i32)
          (i32.const 0)
        )
        (block $block1 (result i32)
          (i32.const 1)
        )
      )
    )
  )

  ;; CHECK:      (func $child-blocks-nonames (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i32.const 1)
  ;; CHECK-NEXT:  (i32.add
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $child-blocks-nonames (result i32)
    (block (result i32)
      (i32.add
        (block (result i32)
          (i32.const 0)
        )
        (block (result i32)
          (i32.const 1)
        )
      )
    )
  )

  ;; CHECK:      (func $block-br (type $0) (result i32)
  ;; CHECK-NEXT:  (block $l (result i32)
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (br $l
  ;; CHECK-NEXT:    (pop i32)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $block-br (result i32)
    (block $l i32
      (nop)
      (br $l
        (i32.const 0)
      )
    )
  )

  ;; CHECK:      (func $loop (type $2)
  ;; CHECK-NEXT:  (loop $l
  ;; CHECK-NEXT:   (br $l)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $loop
    (loop $l
      (br $l)
    )
  )

  ;; CHECK:      (func $if (type $2)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (nop)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if
    (if
      (i32.const 0)
      (then
        (nop)
      )
    )
  )

  ;; CHECK:      (func $if-else (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (if (result i32)
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:   (then
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (else
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-else (result i32)
    (if i32
      (i32.const 0)
      (then
        (i32.const 1)
      )
      (else
        (i32.const 2)
      )
    )
  )

  ;; CHECK:      (func $try-catch (type $0) (result i32)
  ;; CHECK-NEXT:  (try $try (result i32)
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (throw $e
  ;; CHECK-NEXT:     (pop i32)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch_all
  ;; CHECK-NEXT:    (i32.const 1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $try-catch (result i32)
    (try i32
      (do
        (throw $e
          (i32.const 0)
        )
      )
      (catch $e
        (pop i32)
      )
      (catch_all
        (i32.const 1)
      )
    )
  )

  ;; CHECK:      (func $try-delegate (type $0) (result i32)
  ;; CHECK-NEXT:  (try $l0 (result i32)
  ;; CHECK-NEXT:   (do
  ;; CHECK-NEXT:    (try $try
  ;; CHECK-NEXT:     (do
  ;; CHECK-NEXT:      (i32.const 0)
  ;; CHECK-NEXT:      (throw $e
  ;; CHECK-NEXT:       (pop i32)
  ;; CHECK-NEXT:      )
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:     (delegate $l0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (unreachable)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (catch $e
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $try-delegate (result i32)
    (try $l0 i32
      (do
        (try
          (do
            (throw $e
              (i32.const 0)
            )
          )
          (delegate $l0)
        )
      )
      (catch $e
        (pop i32)
      )
    )
  )

  ;; CHECK:      (func $tuple (type $1) (result i32 i64)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT: )
  (func $tuple (result i32 i64)
    (tuple.make 2
      (i32.const 0)
      (i64.const 1)
    )
  )

  ;; CHECK:      (func $extract-first (type $0) (result i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT:  (f32.const 2)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (pop f32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (pop i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $extract-first (result i32)
    (tuple.extract 3 0
      (tuple.make 3
        (i32.const 0)
        (i64.const 1)
        (f32.const 2)
      )
    )
  )

  ;; CHECK:      (func $extract-middle (type $6) (result i64)
  ;; CHECK-NEXT:  (local $0 i64)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT:  (f32.const 2)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (pop f32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $0
  ;; CHECK-NEXT:   (pop i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $0)
  ;; CHECK-NEXT: )
  (func $extract-middle (result i64)
    (tuple.extract 3 1
      (tuple.make 3
        (i32.const 0)
        (i64.const 1)
        (f32.const 2)
      )
    )
  )

  ;; CHECK:      (func $extract-last (type $7) (result f32)
  ;; CHECK-NEXT:  (local $0 f32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT:  (f32.const 2)
  ;; CHECK-NEXT:  (local.set $0
  ;; CHECK-NEXT:   (pop f32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (pop i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $0)
  ;; CHECK-NEXT: )
  (func $extract-last (result f32)
    (tuple.extract 3 2
      (tuple.make 3
        (i32.const 0)
        (i64.const 1)
        (f32.const 2)
      )
    )
  )

  ;; CHECK:      (func $drop (type $2)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop
    (drop
      (i32.const 0)
    )
  )

  ;; CHECK:      (func $drop-tuple (type $2)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (pop i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $drop-tuple
    (tuple.drop 2
      (tuple.make 2
        (i32.const 0)
        (i64.const 1)
      )
    )
  )

  ;; CHECK:      (func $local-get-tuple (type $1) (result i32 i64)
  ;; CHECK-NEXT:  (local $x (i32 i64))
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i64)
  ;; CHECK-NEXT:  (local.get $1)
  ;; CHECK-NEXT:  (local.get $2)
  ;; CHECK-NEXT: )
  (func $local-get-tuple (result i32 i64)
    (local $x (i32 i64))
    (local.get $x)
  )

  ;; CHECK:      (func $local-set (type $2)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $local-set
    (local $x i32)
    (local.set $x
      (i32.const 0)
    )
  )

  ;; CHECK:      (func $local-set-tuple (type $2)
  ;; CHECK-NEXT:  (local $x (i32 i64))
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i64)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT:  (local.set $2
  ;; CHECK-NEXT:   (pop i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $1
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $local-set-tuple
    (local $x (i32 i64))
    (local.set $x
      (tuple.make 2
        (i32.const 0)
        (i64.const 1)
      )
    )
  )

  ;; CHECK:      (func $local-tee-tuple (type $1) (result i32 i64)
  ;; CHECK-NEXT:  (local $x (i32 i64))
  ;; CHECK-NEXT:  (local $1 i32)
  ;; CHECK-NEXT:  (local $2 i64)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT:  (local.set $2
  ;; CHECK-NEXT:   (pop i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.tee $1
  ;; CHECK-NEXT:   (pop i32)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $2)
  ;; CHECK-NEXT: )
  (func $local-tee-tuple (result i32 i64)
    (local $x (i32 i64))
    (local.tee $x
      (tuple.make 2
        (i32.const 0)
        (i64.const 1)
      )
    )
  )

  ;; CHECK:      (func $break-tuple (type $1) (result i32 i64)
  ;; CHECK-NEXT:  (block $l (type $1) (result i32 i64)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i64.const 1)
  ;; CHECK-NEXT:   (br $l
  ;; CHECK-NEXT:    (pop i32 i64)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $break-tuple (result i32 i64)
    (block $l (result i32 i64)
      (br $l
        (tuple.make 2
          (i32.const 0)
          (i64.const 1)
        )
      )
    )
  )

  ;; CHECK:      (func $return-tuple (type $1) (result i32 i64)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT:  (i64.const 1)
  ;; CHECK-NEXT:  (return
  ;; CHECK-NEXT:   (pop i32 i64)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $return-tuple (result i32 i64)
    (return
      (tuple.make 2
        (i32.const 0)
        (i64.const 1)
      )
    )
  )
)

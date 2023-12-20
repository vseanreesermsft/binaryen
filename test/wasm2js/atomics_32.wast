(module
  (memory (shared 256 256))
  (data "hello,")
  (data "world!")
  (func $test (export "test")
    (local $x i32)
    (local $y i64)
    (local.set $x (i32.atomic.rmw8.cmpxchg_u (i32.const 1024) (i32.const 1) (i32.const 2)))
    (local.set $x (i32.atomic.rmw16.cmpxchg_u (i32.const 1024) (i32.const 1) (i32.const 2)))
    (local.set $x (i32.atomic.rmw.cmpxchg (i32.const 1024) (i32.const 1) (i32.const 2)))
    (local.set $x (i32.atomic.load8_u (i32.const 1028)))
    (local.set $x (i32.atomic.load16_u (i32.const 1028)))
    (local.set $x (i32.atomic.load (i32.const 1028)))
    (i32.atomic.store (i32.const 100) (i32.const 200))
    (local.set $x (memory.atomic.wait32 offset=4 (i32.const 8) (i32.const 16) (i64.const -1)))
    (memory.init 0 (i32.const 512) (i32.const 0) (i32.const 4))
    (memory.init 1 (i32.const 1024) (i32.const 4) (i32.const 2))
    (local.set $x (memory.atomic.notify (i32.const 4) (i32.const 2)))
    (local.set $x (memory.atomic.notify offset=20 (i32.const 4) (i32.const -1)))
    (local.set $x (i32.atomic.rmw.add (i32.const 8) (i32.const 12)))
    (local.set $x (i32.atomic.rmw.sub (i32.const 8) (i32.const 12)))
    (local.set $x (i32.atomic.rmw.and (i32.const 8) (i32.const 12)))
    (local.set $x (i32.atomic.rmw.or (i32.const 8) (i32.const 12)))
    (local.set $x (i32.atomic.rmw.xor (i32.const 8) (i32.const 12)))
    (local.set $x (i32.atomic.rmw.xchg (i32.const 8) (i32.const 12)))
    (local.set $x (i32.atomic.rmw8.add_u (i32.const 8) (i32.const 12)))
    (local.set $x (i32.atomic.rmw16.sub_u (i32.const 8) (i32.const 12)))
    (local.set $y (i64.atomic.rmw.add (i32.const 8) (i64.const 16)))
    (local.set $y (i64.atomic.rmw.xor offset=32 (i32.const 8) (i64.const -1)))
  )
)

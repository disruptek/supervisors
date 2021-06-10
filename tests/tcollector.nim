import balls
import cps

import supervisors/collector

suite "collector":

  block:
    ## test of the collector
    type
      C = ref object of Continuation

    var x = 0

    proc noop(c: C): C {.cpsMagic.} = c

    proc bar(y: int) {.cps: C.} =
      noop()
      for i in 0 .. y:
        inc x

    proc foo(y: int) {.cps: C.} =
      inc x
      bar(y)
      inc x

    let a = whelp foo(2)
    let b = whelp foo(3)

    collector @[a, b]
    check x == 9

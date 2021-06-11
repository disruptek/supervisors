import balls
import cps

import supervisors/sequential

suite "sequential":

  block:
    ## test of sequential
    type
      C = ref object of Continuation

    var x = 0

    proc noop(c: C): C {.cpsMagic.} = c

    proc bar(y: int) {.cps: C.} =
      noop()
      for i in 0 .. y:
        inc x
      case y
      of 2: check x == 4
      of 3: check x == 10
      else: fail"unexpected"

    proc foo(y: int) {.cps: C.} =
      inc x
      bar(y)
      inc x

    let a: Continuation = whelp foo(2)
    let b: Continuation = whelp foo(3)

    let cs = sequential @[a, b]
    check x == 11
    for c in cs.items:
      check "bad member continuation state":
        not c.dismissed
        c.finished

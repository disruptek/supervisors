import std/macros
import std/deques

import cps

type
  Collector = ref object of Continuation
    queue: Deque[Continuation]

proc setup(s: Collector;
           cs: seq[Continuation]): Collector {.cpsMagic.} =
  s.queue = cs.toDeque
  result = s

proc len(s: Collector): int {.cpsVoodoo.} =
  len s.queue

proc pop(s: Collector): Continuation {.cpsVoodoo.} =
  popFirst s.queue

proc push(s: Collector; c: Continuation) {.cpsVoodoo.} =
  addLast s.queue: c

expandMacros:
  proc collector*(cs: seq[Continuation]) {.cps: Collector.} =
    setup cs
    while len() > 0:
      var c = pop()
      while c.running:
        c = c.fn(c)
      if not c.dismissed:
        push c

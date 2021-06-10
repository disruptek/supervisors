import std/deques

import cps

type
  Collector = ref object of Continuation
    queue: Deque[Continuation]

proc setup[T: Continuation](s: Collector; cs: openArray[T]): Collector {.cpsMagic.} =
  s.queue = cs.toDeque
  result = s

proc len(s: Collector): int {.cpsVoodoo.} =
  len s.queue

proc pop(s: Collector): Continuation {.cpsVoodoo.} =
  popFirst s.queue

proc push(s: Collector; c: Continuation) {.cpsVoodoo.} =
  addLast s.queue: c

proc collector*[T: Continuation](cs: seq[T]) {.cps: Collector.} =
  setup cs
  while len() > 0:
    var c = pop()
    c = trampoline c
    if not c.dismissed:
      push c

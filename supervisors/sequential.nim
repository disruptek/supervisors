import cps

type
  Sequential = ref object of Continuation

proc sequential*(cs: seq[Continuation]): seq[Continuation] {.cps: Sequential.} =
  result = cs
  var index = 0
  while index < result.len:
    var c = result[index]
    while c.running:
      c = c.fn(c)
    result[index] = c
    inc index

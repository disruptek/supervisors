version = "0.0.2"
author = "disruptek"
description = "hot dispatcher-on-dispatcher action"
license = "MIT"

when not defined(release):
  requires "https://github.com/disruptek/balls >= 3.0.0 & < 4.0.0"
requires "https://github.com/disruptek/cps >= 0.0.28 & < 1.0.0"

task test, "run tests for ci":
  when defined(windows):
    exec "balls.cmd"
  else:
    exec "balls"

task demo, "produce a demo":
  exec """demo docs/demo.svg "nim c --define:release --out=\$1 tests/test.nim""""


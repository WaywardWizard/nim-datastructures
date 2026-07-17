# Package
version       = "1.2.0"
author        = "Ben Tomlin"
description   = "Useful datastructures for algorithms. BiMap, BiMapSeq, IndexedList"
license       = "MIT"
srcDir        = "src"

# Tasks
when fileExists "tasks.nims":
  include "tasks.nims"

 # Dependencies
requires "nim >= 1.2.18"

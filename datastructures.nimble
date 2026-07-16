# Package

version       = "1.1.0"
author        = "Ben Tomlin"
description   = "Useful datastructures for algorithms. BiMap, BiMapSeq, IndexedList"
license       = "MIT"
srcDir        = "src"
installFiles  = @["tasks.nims"] # relative to root
installExt    = @["nim"] # inside src
installDir    = @[] # relative to root


# Dependencies

requires "nim >= 1.2.18"

include ./tasks.nims

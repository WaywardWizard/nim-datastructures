# Package
include ./tasks.nims
version       = "1.1.0"
author        = "Ben Tomlin"
description   = "Useful datastructures for algorithms. BiMap, BiMapSeq, IndexedList"
license       = "MIT"
srcDir        = "src"

proc findfiles(dir: string = ".", ipath: openArray[string] = ["*"]): seq[string] =
  for pattern in ipath:
    result.add gorgeEx("find $# -ipath $#" % [dir, pattern]).output.splitlines()

let fileSelectors = [("src",["*.nim"]), (".", ["*/task.nims"])]

 
# relative to root. srcDir, installFiles, installExt, installDirs are limited
#   - srcDir will set the search directory to this
#     - install{Files,Dirs,Ext} will then be jailed in srcDir
#     - jailed because "../" in a filename does not get interpreted
#   - omitting srcDir will set the searchdir to the repository root
#     - installFiles will now have access to any file
#     - install{Ext,Dirs} will now not be granular enough
#
# the approach then is to list files explicitly
installFiles = @[]
for (folder,patterns) in fileSelectors:
  installFiles.add folder.findfiles(patterns)
  
 # Dependencies
requires "nim >= 1.2.18"

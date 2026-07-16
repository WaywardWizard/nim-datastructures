# Package

version       = "1.1.0"
author        = "Ben Tomlin"
description   = "Useful datastructures for algorithms. BiMap, BiMapSeq, IndexedList"
license       = "MIT"
srcDir        = "src"

import std/[dirs,sugar]
let
  idirExt = [(src,["nim"])]
  ifiles = @["tasks.nims"]
var ifiles = collect:
  for (jdir,jexts) in idirExt:
    for x in walkDirRec(jdir):
      if jdir.splitFile[2] == jext: x
  for x in ifiles: x
        
# relative to root. srcDir, installFiles, installExt, installDirs are limited
#   - srcDir will set the search directory to this
#     - install{Files,Dirs,Ext} will then be jailed in srcDir
#     - jailed because "../" in a filename does not get interpreted
#   - omitting srcDir will set the searchdir to the repository root
#     - installFiles will now have access to any file
#     - install{Ext,Dirs} will now not be granular enough
installFiles  = ifiles


# Dependencies

requires "nim >= 1.2.18"

include ./tasks.nims

import std/unittest

import datastructures

suite "BiMap forward":
  test "set by key then forward lookup":
    var bm: BiMap[string, int]
    bm["a"] = 1
    check bm["a"] == 1

  test "set by value then reverse lookup":
    var bm: BiMap[string, int]
    bm[1] = "a"
    check bm[1] == "a"
    check bm["a"] == 1

  test "reverse lookup of inserted pair":
    var bm: BiMap[string, int]
    bm["a"] = 1
    check bm[1] == "a"

  test "multiple pairs forward and reverse":
    var bm: BiMap[string, int]
    bm["a"] = 1
    bm["b"] = 2
    bm["c"] = 3
    check bm["a"] == 1
    check bm["b"] == 2
    check bm["c"] == 3
    check bm[1] == "a"
    check bm[2] == "b"
    check bm[3] == "c"

suite "BiMap contains":
  test "contains key after insert":
    var bm: BiMap[string, int]
    bm["a"] = 1
    check "a" in bm
    check 1 in bm

  test "notin for absent key and value":
    var bm: BiMap[string, int]
    bm["a"] = 1
    check "b" notin bm
    check 2 notin bm

  test "empty bimap contains nothing":
    var bm: BiMap[string, int]
    check "a" notin bm
    check 1 notin bm

suite "BiMap swap":
  test "swap by keys exchanges values":
    var bm: BiMap[string, int]
    bm["a"] = 1
    bm["b"] = 2
    bm.swap("a", "b")
    check bm["a"] == 2
    check bm["b"] == 1
    check bm[1] == "b"
    check bm[2] == "a"

  test "swap by values exchanges keys":
    var bm: BiMap[string, int]
    bm["a"] = 1
    bm["b"] = 2
    bm.swap(1, 2)
    check bm["a"] == 2
    check bm["b"] == 1
    check bm[1] == "b"
    check bm[2] == "a"

  test "swap by keys leaves other entries untouched":
    var bm: BiMap[string, int]
    bm["a"] = 1
    bm["b"] = 2
    bm["c"] = 3
    bm.swap("a", "b")
    check bm["c"] == 3
    check bm[3] == "c"

suite "BiMapSeq insert and lookup":
  test "multiple values accumulate under one key":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm["a"] = 3
    check bm["a"] == @[1, 2, 3]

  test "values are partitioned across keys":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm["b"] = 3
    check bm["a"] == @[1, 2]
    check bm["b"] == @[3]

  test "reverse lookup returns full seq sharing the value's key":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm["b"] = 3
    check bm[1] == @[1, 2]
    check bm[2] == @[1, 2]
    check bm[3] == @[3]

  test "duplicate value under a different key raises":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    expect ValueError:
      bm["b"] = 1

  test "duplicate value under same key raises":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    expect ValueError:
      bm["a"] = 1

suite "BiMapSeq reverse assignment":
  test "insert via reverse assignment delegates to forward setter":
    var bm: BiMapSeq[string, int]
    bm[1] = "a"
    bm[2] = "a"
    check bm["a"] == @[1, 2]

  test "reverse lookup is consistent after reverse assignment":
    var bm: BiMapSeq[string, int]
    bm[1] = "a"
    bm[2] = "a"
    check bm[1] == @[1, 2]
    check bm[2] == @[1, 2]

  test "find resolves the owning key after reverse assignment":
    var bm: BiMapSeq[string, int]
    bm[1] = "a"
    bm[3] = "b"
    check bm.find(1) == "a"
    check bm.find(3) == "b"

  test "reverse assignment partitions values across keys":
    var bm: BiMapSeq[string, int]
    bm[1] = "a"
    bm[2] = "a"
    bm[3] = "b"
    check bm["a"] == @[1, 2]
    check bm["b"] == @[3]

  test "reverse assignment of a duplicate value raises":
    var bm: BiMapSeq[string, int]
    bm[1] = "a"
    expect ValueError:
      bm[1] = "b"

suite "BiMapSeq contains and find":
  test "contains reports key and value presence":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    check "a" in bm
    check 1 in bm
    check 2 in bm

  test "notin for absent key and value":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    check "b" notin bm
    check 2 notin bm

  test "find returns the key that owns the value":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm["b"] = 3
    check bm.find(1) == "a"
    check bm.find(2) == "a"
    check bm.find(3) == "b"

suite "BiMapSeq del":
  test "del by key removes all values":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm["b"] = 3
    bm.del("a")
    check "a" notin bm
    check 1 notin bm
    check 2 notin bm
    check "b" in bm
    check 3 in bm

  test "del by value at middle of seq reindexes remaining":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm["a"] = 3
    bm.del(2)
    check bm["a"] == @[1, 3]
    check 2 notin bm
    check bm.find(3) == "a"
    # exercising the reindexed tail again to confirm consistency
    bm.del(3)
    check bm["a"] == @[1]

  test "del by value at head of seq reindexes remaining":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm["a"] = 3
    bm.del(1)
    check bm["a"] == @[2, 3]
    check 1 notin bm
    check bm.find(2) == "a"
    check bm.find(3) == "a"

  test "del by value at tail of seq":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm["a"] = 3
    bm.del(3)
    check bm["a"] == @[1, 2]
    check 3 notin bm

  test "del last value under a key drops the key":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm.del(1)
    check "a" notin bm
    check 1 notin bm

suite "BiMapSeq rekey":
  test "rekey moves a value to a new key":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm.rekey(1, "b")
    check bm["a"] == @[2]
    check bm["b"] == @[1]
    check bm.find(1) == "b"

  test "rekey to an existing key appends":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["b"] = 2
    bm.rekey(1, "b")
    check "a" notin bm
    check bm["b"] == @[2, 1]

suite "BiMapSeq pop":
  test "pop returns and removes the last value under a key":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    bm["a"] = 2
    bm["a"] = 3
    check bm.pop("a") == 3
    check bm["a"] == @[1, 2]
    check 3 notin bm

  test "pop on single-value key drops the key":
    var bm: BiMapSeq[string, int]
    bm["a"] = 1
    check bm.pop("a") == 1
    check "a" notin bm
    check 1 notin bm

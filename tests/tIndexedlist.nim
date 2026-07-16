import std/[unittest, sequtils, lists]

import datastructures

type
  SIL = IndexedList[SinglyLinkedList[int]]
  DIL = IndexedList[DoublyLinkedList[string]]

suite "IndexedList add and iterate":
  test "add appends and len reflects size":
    var il: SIL
    il.add(1)
    il.add(2)
    il.add(3)
    check il.len == 3

  test "items yields in insertion order":
    var il: SIL
    il.add(1)
    il.add(2)
    il.add(3)
    check toSeq(il.items) == @[1, 2, 3]

  test "empty list has zero length":
    var il: SIL
    check il.len == 0

suite "IndexedList contains":
  test "contains reports presence of inserted value":
    var il: SIL
    il.add(1)
    il.add(2)
    check 1 in il
    check 2 in il

  test "notin for absent value":
    var il: SIL
    il.add(1)
    check 2 notin il

  test "contains is false for removed value":
    var il: SIL
    il.add(1)
    il.add(2)
    il.del(1)
    check 1 notin il
    check 2 in il

suite "IndexedList prepend":
  test "prepend places value at head":
    var il: SIL
    il.add(1)
    il.add(2)
    il.prepend(0)
    check toSeq(il.items) == @[0, 1, 2]
    check il.len == 3

  test "prepend on empty list":
    var il: SIL
    il.prepend(0)
    check toSeq(il.items) == @[0]
    check il.len == 1

suite "IndexedList duplicate handling":
  test "add of an existing value raises":
    var il: SIL
    il.add(1)
    expect ValueError:
      il.add(1)

  test "prepend of an existing value raises":
    var il: SIL
    il.add(1)
    expect ValueError:
      il.prepend(1)

  test "adding a removed value is permitted":
    var il: SIL
    il.add(1)
    il.del(1)
    il.add(1)
    check toSeq(il.items) == @[1]

suite "IndexedList del":
  test "del from middle preserves order":
    var il: SIL
    il.add(1)
    il.add(2)
    il.add(3)
    il.del(2)
    check il.len == 2
    check toSeq(il.items) == @[1, 3]

  test "del head":
    var il: SIL
    il.add(1)
    il.add(2)
    il.add(3)
    il.del(1)
    check toSeq(il.items) == @[2, 3]

  test "del tail":
    var il: SIL
    il.add(1)
    il.add(2)
    il.add(3)
    il.del(3)
    check toSeq(il.items) == @[1, 2]

suite "IndexedList popFirst":
  test "popFirst returns and removes the head":
    var il: SIL
    il.add(1)
    il.add(2)
    il.add(3)
    check il.popFirst() == 1
    check il.len == 2
    check toSeq(il.items) == @[2, 3]

  test "popFirst on single element empties the list":
    var il: SIL
    il.add(1)
    check il.popFirst() == 1
    check il.len == 0

suite "IndexedList popLast":
  test "popLast returns and removes the tail":
    var il: SIL
    il.add(1)
    il.add(2)
    il.add(3)
    check il.popLast() == 3
    check il.len == 2
    check toSeq(il.items) == @[1, 2]

  test "popLast on single element empties the list":
    var il: SIL
    il.add(1)
    check il.popLast() == 1
    check il.len == 0

suite "IndexedList DoublyLinkedList backing":
  test "doubly linked add and iterate":
    var il: DIL
    il.add("a")
    il.add("b")
    il.add("c")
    check il.len == 3
    check toSeq(il.items) == @["a", "b", "c"]

  test "doubly linked prepend":
    var il: DIL
    il.add("b")
    il.prepend("a")
    check toSeq(il.items) == @["a", "b"]

  test "doubly linked del":
    var il: DIL
    il.add("a")
    il.add("b")
    il.add("c")
    il.del("b")
    check toSeq(il.items) == @["a", "c"]

  test "doubly linked popFirst / popLast":
    var il: DIL
    il.add("a")
    il.add("b")
    il.add("c")
    check il.popFirst() == "a"
    check il.popLast() == "c"
    check toSeq(il.items) == @["b"]

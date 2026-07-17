import tables
type
  BiMap*[T, U] = object ## Bidirectional map for unique keys and values
    ab: Table[T, U]
    ba: Table[U, T]

  BiMapSeq*[T, U] = object ## Bidirectional map for unique values but shared keys
    ab: Table[T, seq[U]]
    ba: Table[U, tuple[index: int, abkey: T]]

proc `[]`*[T, U](x: BiMap[T, U], y: T): U {.inline.} =
  ## Forwards lookup
  ##
  ## Where T == U then backwards lookups are done manually
  x.ab[y]

proc `[]`*[T, U](x: BiMap[T, U], y: U): T {.inline.} =
  ## Reverse lookuo
  x.ba[y]

proc `[]=`*[T, U](x: var BiMap[T, U], key: T, val: U) =
  x.ab[key] = val
  x.ba[val] = key

proc `[]=`*[T, U](x: var BiMap[T, U], key: U, val: T) =
  x.ab[val] = key
  x.ba[key] = val

proc contains*[T, U](x: BiMap[T, U], k: T | U): bool =
  when k is T:
    k in x.ab
  else:
    k in x.ba

proc swap*[T, U](x: var BiMap[T, U], k1, k2: T) =
  swap(x.ab[k1], x.ab[k2])
  swap(x.ba[x.ab[k1]], x.ba[x.ab[k2]])

proc swap*[T, U](x: var BiMap[T, U], v1, v2: U) =
  swap(x.ba[v1], x.ba[v2])
  swap(x.ab[x.ba[v1]], x.ab[x.ba[v2]])

## If T==U then compilation fails
proc `[]`*[T, U](x: BiMapSeq[T, U], key: T): lent seq[U] =
  x.ab[key]

proc `[]`*[T, U](x: BiMapSeq[T, U], key: U): lent seq[U] =
  x.ab[x.ba[key].abkey]

proc `[]=`*[T, U](x: var BiMapSeq[T, U], key: T, val: U) =
  ## put value at key
  if val in x.ba:
    raise ValueError.newException "Value already stored"
  x.ab.mgetOrPut(key).add val
  x.ba[val] = (x.ab[key].len - 1, key)

proc `[]=`*[T, U](x: var BiMapSeq[T, U], val: U, key: T) =
  x[key] = val

proc contains*[T, U](x: BiMapSeq[T, U], key: T | U): bool =
  when key is T:
    key in x.ab
  else:
    key in x.ba

proc find*[T, U](x: BiMapSeq[T, U], val: U): T =
  x.ba[val].abkey

proc del*[T, U](x: var BiMapSeq[T, U], key: T) =
  ## remove all values
  let vals = x.ab[key]
  x.ab.del key
  for v in vals:
    x.ba.del v

proc del*[T, U](x: var BiMapSeq[T, U], val: U) =
  let ki = x.ba[val] # abkey, index
  x.ab[ki.abkey].delete ki.index
  if x.ab[ki.abkey].len == 0:
    x.ab.del ki.abkey
  else:
    # loop across sequence and left shift indices
    for ix in ki.index .. x.ab[ki.abkey].len - 1:
      let
        aval = x.ab[ki.abkey][ix]
        (aindex, akey) = x.ba[aval]
      x.ba[aval] = (aindex - 1, akey)

  x.ba.del val

proc rekey*[T, U](x: var BiMapSeq[T, U], val: U, toKey: T) =
  x.del val
  x[toKey] = val

proc `pop`*[T, U](x: var BiMapSeq[T, U], key: T): U =
  ## Remove value from seq and return
  result = x.ab[key].pop()
  if x.ab[key].len == 0:
    x.ab.del key
  x.ba.del result

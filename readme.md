# Datastructures

Bidirectional Maps, Indexed Lists

## Documentation

https://waywardwizard.github.io/nim-datastructures/

## BiDiMap

A bidirectional map giving O(1) lookup in both directions. Two variants:

- **`BiMap[T, U]`** — one-to-one: unique keys map to unique values. Backed by
  two hash tables (`T → U` and `U → T`).
- **`BiMapSeq[T, U]`** — one-to-many: a single key may hold multiple unique
  values, while each value maps back to exactly one key. Backed by
  `Table[T, seq[U]]` plus a reverse index `Table[U, (index, key)]`.

### Memory

Both variants are O(N) in the number of stored values. `BiMap` stores each
entry twice (once per direction); `BiMapSeq` stores one seq slot plus one
reverse-index entry per value.

### Operation complexity

| Operation               | `BiMap` | `BiMapSeq`             |
| ----------------------- | ------- | ---------------------- |
| Forward lookup          | O(1)    | O(1)                   |
| Reverse lookup / `find` | O(1)    | O(1)                   |
| Insert (`[]=`)          | O(1)    | O(1) amortized         |
| `contains`              | O(1)    | O(1)                   |
| `swap`                  | O(1)    | —                      |
| `pop`                   | —       | O(1)                   |
| `del(val)`              | —       | O(K) (left-shifts idx) |
| `del(key)`              | —       | O(K)                   |
| `rekey`                 | —       | O(K)                   |

Where _K_ is the number of values sharing the affected key. The O(K) cost in
`BiMapSeq.del(val)` comes from rewriting indices of subsequent values in the
same seq.

## IndexedList

A doubly-linked list augmented with a hash table (`value → node`), giving
O(1) lookup and removal by value while preserving insertion order. Useful when
you need to find and remove elements from an ordered collection without the
O(N) scan a plain linked list requires. Duplicate values are rejected.

### Memory

O(N): each element occupies one linked-list node plus one hash-table entry.

### Operation complexity

| Operation       | Complexity |
| --------------- | ---------- |
| `contains`      | O(1)       |
| `len`           | O(1)       |
| `add`/`prepend` | O(1)       |
| `del`           | O(1)       |
| `popFirst`      | O(1)       |
| `popLast`       | O(1)       |
| `items`         | O(N)       |

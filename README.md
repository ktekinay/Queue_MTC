# Queue_MTC

A fast queue class for Xojo.

## Overview

`Queue_MTC` is a fast queue class for Xojo. It will work like a Variant array that references "items" instead of "rows", e.g., `RemoteItemAt`, and has an `Enqueue` method rather than `AddRow` and a `Dequeue` method in addition to `Pop`. (`Dequeue` is a first-in-first-out method while `Pop` is a last-in-first-out method.)

In all cases, `Queue_MTC` was designed to be faster than using a plain array.

## Installation

Open the Harness project and copy `Queue_MTC` into your project, or drag the `Queue_MTC.xojo_code` file into your project.

## API

`Queue_MTC` will act like an ordinary Variant array, with some differences.

| Method                    | Description                                               |
|---------------------------|-----------------------------------------------------------|
| `Constructor`             | Create a new instance                                     |
| `Constructor` (fromQueue) | A new instance as a shallow copy of the given `Queue_MTC` |
| `Count`                   | The number of items in the queue                          |
| `Dequeue`                 | Return and remove the first item in the queue (FIFO)      |
| `Enqueue` (item)          | Add an item to the queue                                  |
| `LastItemIndex`           | The zero-based index of the last item                     |
| `Pop`                     | Return and remove the last item in the queue (LIFO)       |
| `IndexOf` (item)          | Return the index of the given item or `-1` if not found   |
| `RemoveAllItems`          | Clear the queue                                           |
| `RemoveItemAt` (index)    | Removes the item at the given index                       |
| `ToArray`                 | Returns a Variant array of the current items              |

Individual items may be referenced like an array, e.g., `q(1) = true` and `v = q(10)`.

You may use a `For Each ...` loop to cycle through every element of the queue.

```VB
For Each v As Variant In myQueue
Next
```
**Caution**: While `Queue_MTC` is mostly thread-safe, you must not use `For Each ...` simultaneously in different threads without protecting that code with a `Semaphore` or similar.

## Examples

See the Harness project's unit tests for examples. Meanwhile, here is some sample code:

```VB
var queue as new Queue_MTC

queue.Enqueue( "hi" )
queue.Enqueue( 3 )

var s as string = queue.Dequeue // "hi"
var i as integer = queue.Dequeue // 3

queue.Enqueue( 1 )
queue.Enqueue( 2 )

if queue( 0 ) = 1 then
  // it is
end if

i = queue.Dequeue // 1
if queue( 0 ) = 2 then
  // it is
end if

queue.RemoveAllItems

queue.Enqueue( 0 )
queue.Enqueue( 1 )
queue.Enqueue( 2 )
queue.Enqueue( 3 )
queue.Enqueue( 4 )

call queue.Dequeue // 0
call queue.Pop // 4

queue.RemoveItemAt( 2 ) // Now 1, 2
if queue.Count = 2  then
  // it is
end if

i = queue.IndexOf( 2 ) // will be 1

var arr() as variant = queue.ToArray
if arr.LastRowIndex = queue.LastItemIndex then
  // it does
end if
```

## Behind The Scenes

`Queue_MTC` achieves its speed gains by rarely modifying its internal Variant array. It starts with an array of a known size and keeps doubling it when more space is needed. It tracks your items through internal indexes that get updated whenever items are queued or de-queued, and only periodically resizes the array during idle time to keep it from getting out of control.

You can compare the speed of `Queue_MTC` vs. an ordinary Variant array by running the "Timing" unit tests in the Harness project.

## Who Did This?

This was created by Kem Tekinay of MacTechnologies Consulting.
ktekinay at mactechnologies dot com

See the included LICENSE file for the legal stuff.

## Release Notes

**1.0** (Aug. 21, 2020)

* Initial release

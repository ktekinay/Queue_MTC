# Queue_MTC

A fast queue class for Xojo.

## Overview

This is a harness project for a fast queue class for Xojo, `Queue_MTC`. It will work like a Variant array that references "items" instead of "rows", e.g., `RemoteItemAt`, and has an `Enqueue` method rather than `AddRow` and a `Dequeue` method in addition to `Pop`. (`Dequeue` is a first-in-first-out method while `Pop` is a last-in-first-out method.)

See the harness project's unit tests for examples. Meanwhile, here is some sample code:

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

## Who Did This?

This was created by Kem Tekinay of MacTechnologies Consulting.
ktekinay at mactechnologies dot com

See the included LICENSE file for the legal stuff.

## Release Notes

**1.0** (Aug. 19, 2020)

* Initial release
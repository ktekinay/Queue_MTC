# Stack_MTC

A fast stack class for Xojo.

## Overview

This is a harness project for a fast stack class for Xojo, `Stack_MTC`. It will work like a Variant array that references "items" instead of "rows", e.g., `RemoteItemAt`, and has an `Enqueue` method rather than `AddRow` and a `Dequeue` method in addition to `Pop`. (`Dequeue` is a first-in-first-out method while `Pop` is a last-in-first-out method.)

See the harness project's unit tests for examples. Meanwhile, here is some sample code:

```VB
var stack as new Stack_MTC

stack.Enqueue( "hi" )
stack.Enqueue( 3 )

var s as string = stack.Dequeue // "hi"
var i as integer = stack.Dequeue // 3

stack.Enqueue( 1 )
stack.Enqueue( 2 )

if stack( 0 ) = 1 then
  // it is
end if

i = stack.Dequeue // 1
if stack( 0 ) = 2 then
  // it is
end if

stack.RemoveAllItems

stack.Enqueue( 0 )
stack.Enqueue( 1 )
stack.Enqueue( 2 )
stack.Enqueue( 3 )
stack.Enqueue( 4 )

call stack.Dequeue // 0
call stack.Pop // 4

stack.RemoveItemAt( 2 ) // Now 1, 2
if stack.Count = 2  then
  // it is
end if

i = stack.IndexOf( 2 ) // will be 1

var arr() as variant = stack.ToArray
if arr.LastRowIndex = stack.LastItemIndex then
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
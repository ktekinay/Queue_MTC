#tag Class
Protected Class QueueTests
Inherits TestGroup
	#tag Event
		Sub TearDown()
		  if OptimizeTimer isa object then
		    OptimizeTimer.RunMode = Timer.RunModes.Off
		    RemoveHandler OptimizeTimer.Action, WeakAddressOf OptimizeTimer_Action
		    OptimizeTimer = nil
		  end if
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub CopyConstructorTest()
		  var queue1 as new Queue_MTC
		  
		  queue1.Enqueue( 0 )
		  queue1.Enqueue( 1 )
		  queue1.Enqueue( 2 )
		  queue1.Enqueue( 3 )
		  call queue1.Dequeue
		  
		  var queue2 as new Queue_MTC( queue1 )
		  Assert.AreEqual( queue1.Count, queue2.Count )
		  
		  for i as integer = 0 to queue1.LastItemIndex
		    Assert.AreEqual( queue1( i ).IntegerValue, queue2( i ).IntegerValue )
		  next
		  
		  queue2.Enqueue( 4 )
		  Assert.AreEqual( 4, queue2( queue2.LastItemIndex ).IntegerValue )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub FILOTest()
		  var Queue as new Queue_MTC
		  
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( true )
		  Queue.Enqueue( 5.5 )
		  
		  Assert.AreEqual( 1, Queue.Dequeue.IntegerValue )
		  Assert.IsTrue( Queue.Dequeue.BooleanValue )
		  Assert.AreEqual( 5.5, Queue.Dequeue.DoubleValue )
		  
		  Assert.AreEqual( 0, Queue.Count )
		  Assert.AreEqual( -1, Queue.LastItemIndex )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IndexOfTest()
		  var Queue as new Queue_MTC
		  
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( 2 )
		  Queue.Enqueue( 3 )
		  Queue.Enqueue( 1 )
		  
		  Assert.AreEqual( 1, Queue.Dequeue.IntegerValue )
		  Assert.AreEqual( 2, Queue.IndexOf( 1 ) )
		  
		  Queue.Enqueue( nil )
		  Assert.AreEqual( 3, Queue.IndexOf( nil ) )
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IteratorTest()
		  var Queue as new Queue_MTC
		  
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( 2 )
		  Queue.Enqueue( 3 )
		  
		  var counter as integer
		  for each v as variant in Queue
		    counter = counter + 1
		    Assert.AreEqual counter, v.IntegerValue
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ObjectScopeTest()
		  var Queue as new Queue_MTC
		  
		  var o as new Dictionary
		  var wr as new WeakRef( o )
		  Assert.IsNotNil( wr.Value ) // Points to the object
		  
		  Queue.Enqueue( o )
		  o = nil
		  Assert.IsNotNil( wr.Value ) // Exists in the Queue
		  
		  call Queue.Dequeue
		  Assert.IsNil( wr.Value ) // No longer exists
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OptimizeTest()
		  //
		  // Forces the class to optimize
		  //
		  
		  OptimizeQueue = new UTQueue
		  
		  //
		  // Add and dequeue a bunch of elements
		  //
		  for i as integer = 1 to 10000
		    OptimizeQueue.Enqueue( i )
		  next
		  
		  for i as integer = 1 to 9500
		    call OptimizeQueue.Dequeue
		  next
		  
		  Assert.IsTrue( OptimizeQueue.DebugMyArrayCount > 1000 )
		  Assert.IsTrue( OptimizeQueue.DebugLowerIndex > 1000 )
		  Assert.AreEqual( OptimizeQueue.DebugLowerIndex + OptimizeQueue.LastItemIndex, OptimizeQueue.DebugUpperIndex )
		  
		  OptimizeTimer = new Timer
		  AddHandler OptimizeTimer.Action, WeakAddressOf OptimizeTimer_Action
		  OptimizeTimer.Period = 1100
		  OptimizeTimer.RunMode = Timer.RunModes.Single
		  
		  self.AsyncAwait( 2 )
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub OptimizeTimer_Action(sender As Timer)
		  #pragma unused sender
		  
		  self.AsyncComplete
		  
		  Assert.IsTrue( OptimizeQueue.DebugMyArrayCount < 1000 )
		  Assert.AreEqual( 0, OptimizeQueue.DebugLowerIndex )
		  Assert.AreEqual( OptimizeQueue.LastItemIndex, OptimizeQueue.DebugUpperIndex )
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OutOfBoundsTest()
		  var Queue as new Queue_MTC
		  
		  for i as integer = 1 to 100
		    Queue.Enqueue( i )
		  next
		  
		  #pragma BreakOnExceptions false
		  try
		    call Queue( 100 )
		    Assert.Fail( "100" )
		  catch err as OutOfBoundsException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  call Queue.Dequeue
		  
		  #pragma BreakOnExceptions false
		  try
		    call Queue( 99 )
		    Assert.Fail( "99" )
		  catch err as OutOfBoundsException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopTest()
		  var Queue as new Queue_MTC
		  
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( 2 )
		  Assert.AreEqual( 2, Queue.Pop.IntegerValue )
		  Assert.AreEqual( 1, Queue.Count )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReadMeExampleTest()
		  var Queue as new Queue_MTC
		  
		  Queue.Enqueue( "hi" )
		  Queue.Enqueue( 3 )
		  
		  var s as string = Queue.Dequeue // "hi"
		  var i as integer = Queue.Dequeue // 3
		  
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( 2 )
		  
		  if Queue( 0 ) = 1 then
		    // it is
		  end if
		  
		  i = Queue.Dequeue // 1
		  if Queue( 0 ) = 2 then
		    // it is
		  end if
		  
		  Queue.RemoveAllItems
		  
		  Queue.Enqueue( 0 )
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( 2 )
		  Queue.Enqueue( 3 )
		  Queue.Enqueue( 4 )
		  
		  call Queue.Dequeue // 0
		  call Queue.Pop // 4
		  
		  Queue.RemoveItemAt( 2 ) // Now 1, 2
		  if Queue.Count = 2  then
		    // it is
		  end if
		  
		  i = Queue.IndexOf( 2 ) // will be 1
		  
		  var arr() as variant = Queue.ToArray
		  if arr.LastRowIndex = Queue.LastItemIndex then
		    // it does
		  end if
		  
		  
		  Assert.Pass
		  
		  #pragma unused s
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAllItemsTest()
		  var Queue as new Queue_MTC
		  
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( 2 )
		  Queue.Enqueue( 3 )
		  Queue.Enqueue( 4 )
		  
		  Assert.AreEqual( 3, Queue.LastItemIndex )
		  
		  Queue.RemoveAllItems
		  Assert.AreEqual( -1, Queue.LastItemIndex )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveItemTest()
		  var Queue as new Queue_MTC
		  
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( 2 )
		  Queue.Enqueue( 3 )
		  Queue.Enqueue( 4 )
		  
		  call Queue.Dequeue
		  Assert.AreEqual 3, Queue.Count
		  Assert.AreEqual 3, Queue( 1 ).IntegerValue
		  
		  Queue.RemoveItemAt( 1 )
		  Assert.AreEqual( 2, Queue.Count )
		  Assert.AreEqual( 4, Queue( Queue.LastItemIndex ).IntegerValue )
		  
		  Queue.RemoveItemAt( 0 )
		  Queue.RemoveItemAt( 0 )
		  Assert.AreEqual( 0, Queue.Count )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SubscriptTest()
		  var Queue as new Queue_MTC
		  
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( 2 )
		  
		  Assert.AreEqual( 1, Queue( 0 ).IntegerValue )
		  
		  call Queue.Dequeue
		  Assert.AreEqual( 2, Queue( 0 ).IntegerValue )
		  
		  Queue( 0 ) = 99
		  Assert.AreEqual( 99, Queue( 0 ).IntegerValue )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToArrayTest()
		  var Queue as new Queue_MTC
		  
		  Queue.Enqueue( 0 )
		  Queue.Enqueue( 1 )
		  Queue.Enqueue( new Dictionary )
		  Queue.Enqueue( "hi there" )
		  
		  call Queue.Dequeue
		  
		  var arr() as variant = Queue.ToArray
		  Assert.AreEqual( 3, CType( arr.Count, Integer ) )
		  Assert.AreEqual( 1, arr( 0 ).IntegerValue )
		  Assert.IsTrue( arr( 1 ).ObjectValue isa Dictionary )
		  Assert.AreSame( "hi there", arr( 2 ).StringValue )
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private OptimizeQueue As UTQueue
	#tag EndProperty

	#tag Property, Flags = &h21
		Private OptimizeTimer As Timer
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

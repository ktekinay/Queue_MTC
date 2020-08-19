#tag Class
Protected Class StackTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub FILOTest()
		  var stack as new Stack_MTC
		  
		  stack.Enqueue( 1 )
		  stack.Enqueue( true )
		  stack.Enqueue( 5.5 )
		  
		  Assert.AreEqual( 1, stack.Dequeue.IntegerValue )
		  Assert.IsTrue( stack.Dequeue.BooleanValue )
		  Assert.AreEqual( 5.5, stack.Dequeue.DoubleValue )
		  
		  Assert.AreEqual( 0, stack.Count )
		  Assert.AreEqual( -1, stack.LastItemIndex )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IndexOfTest()
		  var stack as new Stack_MTC
		  
		  stack.Enqueue( 1 )
		  stack.Enqueue( 2 )
		  stack.Enqueue( 3 )
		  stack.Enqueue( 1 )
		  
		  Assert.AreEqual( 1, stack.Dequeue.IntegerValue )
		  Assert.AreEqual( 2, stack.IndexOf( 1 ) )
		  
		  stack.Enqueue( nil )
		  Assert.AreEqual( 3, stack.IndexOf( nil ) )
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IteratorTest()
		  var stack as new Stack_MTC
		  
		  stack.Enqueue( 1 )
		  stack.Enqueue( 2 )
		  stack.Enqueue( 3 )
		  
		  var counter as integer
		  for each v as variant in stack
		    counter = counter + 1
		    Assert.AreEqual counter, v.IntegerValue
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ObjectScopeTest()
		  var stack as new Stack_MTC
		  
		  var o as new Dictionary
		  var wr as new WeakRef( o )
		  Assert.IsNotNil( wr.Value ) // Points to the object
		  
		  stack.Enqueue( o )
		  o = nil
		  Assert.IsNotNil( wr.Value ) // Exists in the stack
		  
		  call stack.Dequeue
		  Assert.IsNil( wr.Value ) // No longer exists
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub OutOfBoundsTest()
		  var stack as new Stack_MTC
		  
		  for i as integer = 1 to 100
		    stack.Enqueue( i )
		  next
		  
		  #pragma BreakOnExceptions false
		  try
		    call stack( 100 )
		    Assert.Fail( "100" )
		  catch err as OutOfBoundsException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  call stack.Dequeue
		  
		  #pragma BreakOnExceptions false
		  try
		    call stack( 99 )
		    Assert.Fail( "99" )
		  catch err as OutOfBoundsException
		    Assert.Pass
		  end try
		  #pragma BreakOnExceptions default
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopTest()
		  var stack as new Stack_MTC
		  
		  stack.Enqueue( 1 )
		  stack.Enqueue( 2 )
		  Assert.AreEqual( 2, stack.Pop.IntegerValue )
		  Assert.AreEqual( 1, stack.Count )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAllItemsTest()
		  var stack as new Stack_MTC
		  
		  stack.Enqueue( 1 )
		  stack.Enqueue( 2 )
		  stack.Enqueue( 3 )
		  stack.Enqueue( 4 )
		  
		  Assert.AreEqual( 3, stack.LastItemIndex )
		  
		  stack.RemoveAllItems
		  Assert.AreEqual( -1, stack.LastItemIndex )
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveItemTest()
		  var stack as new Stack_MTC
		  
		  stack.Enqueue( 1 )
		  stack.Enqueue( 2 )
		  stack.Enqueue( 3 )
		  stack.Enqueue( 4 )
		  
		  call stack.Dequeue
		  Assert.AreEqual 3, stack.Count
		  Assert.AreEqual 3, stack( 1 ).IntegerValue
		  
		  stack.RemoveItemAt( 1 )
		  Assert.AreEqual( 2, stack.Count )
		  Assert.AreEqual( 4, stack( stack.LastItemIndex ).IntegerValue )
		  
		  stack.RemoveItemAt( 0 )
		  stack.RemoveItemAt( 0 )
		  Assert.AreEqual( 0, stack.Count )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SubscriptTest()
		  var stack as new Stack_MTC
		  
		  stack.Enqueue( 1 )
		  stack.Enqueue( 2 )
		  
		  Assert.AreEqual( 1, stack( 0 ).IntegerValue )
		  
		  call stack.Dequeue
		  Assert.AreEqual( 2, stack( 0 ).IntegerValue )
		  
		  stack( 0 ) = 99
		  Assert.AreEqual( 99, stack( 0 ).IntegerValue )
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ToArrayTest()
		  var stack as new Stack_MTC
		  
		  stack.Enqueue( 0 )
		  stack.Enqueue( 1 )
		  stack.Enqueue( new Dictionary )
		  stack.Enqueue( "hi there" )
		  
		  call stack.Dequeue
		  
		  var arr() as variant = stack.ToArray
		  Assert.AreEqual( 3, CType( arr.Count, Integer ) )
		  Assert.AreEqual( 1, arr( 0 ).IntegerValue )
		  Assert.IsTrue( arr( 1 ).ObjectValue isa Dictionary )
		  Assert.AreSame( "hi there", arr( 2 ).StringValue )
		  
		End Sub
	#tag EndMethod


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

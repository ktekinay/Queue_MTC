#tag Class
Protected Class Queue_MTC
Implements Iterable,Iterator
	#tag Method, Flags = &h0
		Sub Constructor()
		  MySemaphore = new Semaphore
		  
		  OptimizeTimer = new Timer
		  OptimizeTimer.Period = 1000
		  AddHandler OptimizeTimer.Action, WeakAddressOf OptimizeTimer_Action
		  OptimizeTimer.RunMode = Timer.RunModes.Multiple
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(copyFrom As Queue_MTC)
		  Constructor()
		  
		  if copyFrom.Count <> 0 then
		    MyArray = copyFrom.ToArray
		    UpperIndex = copyFrom.LastItemIndex
		    
		    if MyArray.LastRowIndex < kInitialSize then
		      MyArray.ResizeTo( kInitialSize )
		    end if
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320616E642072656D6F76657320746865206669727374206974656D20717565756564
		Function Dequeue() As Variant
		  //
		  // Return from the top of the array
		  //
		  
		  MySemaphore.Signal
		  
		  if UpperIndex < LowerIndex then
		    MySemaphore.Release
		    raise new OutOfBoundsException
		  end if
		  
		  var result as variant = MyArray( LowerIndex )
		  MyArray( LowerIndex ) = nil
		  
		  if LowerIndex = UpperIndex then
		    //
		    // Reset the Queue
		    //
		    LowerIndex = 0
		    UpperIndex = -1 
		    
		  else
		    
		    LowerIndex = LowerIndex + 1
		    
		  end if
		  
		  MySemaphore.Release
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Destructor()
		  if OptimizeTimer isa object then
		    OptimizeTimer.RunMode = Timer.RunModes.Off
		    RemoveHandler OptimizeTimer.Action, WeakAddressOf OptimizeTimer_Action
		    OptimizeTimer = nil
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Enqueue(item As Variant)
		  //
		  // Add to the bottom of the array
		  //
		  
		  MySemaphore.Signal
		  
		  UpperIndex = UpperIndex + 1
		  if UpperIndex > MyArray.LastRowIndex then
		    var newSize as integer = MyArray.LastRowIndex * 2
		    if newSize < kInitialSize then
		      newSize = kInitialSize
		    end if
		    
		    MyArray.ResizeTo( newSize )
		  end if
		  
		  MyArray( UpperIndex ) = item
		  
		  MySemaphore.Release
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IndexOf(item As Variant) As Integer
		  MySemaphore.Signal
		  
		  var result as integer = -1
		  
		  if Count = 0 then
		    //
		    // Do nothing
		    //
		    
		  elseif item.IsNull then
		    //
		    // We have to handle this case specially
		    //
		    for i as integer = LowerIndex to UpperIndex
		      if MyArray( i ).IsNull then
		        result = i - LowerIndex
		        exit
		      end if
		    next
		    
		  else
		    
		    result = MyArray.IndexOf( item )
		    if result >= LowerIndex and result <= UpperIndex then
		      result = result - LowerIndex
		    else
		      result = -1
		    end if
		    
		  end if
		  
		  MySemaphore.Release
		  
		  return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Iterator() As Iterator
		  IteratorIndex = LowerIndex - 1
		  return self
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MoveNext() As Boolean
		  IteratorIndex = IteratorIndex + 1
		  if IteratorIndex > UpperIndex then
		    return false
		  else
		    return true
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Function Operator_Subscript(index As Integer) As Variant
		  MySemaphore.Signal
		  
		  if index < 0 or index > ( UpperIndex - LowerIndex ) then
		    MySemaphore.Release
		    raise new OutOfBoundsException
		  end if
		  
		  var lookupIndex as integer = index + LowerIndex
		  var result as variant = MyArray( lookupIndex )
		  
		  MySemaphore.Release
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Hidden )  Sub Operator_Subscript(index As Integer, Assigns item As Variant)
		  MySemaphore.Signal
		  
		  if index < 0 or index > ( UpperIndex - LowerIndex ) then
		    MySemaphore.Release
		    raise new OutOfBoundsException
		  end if
		  
		  var lookupIndex as integer = index + LowerIndex
		  MyArray( lookupIndex ) = item
		  
		  MySemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub OptimizeTimer_Action(sender As Timer)
		  #pragma unused sender
		  
		  MySemaphore.Signal
		  
		  var lii as integer = LastItemIndex
		  
		  if LowerIndex > kOptimalSize then
		    
		    #if DebugBuild then
		      var startµs as double = Microseconds
		    #endif
		    
		    MyArray = ToArray_Private
		    LowerIndex = 0
		    UpperIndex = lii
		    
		    if MyArray.LastRowIndex < kInitialSize then
		      MyArray.ResizeTo( kInitialSize )
		    end if
		    
		    #if DebugBuild then
		      var elapsedms as double = ( Microseconds - startµs ) / 1000.0
		      System.DebugLog "Optimization took " + elapsedms.ToString( "###,##0.00" ) + " ms"
		    #endif
		  end if
		  
		  MySemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320616E642072656D6F76657320746865206C617374206974656D20717565756564
		Function Pop() As Variant
		  //
		  // Return from the bottom of the array
		  //
		  
		  MySemaphore.Signal
		  
		  if UpperIndex < LowerIndex then
		    MySemaphore.Release
		    raise new OutOfBoundsException
		  end if
		  
		  var result as integer = MyArray( UpperIndex )
		  MyArray( UpperIndex ) = nil
		  
		  if LowerIndex = UpperIndex then
		    //
		    // Reset the Queue
		    //
		    LowerIndex = 0
		    UpperIndex = -1
		    
		  else
		    
		    UpperIndex = UpperIndex - 1
		    
		  end if
		  
		  MySemaphore.Release
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAllItems()
		  MySemaphore.Signal
		  
		  LowerIndex = 0
		  UpperIndex = -1
		  
		  //
		  // Now clear the array to make sure every element is nil
		  // while preserving its size
		  //
		  var lri as integer = MyArray.LastRowIndex
		  if lri < kInitialSize then
		    lri = kInitialSize
		  end if
		  
		  MyArray.RemoveAllRows
		  MyArray.ResizeTo( lri )
		  
		  MySemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveItemAt(index As Integer)
		  MySemaphore.Signal
		  
		  if index < 0 or index > ( UpperIndex - LowerIndex ) then
		    MySemaphore.Release
		    raise new OutOfBoundsException
		  end if
		  
		  var removeIndex as integer = index + LowerIndex
		  
		  if LowerIndex = UpperIndex then
		    
		    MyArray( removeIndex ) = nil
		    
		    //
		    // RemoveItemAt might have been called many times in a row,
		    // so let's leave this at the initial size at a minimum
		    //
		    if MyArray.LastRowIndex < kInitialSize then
		      MyArray.ResizeTo( kInitialSize )
		    end if
		    
		    LowerIndex = 0
		    UpperIndex = -1
		    
		  else
		    
		    MyArray.RemoveRowAt( removeIndex )
		    UpperIndex = UpperIndex - 1
		    
		    //
		    // So we are not constantly resizing the array,
		    // only resize if it's less than the minimum
		    //
		    if MyArray.LastRowIndex < kMinSize then
		      MyArray.ResizeTo( kInitialSize )
		    end if
		    
		  end if
		  
		  MySemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToArray() As Variant()
		  MySemaphore.Signal
		  
		  var result() as variant = ToArray_Private
		  
		  MySemaphore.Release
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToArray_Private() As Variant()
		  var result() as variant
		  result.ResizeTo( LastItemIndex )
		  
		  var resultIndex as integer = -1
		  for arrIndex as integer = LowerIndex to UpperIndex
		    resultIndex = resultIndex + 1
		    result( resultIndex ) = MyArray( arrIndex )
		  next
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Value() As Variant
		  return MyArray( IteratorIndex )
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return UpperIndex - LowerIndex + 1
			  
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private IteratorIndex As Integer = -1
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return UpperIndex - LowerIndex
			  
			End Get
		#tag EndGetter
		LastItemIndex As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h1
		Protected LowerIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected MyArray(kInitialSize) As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private MySemaphore As Semaphore
	#tag EndProperty

	#tag Property, Flags = &h21
		Private OptimizeTimer As Timer
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected UpperIndex As Integer = -1
	#tag EndProperty


	#tag Constant, Name = kInitialSize, Type = Double, Dynamic = False, Default = \"50", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMinSize, Type = Double, Dynamic = False, Default = \"10", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kOptimalSize, Type = Double, Dynamic = False, Default = \"500", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="LastItemIndex"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass

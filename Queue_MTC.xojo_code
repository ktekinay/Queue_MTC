#tag Class
Protected Class Queue_MTC
Implements Iterable,Iterator
	#tag Method, Flags = &h0
		Sub Constructor()
		  MySemaphore = new Semaphore
		  
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
		  
		  var result as variant = arr( LowerIndex )
		  arr( LowerIndex ) = nil
		  
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

	#tag Method, Flags = &h0
		Sub Enqueue(item As Variant)
		  //
		  // Add to the bottom of the array
		  //
		  
		  MySemaphore.Signal
		  
		  UpperIndex = UpperIndex + 1
		  if UpperIndex > arr.LastRowIndex then
		    var newSize as integer = arr.LastRowIndex * 2
		    if newSize < kInitialSize then
		      newSize = kInitialSize
		    end if
		    
		    arr.ResizeTo( newSize )
		  end if
		  
		  arr( UpperIndex ) = item
		  
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
		      if arr( i ).IsNull then
		        result = i - LowerIndex
		        exit
		      end if
		    next
		    
		  else
		    
		    result = arr.IndexOf( item )
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
		  var result as variant = arr( lookupIndex )
		  
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
		  arr( lookupIndex ) = item
		  
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
		  
		  var result as integer = arr( UpperIndex )
		  arr( UpperIndex ) = nil
		  
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
		  var lri as integer = arr.LastRowIndex
		  if lri < kInitialSize then
		    lri = kInitialSize
		  end if
		  
		  arr.RemoveAllRows
		  arr.ResizeTo( lri )
		  
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
		    
		    arr( removeIndex ) = nil
		    
		    //
		    // RemoveItemAt might have been called many times in a row,
		    // so let's leave this at the initial size at a minimum
		    //
		    if arr.LastRowIndex < kInitialSize then
		      arr.ResizeTo( kInitialSize )
		    end if
		    
		    LowerIndex = 0
		    UpperIndex = -1
		    
		  else
		    
		    arr.RemoveRowAt( removeIndex )
		    UpperIndex = UpperIndex - 1
		    
		    //
		    // So we are not constantly resizing the array,
		    // only resize if it's less than the minimum
		    //
		    if arr.LastRowIndex < kMinSize then
		      arr.ResizeTo( kInitialSize )
		    end if
		    
		  end if
		  
		  MySemaphore.Release
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToArray() As Variant()
		  MySemaphore.Signal
		  
		  var result() as variant
		  for i as integer = LowerIndex to UpperIndex
		    result.AddRow( arr( i ) )
		  next
		  
		  MySemaphore.Release
		  
		  return result
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Value() As Variant
		  return arr( IteratorIndex )
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Arr(kInitialSize) As Variant
	#tag EndProperty

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

	#tag Property, Flags = &h21
		Private LowerIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private MySemaphore As Semaphore
	#tag EndProperty

	#tag Property, Flags = &h21
		Private UpperIndex As Integer = -1
	#tag EndProperty


	#tag Constant, Name = kInitialSize, Type = Double, Dynamic = False, Default = \"50", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kMinSize, Type = Double, Dynamic = False, Default = \"10", Scope = Private
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

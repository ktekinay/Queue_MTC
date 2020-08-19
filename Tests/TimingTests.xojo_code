#tag Class
Protected Class TimingTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub ArrayPopTimingTest()
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var arr() as variant
		  for i as integer = 0 to kTimingReps
		    arr.AddRow( i )
		  next
		  
		  for i as integer = 0 to kTimingReps
		    call arr.Pop
		  next
		  
		  Assert.Pass( kTimingReps.ToText + " reps" ) // We just want the timing
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ArrayTimingTest()
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var arr() as variant
		  for i as integer = 0 to kTimingReps
		    arr.AddRowAt( 0, i )
		  next
		  
		  for i as integer = 0 to kTimingReps
		    call arr.Pop
		  next
		  
		  Assert.Pass( kTimingReps.ToText + " reps" ) // We just want the timing
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StackPopTimingTest()
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var s as new Stack_MTC
		  for i as integer = 0 to kTimingReps
		    s.Enqueue( i )
		  next
		  
		  for i as integer = 0 to kTimingReps
		    call s.Pop
		  next
		  
		  Assert.Pass( kTimingReps.ToText + " reps" ) // We just want the timing
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub StackTimingTest()
		  #if not DebugBuild then
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  var s as new Stack_MTC
		  for i as integer = 0 to kTimingReps
		    s.Enqueue( i )
		  next
		  
		  for i as integer = 0 to kTimingReps
		    call s.Dequeue
		  next
		  
		  Assert.Pass( kTimingReps.ToText + " reps" ) // We just want the timing
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = kTimingReps, Type = Double, Dynamic = False, Default = \"100000", Scope = Private
	#tag EndConstant


End Class
#tag EndClass

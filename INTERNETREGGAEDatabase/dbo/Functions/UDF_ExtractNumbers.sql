

Create function UDF_ExtractNumbers
(  
  -- Input is alphanumeric string
  @input varchar(255)  
)  
-- Returns numbers as a string
Returns varchar(255)  
As  
Begin  
  -- Returns the index of a character that is not a number
  -- If the specified pattern is not found, ZERO is returned
  Declare @alphabetIndex int = Patindex('%[^0-9]%', @input)  
  Begin  
    While @alphabetIndex > 0  
    Begin  
      -- In the input string (@input) at the position (@alphabetIndex) 
	  -- where we have a non-numeric chracter, replace that 1
	  -- character with an empty string ('')
	  Set @input = Stuff(@input, @alphabetIndex, 1, '' )
	  -- Find the next non-numeric character and repeat the above step
	  -- until all non-numeric characters are replaced with an empty string
      Set @alphabetIndex = Patindex('%[^0-9]%', @input )  
    End  
  End  
  Return @input
End



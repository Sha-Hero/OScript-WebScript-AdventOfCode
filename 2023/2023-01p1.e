/*
 * Originally done in webscripts. Lots of unnecessary square brackets
 * were added to address results that can be parsed in javascript for output.
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
 * Add first and last actual number
 * 0.02 s
 */
	
function String runme()
	integer count = 0
	integer sum = 0
	string retArray = ""
	List funcRet = {}, inputF
	integer Starter=Date.Tick()
	inputF=Loaddata()
	for (count=1; count<=Length(inputF); count+=1)
		// OK, let's load the data and do the work.
		funcRet = findNums(Str.ValueToString(inputF[count]))
		retArray = retArray+","+funcRet[1]
		sum += funcRet[2]
	end
	// Trim the leading comma and package it up.
	retArray = "["+retArray[2:]+"]"
	// Add the sum to the return data. This is what we're looking for.
	retArray = "[["+Str.ValueToString(count)+","+Str.ValueToString(sum)+"],"+retArray+"]"
	//	echo(Str.ValueToString(retArray))
	echo("Answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done"
end
// This is the function that does the work.
// Returns an array: incoming string, parsed out, first num, last num, sum
function List findNums(String args)
	String target = args
	String search = "[!0-9]"
	String change = '#1'
	String result = Pattern.Change( target, Pattern.CompileFind( search ), Pattern.CompileChange( change ) )
	if IsUndefined(result)
		// This can happen when the input is strictly numbers.
		result = args
	end
	Integer leftN = Str.StringToValue(Str.ValueToString(result)[2])
	Integer rightN = Str.StringToValue(Str.ValueToString(result)[-2])
	// Returning a two-entry list. First entry is an "array-ified" list of values for display purposes. Second entry is the sum of the numbers for the entry.
	List nums = {Str.Format("[%1, %2, %3, %4, %5]",args, result, leftN, rightN, Str.StringToInteger(Str.ValueToString(leftN)+Str.ValueToString(rightN))), Str.StringToInteger(Str.ValueToString(leftN)+Str.ValueToString(rightN))}
	return nums
end

// Load the file.
function List loadData()
	List incoming
	String s
	File fr = File.open("C:\AdventOfCodeInputs\2023\1-input.txt", File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end

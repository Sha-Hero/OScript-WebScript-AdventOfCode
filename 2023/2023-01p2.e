/*
 * Brute force pattern matching. Went through the string forwards and backwards
 * to find the matching numbers.
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
 * Numbers might be written out
 * 0.076 s
 */

function String runme()
	integer count = 0, sum = 0, Starter=Date.Tick()
	string retArray = ""
	List funcRet = {}, inputF
	// OK, let's load the data and do the work.
	inputF=Loaddata()
	for (count=1; count<=Length(inputF); count+=1)
		funcRet = findNums(Str.ValueToString(inputF[count]))
		retArray = retArray+","+funcRet[1]
		sum += funcRet[2]
	end
	// Trim the leading comma and package it up.
	retArray = "["+retArray[2:]+"]"
	// Add the sum to the return data. This is what we're looking for.
	// echo("[["+Str.ValueToString(count)+","+Str.ValueToString(sum)+"],"+retArray+"]")
	echo('Answer: '+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done."
end
function List findNums(String args)
	String target = Str.Strip(args, "'") // removing leading/trailing quotes.
	String s = ''
	String search = ''
	integer mc=0 // maximum count.
	List searches = { "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" }
	integer leftN, leftNspot = 1000
	integer rightNspot = -1, x, rightN, rightNtemp=-1
	List result1, result2
	// While there are much more elegant approaches, I'm just going to brute-force this.
	for (x=1; x<=Length(searches); x+=1 )
		rightNtemp=0
		s=target  // reset the string
		mc=0
		result1 = Pattern.Find( s, Str.ValueToString(x) )
		if (IsDefined( result1 ))
			if result1[1] < leftNspot
				leftNspot =result1[1]
				leftN = x
			end
		end
		while ( IsDefined( result1 ) && mc < 100)
			rightNtemp+=result1[1]
			s = s[ result1[1]+1 : ] // It's only matching one character, so need to be higher than that!
			result1 = Pattern.Find( s, Str.ValueToString(x))
			mc += 1
		end
		if ( rightNtemp > rightNspot )
			rightNspot=rightNtemp
			rightN=x
		end
		rightNtemp=0
		s=target  // reset the string
		result2 = Pattern.Find( s, searches[x])
		if (IsDefined( result2))
			if result2[1] < leftNspot
				leftNspot =result2[1]
				leftN = x
			end
		end
		while ( IsDefined( result2 ) && mc < 100)
			rightNtemp+=result2[1]
			s = s[ result2[1]+1 : ] // It's only matching one character, so need to be higher than that!
			result2 = Pattern.Find( s, searches[x])
			mc += 1
		end
		if ( rightNtemp > rightNspot )
			rightNspot=rightNtemp
			rightN=x
		end
	end
	// Returning a two-entry list. First entry is an "array-ified" list of values for display purposes. Second entry is the sum of the numbers for the entry.
	List nums = {Str.Format("[%1, %2, %3, %4, %5, %6]",args, leftNspot, leftN, rightNspot, rightN, Str.StringToInteger(Str.ValueToString(leftN)+Str.ValueToString(rightN))), Str.StringToInteger(Str.ValueToString(leftN)+Str.ValueToString(rightN))}
	return nums
end
// The various arrays are used only for debugging and display purposes.
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
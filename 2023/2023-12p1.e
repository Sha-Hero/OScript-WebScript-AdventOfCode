/*
 * Pattern matching springs.
 * Recurse each line.
 * ???.### 1,1,3
 * .??..??...?##. 1,1,3
 * ?#?#?#?#?#?#?#? 1,3,1,6
 * ????.#...#... 4,1,1
 * ????.######..#####. 1,6,5
 * ?###???????? 3,2,1
 * 0.23 s
 */
function String runme()
	List inputF
	integer Starter=Date.Tick()
	Integer count=1, curSum=0, tempSum = 0, icount
	List partLine, inpElem, levtwo, mytest
	List outer = {}
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\12-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		tempSum = 0
		partLine[count] = Str.Elements(inputF[count], ' ')[1] // Wish we could map two variables at once.
		inpElem[count] = Str.Elements(Str.Elements(inputF[count], ' ')[2], ',')
		// Wish I could force the elements as integers at first.
		for (icount=1; icount<=Length(inpElem[count]); icount+=1)
			inpElem[count][icount] = Str.StringToInteger(inpElem[count][icount])
			tempSum += inpElem[count][icount] + 1
		end
		tempSum -= 1 // don't need the final space.
		curSum += findSlot(partLine[count], inpElem[count], tempSum, Length(partLine[count])-Length(Str.ReplaceAll(partLine[count], '#', ''))) // # of #
	end
	echo(Str.ValueToString(cursum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end

function Integer findSlot(String parts, List inputs, integer remlen, integer hashes)
	// parts: string we're looking in.
	// inputs: list of things we're looking for. e.g. { 2, 1, 1 }
	// remlen: remaining length of the strings (with spaces) e.g. 6
	String searchPat = '', parts2 = ''
	Integer c=0, curCount=0
	List result
	// Build the search pattern.
	for (c=1; c<=inputs[1]; c+=1)
		searchPat += '[?#]'
	end
	searchPat += '[?.]' // Needs to end with a ? or .
	while Length(parts) >= remlen
		result = Pattern.Find( parts+'.', searchPat )
		if IsDefined(result)
			// Found it.
			if Length(inputs) == 1
				if hashes - (Length(result[3])-Length(Str.ReplaceAll(result[3], '#', ''))) == 0
					curCount += 1
				end
			else
				curCount += findSlot( parts[result[2]+1:], inputs[2:], remlen-inputs[1]-1, hashes-(Length(result[3])-Length(Str.ReplaceAll(result[3], '#', ''))) )
			end
			if parts[result[1]] == '#'
				return curCount
			end
			parts = parts[result[1]+1:]
		else
			return curCount
		end
	end
	return curCount
end

// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end

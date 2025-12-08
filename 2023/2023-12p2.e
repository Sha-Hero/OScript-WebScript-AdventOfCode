/*
 * Pattern match, but huge possibilities.
 * Used global cache. Four times in a row.
 * ???.### 1,1,3
 * .??..??...?##. 1,1,3
 * ?#?#?#?#?#?#?#? 1,3,1,6
 * ????.#...#... 4,1,1
 * ????.######..#####. 1,6,5
 * ?###???????? 3,2,1
 * 3.0 s seconds to complete.
 */
function String runme()
	Integer count=1, icount, curSum=0, tempSum = 0, Starter=Date.Tick()
	List inputF, partLine, inpElem, tempL
	$$globCache = Assoc.CreateAssoc()
	inputF=Loaddata()
	for (count=1; count<=Length(inputF); count+=1)
		tempSum = 0
		tempL = Str.Elements(inputF[count], ' ')
		partLine[count] = tempL[1]
		partLine[count] = Str.Format('%1?%2?%3?%4?%5', partLine[count],partLine[count],partLine[count],partLine[count],partLine[count])
		if IsDefined(Pattern.Find( partLine[count], ".[.]+"))
			partLine[count] = Pattern.Change( partLine[count], ".[.]+", '.' ) // Lets tidy
		end
		if partLine[count][1] == '.'
			partLine[count] = partLine[count][2:]
		end
		if partLine[count][Length(partLine[count])] == '.'
			partLine[count] = partLine[count][:-2]
		end  
		inpElem[count] = Str.Elements(tempL[2], ',')
		// Wish I could force the elements as integers at first.
		for (icount=1; icount<=Length(inpElem[count]); icount+=1)
			inpElem[count][icount] = Str.StringToInteger(inpElem[count][icount])
			tempSum += inpElem[count][icount] + 1
		end
		inpElem[count] = { @inpElem[count], @inpElem[count], @inpElem[count], @inpElem[count], @inpElem[count] }
		tempSum = tempSum*5
		tempSum -= 1 // don't need the final space.
		curSum += findSlot(partLine[count], inpElem[count], tempSum)
	end
	echo('Answer: '+Str.String(curSum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
end
	
function Integer findSlot(String parts, List inputs, Integer remlen)
	Integer sum = 0
	// Base cases.
	if remlen > Length(parts); return 0; end
	if IsUndefined(parts) || Length(parts)==0
		if IsUndefined(inputs) || Length(inputs) == 0 
			return 1
		else
			return 0
		end
	end
	// Next base: All matches done. Just check if extra known damaged. If so, not valid.
	if IsUndefined(inputs) || Length(inputs) == 0
		if (IsDefined(Str.Chr(parts, '#')))
			return 0
		else
			return 1
		end
	end
	// Check if current one is cached
	String cacheKey = parts+Str.ValueToString(inputs)
	Integer cacheVal = $$globCache.(cacheKey)
	if IsDefined(cacheVal); return cacheVal; end
	// First block: if . or ?, chop it off and try the shorter string.
	if parts[1] == '.' || parts[1] == '?'
		sum += findSlot(parts[2:], inputs, remlen);
	end
	// Second block: if ? or # try this with the current input.
	// Then strip the input (and match) and continue on the shorter string.
	if parts[1] == '#' || parts[1] == '?'
		if (inputs[1] <= Length(parts) && IsUndefined(Str.Chr(parts[:inputs[1]], '.')) &&
				(Length(parts) == inputs[1] || parts[inputs[1]+1] != '#'))
			if Length(parts) == inputs[1]
				sum += findSlot('', inputs[2:], remlen-inputs[1]-1);
			else
				sum += findSlot(parts[inputs[1]+2:], inputs[2:], remlen-inputs[1]-1);
			end
		end
	end
	$$globCache.(cacheKey)=sum; // Assign the value to the cache.
	return sum;
end

function List loadData()
	List incoming
	String s
	File fr = File.open("Z:\AdventOfCode\Inputs\2023\12-input.txt", File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end
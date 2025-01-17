/*
 * Find ones where they increment/decrement constantly only span 1-3.
 * Can have one item removed and still be good.
 * 7 6 4 2 1
 * 1 2 7 8 9
 * 9 7 6 2 1
 * 1 3 2 4 5
 * 8 6 4 4 1
 * 1 3 6 7 9
 *
 * 0.03 seconds
 */
function String runme()
	List inputF
	Boolean asc=undefined,good=true, good2=true
	integer count, Starter=Date.Tick(), sum=0
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-02-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		if isGood(inputF[count], true)
			// Check if the base list is good.
			sum += 1
		elseif isGood(inputF[count][2:], false)
			// If not, edge case one is the first one is bad. Test with one strike.
			sum += 1
		elseif isGood({inputF[count][1], @inputF[count][3:]}, false)
			// If not, edge case two is the second one is bad (affects our asc/desc.) Test with one strike.
			sum += 1
		end
	end
	echo("Part 2 answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function boolean isGood(List incom, Boolean good)
	Integer c, curnum, tnum
	Boolean good2=true, asc=false
	curnum = Str.StringToInteger(incom[1])
	if curnum - Str.StringToInteger(incom[2]) < 0
		asc = true
	else
		asc = false
	end
	for (c=2; c<=Length(incom); c+=1)
		if good2
			tnum = curnum - Str.StringToInteger(incom[c])
			if !asc && tnum >=1 && tnum <=3
				curnum =  Str.StringToInteger(incom[c])
			elseif asc && tnum >=-3 && tnum <=-1
				curnum =  Str.StringToInteger(incom[c])
			else
				if good
					good=false
				elseif good2
					good2=false
				end
			end
		end
	end
	return good2
end

// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, Str.Elements(s, ' ')}
		end
		File.Close(fr)
	end
	return incoming
end
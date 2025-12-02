/*
 * Valid any number of repeats in range.
11-22,95-115,998-1012,1188511880-1188511890,
* 222220-222224,1698522-1698528,446443-446449,
* 38593856-38593862,565653-565659,824824821-824824827,
* 2121212118-2121212124
* //  0.687 seconds
 */
function String runme()
	List inputF, nList
	integer count, count2, Starter=Date.Tick(), numRs=0, fhalf, curCnt=0
	integer cur, lenTwo, lenOne, nXs, nXsLoop
	String tNum
	$$hits = Assoc.CreateAssoc()
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\02-input.txt")
	// In this case, we'll look only at lengths with r0 mods.
	for (count=1;count<=Length(inputF); count+=1)
		nList=Str.Elements(inputF[count],'-')
		lenOne=Length(nList[1])
		lenTwo=Length(nList[2])
		if(lenTwo==1)
			continue
		end
		if(lenOne!=lenTwo)
			curCnt+=NumEnts(lenOne, Str.StringToInteger(nList[1]), \
			 Str.StringToInteger("1"+Str.Set(lenOne,"0"))-1, \
			 Str.StringToInteger(Str.Set(lenOne/2, "9")))
			curCnt+=NumEnts(lenTwo, Str.StringToInteger("1"+Str.Set(lenOne,"0")), \
			 Str.StringToInteger(nList[2]), \
			 Str.StringToInteger(nList[2][:lenTwo/2]))
		else
			curCnt+=NumEnts(lenTwo, Str.StringToInteger(nList[1]), \
			 Str.StringToInteger(nList[2]), \
			 Str.StringToInteger(nList[2][:lenTwo/2]))
		end
	end
	echo(Str.ValueToString(curCnt)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end

// Find in range.
function integer NumEnts(integer digits, integer rStart, integer rEnd, integer hlfEnd)
	integer curCnt=0, cur, nXs, nXsLoop
	String tNum
	if(digits==1)
		return 0
	end
	nXs=digits
	for(cur=1;cur<=hlfEnd;cur+=1)
		if(digits%Length(Str.ValueToString(cur))!=0)
			cur=Str.StringtoInteger("1"+Str.Set(Length(Str.ValueToString(cur)),"0"))-1
			nXs=digits/Length(Str.ValueToString(cur+1))
		else
			tNum=Str.ValueToString(cur)
			for(nXsLoop=2;nXsLoop<=nXs;nXsLoop+=1)
				tNum+=Str.ValueToString(cur)
			end
			if(Str.StringToInteger(tNum)<rStart)
				continue
			elseif(Str.StringToInteger(tNum)>rEnd)
				cur=Str.StringtoInteger("1"+Str.Set(Length(Str.ValueToString(cur)),"0"))-1
				nXs=digits/Length(Str.ValueToString(cur+1))
			else
				// Kosher.
				if(isUndefined($$hits.(tNum)))
					curCnt+=Str.StringToInteger(tNum)
					$$hits.(tNum)=1
				end
			end
		end
	end
	return curCnt
end
// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65535); s!=File.E_Eof; s=File.Read(fr, 65535))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return Str.Elements(incoming[1], ',')
end

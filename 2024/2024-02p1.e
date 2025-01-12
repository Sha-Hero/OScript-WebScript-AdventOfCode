/*
 * Find ones where they increment/decrement constantly only span 1-3.
 * 7 6 4 2 1
 * 1 2 7 8 9
 * 9 7 6 2 1
 * 1 3 2 4 5
 * 8 6 4 4 1
 * 1 3 6 7 9
 * 0.02 seconds
 */
function String runme()
	List inputF
	Boolean asc=false, good=true
	integer count, count2, Starter=Date.Tick(), sum=0, sum2=0, cur
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-02-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		good = true
		cur=Str.StringToInteger(inputF[count][1])
		if Str.StringToInteger(inputF[count][2]) > cur
			asc=true
		else
			asc=false
		end
		for (count2=2; count2<=Length(inputF[count]); count2+=1)
			if good
				sum = cur - Str.StringToInteger(inputF[count][count2])
				if !asc && sum >=1 && sum <=3
					cur =  Str.StringToInteger(inputF[count][count2])
				elseif asc && sum >=-3 && sum <=-1
					cur =  Str.StringToInteger(inputF[count][count2])
				else
					good=false
				end
			end
		end
		if good
			sum2 += 1
		end
	end
	echo("Part 1 answer: "+Str.String(sum2)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
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

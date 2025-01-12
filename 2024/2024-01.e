/*
 * Number list lowest to highest both sides.
 *
 * 3   4
 * 4   3
 * 2   5
 * 1   3
 * 3   9
 * 3   3
 * 0.02 seconds
 */
function String runme()
	List inputF, rever={}
	integer count, count2, Starter=Date.Tick(), sum=0, sum2=0
	Assoc cc = Assoc.CreateAssoc()
	String key
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-01-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		rever = {@rever, {inputF[count][2], inputF[count][1]} }
		if !IsDefined(cc.(inputF[count][2]))
			cc.(inputF[count][2]) = 1
		else
			cc.(inputF[count][2]) += 1
		end
	end
	inputF=List.Sort(inputF)
	rever=List.Sort(rever)
	for (count=1; count<=Length(inputF); count+=1)
		if IsDefined(cc.(inputF[count][1]))
			sum2 += cc.(inputF[count][1])*Str.StringToInteger(inputF[count][1])
		end
		sum += Math.Abs(Str.StringToInteger(inputF[count][1])-Str.StringToInteger(rever[count][1]))
	end
	echo("Part 1 answer: "+Str.String(sum))
	echo('Part 2 answer: '+Str.String(sum2)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, {Str.Elements(s, ' ')[1], Str.Elements(s, ' ')[4]}}
		end
		File.Close(fr)
	end
	return incoming
end

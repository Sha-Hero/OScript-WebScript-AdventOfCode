/*
 * Find mul() between do and dont
 *
 * xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
 * 0.008 seconds
 */
function String runme()
	String inputF
	integer count=0, count2, Starter=Date.Tick(), sum=0
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-03-input.txt")
	String  search = "mul(<[0-9]+>,<[0-9]+>)"
	String  s = inputF, s2=''
	count = Str.Locate(s, "don't()")
	while IsDefined(count)
		s2 += s[:count+1]
		s = s[count+1:]
		count = Str.Locate(s, "do()")
		if IsDefined(count)
			s = s[count+1:]
			count = Str.Locate(s, "don't()")
			if !IsDefined(count)
				s2 += s
			end
		end
	end
	//	echo(s2)
	List result
	s = s2
	result = Pattern.Find( s, search )
	while ( IsDefined( result ) )
		sum += Str.StringToInteger(result[4])*Str.StringToInteger(result[5])
		s = s[ result[ 2 ] : ]
		result = Pattern.Find( s, search )
	end
	echo("Part 2 answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

// Load the file.
function String loadData(String path)
	String incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65534); s!=File.E_Eof; s=File.Read(fr, 65534))
			incoming += "."+s
		end
		File.Close(fr)
	end
	return incoming
end
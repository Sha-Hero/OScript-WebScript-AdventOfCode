/*
 * Find mul() strict pattern match
 *
 * xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
 * 0.01 seconds
 */
function String runme()
	List inputF
	integer count, count2, Starter=Date.Tick(), sum=0
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-03-input.txt")
	String  search = "mul(<[0-9][0-9]*[0-9]*>,<[0-9][0-9]*[0-9]*>)"
	String  s
	PatFind finder = Pattern.CompileFind( search )
	List result
	for (count=1; count<=Length(inputF); count+=1)
		s = inputF[count]
		result = Pattern.Find( s, finder )
		while ( IsDefined( result ) )
			sum += Str.StringToInteger(result[4])*Str.StringToInteger(result[5])
			s = s[ result[ 2 ] : ]
			result = Pattern.Find( s, finder )
		end
	end
	echo("Part 1 answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65534); s!=File.E_Eof; s=File.Read(fr, 65534))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end

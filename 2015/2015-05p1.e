/*
 * Naughty/nice strings. Which have vowels, not certain matches, etc.
dmrtgdkaimrrwmej
ztxhjwllrckhakut
gdnzurjbbwmgayrg
// 0.017 seconds
 */
function String runme()
	List inputF
	integer count, Starter=Date.Tick(), count2, nice=0
	String curLine, curChar
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2015\05-input.txt")
	for (count=1;count<=Length(inputF); count+=1)
		curLine=inputF[count]
		if(isdefined(Str.Locate(curLine, 'ab')) \ 
		  || isdefined(Str.Locate(curLine, 'cd')) \
		  || isdefined(Str.Locate(curLine, 'pq')) \
		  || isdefined(Str.Locate(curLine, 'xy')) \
		)
			// echo("NOT Kosher - forbidden: "+curLine)
			continue
		end
		if(Length(curLine)<Length(Str.Strip(curLine, 'aeiou'))+3)
			// echo("NOT Kosher - vowels: "+curLine)
			continue
		end
		// Last check - any doubles?
		curChar=curLine[1]
		for (count2=2;count2<=Length(curLine); count2+=1)
			if(curChar==curLine[count2])
				nice+=1
				break;
			else
				curChar=curLine[count2]
			end
		end
	end
	echo("Nice: "+Str.ValueToString(nice)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
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
	return incoming
end

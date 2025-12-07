/*
 * Naughty/nice strings. 2-char dupes, and char with one in middle.
dmrtgdkaimrrwmej
ztxhjwllrckhakut
gdnzurjbbwmgayrg
// 0.066 seconds
 */
function String runme()
	List inputF
	integer count, Starter=Date.Tick(), count2, count3, count4, nice=0
	String curLine, curChar
	Boolean ok=false, ok2=false
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2015\05-input.txt")
	for (count=1;count<=Length(inputF); count+=1)
		ok=false
		ok2=false
		curLine=inputF[count]
		// Check one - we can have lots of fun.
		for (count4=1;count4<=Length(curLine)-2;count4+=1)
			if(curLine[count4]==curLine[count4+2])
				ok=true
				break
			end
		end
		if(ok)
			// Step 2 - see if dups exist.
			for (count2=1;count2<=Length(curLine)-2;count2+=1)
				if(ok2)
					break
				end
				curChar=curLine[count2:count2+1]
				for (count3=count2+2;count3<=Length(curLine)-1;count3+=1)
					if(curChar==curLine[count3:count3+1])
						nice+=1
						ok2=true
						break
					end
				end
			end
		end
		ok=false
		ok2=false
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

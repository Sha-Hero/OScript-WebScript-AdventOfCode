/*
 * Find potential combinations that work with inputs.
r, wr, b, g, bwu, rb, gb, br

brwrr
bggr
gbbr
rrbgbr
ubwu
bwurrg
brgr
bbrgwb
 * 80 seconds
 */
function String runme()
	List inputF, in2={}
	$$ins={}
	$$p= Assoc.CreateAssoc() // probably need memoize.
	integer count=0, count2, Starter=Date.Tick(), sum=0
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-19-input.txt")
	$$ins = Str.Elements(Str.Strip(inputF[1], ' '), ',')
	for(count=1; count<=Length($$ins); count+=1)
		$$p.($$ins[count])={$$ins[count]}
		$$ins[count]={Length($$ins[count]), $$ins[count]}
	end
	$$ins = List.Sort($$ins, List.Descending) // have smallest ones first.
	inputF=inputF[3:]
	for(count=1; count<=Length(inputF); count+=1)
		if buildit(inputF[count])
			in2+={inputF[count]}
		end
	end
	$$p = Assoc.CreateAssoc()
	// OK, we have the kosher list.. now what?
	sum=0
	for(count=1; count<=Length(in2); count+=1)
		sum+= findit(in2[count])
	end
	echo("Part 2 answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function boolean buildit(String entry)
	Integer c
	if IsDefined($$p.(entry))
		return true
	end
	for (c=1; c<=Length($$ins); c+=1)
		if(entry[:$$ins[c][1]]==$$ins[c][2])
			if(buildit(entry[$$ins[c][1]+1:]))
				return true
			end
		end
	end
	return false
end
function integer findit(String entry)
	String key
	Integer c, c2=0
	Assoc tt=$$p
	List ty=$$ins
	if Length(entry)==0
		return 1
	end
	if IsDefined($$p.(entry))
		return $$p.(entry)
	end
	for (c=1; c<=Length($$ins); c+=1)
		if(entry[:$$ins[c][1]]==$$ins[c][2])
			c2+=findit(entry[$$ins[c][1]+1:])
		end
	end
	$$p.(entry)=c2
	return c2
end
// Load the file.
function List loadData(String path)
	List incoming, biglist
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65534); s!=File.E_Eof; s=File.Read(fr, 65534))
			incoming = { @incoming, s }
		end
		File.Close(fr)
	end
	return incoming
end
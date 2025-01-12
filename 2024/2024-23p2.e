/*
 * LAN party. Find biggest set.
kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
..etc.
// 0.1 seconds
*/
function String runme()
	List inputF, entry={}, e2, longone={}
	integer Starter=Date.Tick(), count
	Assoc a = Assoc.CreateAssoc()
	String la, lb, lc
	Boolean ok=true
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-23-input.txt")
	for(count=1;count<=Length(inputF);count+=1)
		entry = Str.Elements(inputF[count], '-')
		if !IsDefined(a.(entry[1]));a.(entry[1])={};end
		if !IsDefined(a.(entry[2]));a.(entry[2])={};end
		a.(entry[1])+={entry[2]}
		a.(entry[2])+={entry[1]}
	end
	// Almost certainly a more-efficient way to do this, but we'll just iterate through the connections.
	for la in Assoc.Keys(a)
		entry=a.(la)
		e2={la, entry[1]}
		for lb in entry[2:]
			ok = true
			for lc in e2
				if lb != lc 
					if !(lb in a.(lc))
						ok=false
						break
					end
				end
			end
			if ok
				e2+={lb}
			end
		end
		if Length(e2) > Length(longone)
			longone=e2
		end
	end
	echo(Str.Catenate(List.Sort(longone),','))
	echo("Length is: ", Length(longone))
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
end
// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65535);s!=File.E_Eof;s=File.Read(fr, 65535))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end
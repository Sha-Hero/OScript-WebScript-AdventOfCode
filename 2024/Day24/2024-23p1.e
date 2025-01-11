/*
 * LAN party. Find triples with t.
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
// 0.15 seconds
 */
function String runme()
	List inputF, entry={}, e2
	integer Starter=Date.Tick(), count, ca, cb
	Assoc a = Assoc.CreateAssoc(), b=Assoc.CreateAssoc()
	String la, lb
	Boolean tee=false
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-23-input.txt")
	for(count=1; count<=Length(inputF); count+=1)
		entry = Str.Elements(inputF[count], '-')
		if !IsDefined(a.(entry[1]))
			a.(entry[1])={}
		end
		if !IsDefined(a.(entry[2]))
			a.(entry[2])={}
		end
		a.(entry[1])+={entry[2]}
		a.(entry[2])+={entry[1]}
	end
	// Almost certainly a more-efficient way to do this, but we'll just iterate through the connections.
	for la in Assoc.Keys(a)
		tee=la[1]=='t'?true:false
		entry=a.(la)
		for(ca=1; ca<=Length(entry)-1; ca+=1)
			for(cb=ca+1; cb<=Length(entry); cb+=1)
				if entry[ca] in a.(entry[cb])
					if tee || entry[ca][1]=='t' || entry[cb][1]=='t'
						b.(List.Sort({entry[ca], entry[cb], la}))=true
					end
				end
			end
		end
	end
	echo("Sum is: ", Length(Assoc.Keys(b)))
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
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

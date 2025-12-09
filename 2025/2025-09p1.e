/*
 * Biggest rectangle with two corners.
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
// 0.6 sec
 */
function String runme()
	integer Starter=Date.Tick()
	echo("Starting...")
	List inputF
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\09-input.txt")
	List nList={}, tList
	Integer count, count2, cntr
	Assoc dAssoc=Assoc.CreateAssoc({})
	for(count=1;count<=Length(inputF);count+=1)
		tList=Str.Elements(inputF[count], ',')
		nList+={{Str.StringToInteger(tList[1]),Str.StringToInteger(tList[2]),Str.StringToInteger(tList[3])}}
	end
	// 
	echo("Loaded : "+Str.String(Date.Tick()-Starter)+" ticks")
	for(count=1;count<Length(nList);count+=1)
		for(count2=count+1;count2<=Length(nList);count2+=1)
			cntr=(Math.ABS(nList[count][1]-nList[count2][1])+1) * \
				(Math.ABS(nList[count][2]-nList[count2][2])+1)
			dAssoc.(cntr)+={List.Sort({nList[count],nList[count2]})}
		end
	end
	echo(Str.ValueToString(Assoc.Keys(dAssoc)[-1])+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end
// Load the file
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

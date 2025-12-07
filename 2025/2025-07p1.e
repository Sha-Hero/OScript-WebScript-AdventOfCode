/*
 * How many chevrons hit going down
.......S.......
...............
.......^.......
...............
......^.^......
...............
.....^.^.^.....
...............
....^.^...^....
...............
...^.^...^.^...
...............
..^...^.....^..
...............
.^.^.^.^.^...^.
...............
* 0.011 seconds
 */
function String runme()
	List inputF, pList={}, tList
	integer Starter=Date.Tick()
	Integer count, curs, sum=0
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\07-input.txt")
	pList[1]=Str.Chr(inputF[1],'S')
	for(count=2;count<=Length(inputF);count+=1)
		tList={}
		for curs in List.Sort(pList)
			if(inputF[count][curs]=='^')
				sum+=1
				tList=List.SetAdd(tList, curs-1)
				tList=List.SetAdd(tList, curs+1)
			else
				tList=List.SetAdd(tList, curs)
			end
		end
		pList=tList
	end
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end
// Load the file - SKIPS LINES.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	Boolean ld=true
	if (!IsError(fr))
		for (s=File.Read(fr, 65535); s!=File.E_Eof; s=File.Read(fr, 65535))
			if(ld)
				incoming = { @incoming, s}
			end
			ld=ld?false:true
		end
		File.Close(fr)
	end
	return incoming
end 

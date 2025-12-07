/*
 * How many potential paths hit going down
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
* 0.010 seconds
// Happy with this. Could maybe make faster if loaded as assoc.
* 3ms overhead for loading the file.
 */
function String runme()
	integer Starter=Date.Tick()
	List inputF, pList={}, tList
	Integer count, curs, sum=1
	Assoc rolls=Assoc.CreateAssoc(0), rolls2=Assoc.CreateAssoc(0)
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\07-input.txt")
	rolls.(Str.Chr(inputF[1],'S'))=1
	for(count=2;count<=Length(inputF);count+=1)
		rolls2=Assoc.CreateAssoc(0)
		for curs in Assoc.Keys(rolls)
			if(inputF[count][curs]=='^')
				sum+=rolls.(curs)
				rolls2.(curs-1)+=rolls.(curs)
				rolls2.(curs+1)+=rolls.(curs)
			else
				rolls2.(curs)+=rolls.(curs)
			end
		end
		rolls=rolls2
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

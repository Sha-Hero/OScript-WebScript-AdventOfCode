/*
 * Count the trailheads
89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732
 */
// 0.11 seconds
// 
function String runme()
	List inputF, coord, nlist={}
	integer Starter=Date.Tick(), c, c2, sum
	$a = Assoc.CreateAssoc()
	String p
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-10-input.txt")
	integer height=Length(inputF), width=Length(inputF[1])
	for(c=1; c<=height; c+=1)
		for(c2=1; c2<=width; c2+=1)
			p=inputF[c][c2]
			if IsDefined($a.(p))
				$a.(p)+={{c, c2}}
			else
				$a.(p)={{c, c2}}
			end
		end
	end
	// Loaded. Let's iterate.
	for coord in $a.('0')
		sum+=Length(thead(coord[1], coord[2], 1, {}))
	end
	echo("Sum is: " , sum)
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
end

function List thead(integer y, integer x, integer val, List nlist)
	integer tsum=0
	List opts
	String v=Str.ValueToString(val)
	for opts in {{y-1, x},{y+1,x},{y,x+1},{y,x-1}}
		if opts in $a.(v)
			if val==9
				nlist=List.SetAdd(nlist, {opts}) // Unique nines.
			else
				nlist = thead(opts[1], opts[2], val+1, nlist)
			end
		end
	end
	return nlist
end
// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end

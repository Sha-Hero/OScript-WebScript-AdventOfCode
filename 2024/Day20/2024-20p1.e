/*
 * Racetrack. Find shortcut.
###############
#...#...12....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
// 0.28 seconds
 */
function String runme()
	List inputF, m, n, entry
	integer Starter=Date.Tick(), count, dist=0, sum=0
	integer sx, sy, cx, cy, ex, ey, ty, tx
	Assoc a=Assoc.CreateAssoc() // Assoc with point as key, value is distance.
	Boolean ok=false
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-20-input.txt")
	for(count=1; count<=Length(inputF); count+=1)
		// Yes, inefficient I know, but it's one run through.
		if isdefined(Str.Locate(inputF[count], 'S'))
			sx=Str.Locate(inputF[count], 'S')
			sy=count
		end
		if isdefined(Str.Locate(inputF[count], 'E'))
			ex=Str.Locate(inputF[count], 'E')
			ey=count
		end
	end
	cy=sy; cx=sx
	a.({cy, cx}) = dist
	while !ok
		dist +=1
		for m in {{-1,0},{1,0},{0,-1},{0,1}}
			ty=cy+m[1]; tx=cx+m[2]
			if(inputF[ty][tx]=='.')
				a.({ty, tx}) = dist
				cy=ty; cx=tx
				inputF[cy][cx]='X'
				break
			end
			if ty==ey && tx==ex
				a.({ty, tx}) = dist
				ok=true
				break
			end
		end
	end
	// OK, map is done. Let's go through each point and find points two away.
	// Diff of 102.
	for entry in Assoc.Keys(a)
		dist=a.(entry)
		cy=entry[1]; cx=entry[2]
		// Because of idiosyncrasies of the question...
		for m in {{-1,0},{1,0},{0,-1},{0,1}}
			ty=cy+2*m[1]; tx=cx+2*m[2]
			if IsDefined(a.({ty, tx}))
				if a.({ty,tx})>=dist+102
					sum+=1
				end
			end
		end
	end
	echo ( "Sum is: ", sum)
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

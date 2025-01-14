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
// 145 seconds
 */
function String runme()
	List inputF, m, n, entry, ea, eb
	integer Starter=Date.Tick(), count, c2, dist=0, sum=0
	integer sx, sy, cx, cy, ex, ey, ty, tx
	integer leap=20, savedist=100, cl=0
	Assoc a=Assoc.CreateAssoc(), b=Assoc.CreateAssoc() // Assoc with point as key, value is distance.
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
	b.(Str.String(dist))={cy, cx}
	a.({cy, cx}) = dist
	while !ok
		dist +=1
		for m in {{-1,0},{1,0},{0,-1},{0,1}}
			ty=cy+m[1]; tx=cx+m[2]
			if(inputF[ty][tx]=='.')
				a.({ty, tx}) = dist
				b.(Str.String(dist))={ty, tx}
				cy=ty; cx=tx
				inputF[cy][cx]='X'
				break
			end
			if ty==ey && tx==ex
				a.({ty, tx}) = dist
				b.(Str.String(dist))={ty, tx}
				ok=true
				break
			end
		end
	end
	// OK, map is done. Let's go through each point and find points two away.
	// Diff of "leap".
	// Dist is max key
	sum=0
	for(count=dist; count>=savedist; count-=1)
		for(c2=0; c2<=(count-savedist); c2+=1)
			ea = b.(Str.String(count))
			eb = b.(Str.String(c2))
			cl= Math.Abs(ea[2]-eb[2])+Math.Abs(ea[1]-eb[1])
			if cl<=leap && count-c2-cl >= savedist
				sum+=1
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
/*
 * Shortest path. Max in one direction.
 * Djikstra
###############
#.......#....E#
#.#.###.#.###.#
#.....#.#...#.#
#.###.#####.#.#
#.#.#.......#.#
#.#.#####.###.#
#...........#.#
###.#.#####.#.#
#...#.....#.#.#
#.#.#.###.#.#.#
#.....#...#.#.#
#.###.#.#.#.#.#
#S..#.....#...#
###############*/
// 0.4 seconds
function String runme()
	List G, Q, entry
	Assoc D = Assoc.CreateAssoc()
	integer Starter=Date.Tick(), count
	integer Rs, Cs // number of rows and columns
	Integer dist, r, c, rr, cc, cost //
	String dir, dir2
	G=Loaddata("C:\AdventOfCodeInputs\2024\2024-16-input.txt")
	Rs = Length(G)
	Cs = Length(G[1])
	dist = 0
	Q = {{0,Rs-1,2, 'h'}} // Last two are previous coords.
	while Length(Q) > 0
		Q = List.Sort(Q) // 18 secs
		dist=Q[1][1]
		r=Q[1][2]
		c=Q[1][3]
		dir=Q[1][4]
		Q = Q[2:]
		if IsDefined(D.({r,c,dir}))
			continue
		end
		D.({r,c,dir}) = dist
		for entry in {{-1,0},{0,1},{1,0},{0,-1}}
			rr = r+entry[1]
			cc = c+entry[2]
			if rr>0 && rr<=Rs && cc>0 && cc<=Cs
				if G[rr][cc]=='#'
					continue // skip walls!
				end
				if dir=='h' && entry[1]!=0
					cost = 1001
					dir2 = 'v'
				elseif dir=='v' && entry[2]!=0
					cost = 1001
					dir2 = 'h'
				else
					cost=1
					dir2=dir
				end
				if IsDefined(D.({rr,cc,dir2}))
					continue
				end
				Q = List.SetAdd(Q, {dist+cost, rr, cc, dir2})
			end
			if rr == 2 && cc == Cs-1
				break
			end
		end
	end
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
	echo("Distance is: ", D.({2,Cs-1,'h'})<D.({2,Cs-1,'v'})?D.({2,Cs-1,'h'}):D.({2,Cs-1,'v'}))
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

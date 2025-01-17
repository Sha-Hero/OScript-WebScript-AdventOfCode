/*
 * Shortest path. Max in one direction. No reverse (only 90 deg turns) Path!
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
// 
function String runme()
	List G, Q, entry, path={}, poss={}
	Assoc D = Assoc.CreateAssoc()
	integer Starter=Date.Tick(), count
	integer Rs, Cs // number of rows and columns
	Integer dist, r, c, rr, cc, cost, co, ro //
	String dir, dir2
	G=Loaddata("C:\AdventOfCodeInputs\2024\2024-16-input.txt")
	Rs = Length(G)
	Cs = Length(G[1])
	dist = 0
	Q = {{0,Rs-1,2, 'h', Rs-1, 2}} // Last two are previous coords.
	while Length(Q) > 0
		Q = List.Sort(Q) // 18 secs
		dist=Q[1][1]
		r=Q[1][2]
		c=Q[1][3]
		dir=Q[1][4]
		co=Q[1][5]; ro=Q[1][6]
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
				Q = List.SetAdd(Q, {dist+cost, rr, cc, dir2, r, c})
			end
			if rr == 2 && cc == Cs-1
				break
			end
		end
	end
	// OK, now go backwards. Chop off any paths that are more than 1001 different.
	r=2; c=Cs-1
	if (D.({r,c,'v'}) < D.({r,c,'h'})); dir='v'; else; dir='h'; end
	dist=D.({r,c,dir})
	poss = {{r, c, dir, dist}}
	path={{r, c}}
	while Length(poss)>0
		r=poss[1][1]; c=poss[1][2]; dir=poss[1][3]; dist=poss[1][4]
		poss=poss[2:]
		for entry in {{-1,0},{0,1},{1,0},{0,-1}}
			rr = r+entry[1]
			cc = c+entry[2]
			if dir == 'v'
				if entry[1]!=0
					if IsDefined(D.({rr,cc,'v'})) && D.({rr,cc,'v'})==dist-1
						path=List.SetAdd(path, {rr,cc})
						poss=List.SetAdd(poss, {rr,cc,'v',dist-1})
					elseif IsDefined(D.({rr,cc,'h'})) && D.({rr,cc,'h'})==dist-1001
						path=List.SetAdd(path, {rr,cc})
						poss=List.SetAdd(poss, {rr,cc,'h',dist-1001})
					end
				elseif entry[2]!=0
					if IsDefined(D.({rr,cc,'h'})) && D.({rr,cc,'h'})==dist-1001
						path=List.SetAdd(path, {rr,cc})
						poss=List.SetAdd(poss, {rr,cc,'h',dist-1001})
					elseif IsDefined(D.({rr,cc,'v'})) && D.({rr,cc,'v'})==dist-1
						path=List.SetAdd(path, {rr,cc})
						poss=List.SetAdd(poss, {rr,cc,'v',dist-1})
					end
				end
			elseif dir == 'h'
				if entry[1]!=0
					if IsDefined(D.({rr,cc,'v'})) && D.({rr,cc,'v'})==dist-1001
						path=List.SetAdd(path, {rr,cc})
						poss=List.SetAdd(poss, {rr,cc,'v',dist-1001})
					elseif IsDefined(D.({rr,cc,'h'})) && D.({rr,cc,'h'})==dist-1
						path=List.SetAdd(path, {rr,cc})
						poss=List.SetAdd(poss, {rr,cc,'h',dist-1})
					end
				elseif entry[2]!=0
					if IsDefined(D.({rr,cc,'h'})) && D.({rr,cc,'h'})==dist-1
						path=List.SetAdd(path, {rr,cc})
						poss=List.SetAdd(poss, {rr,cc,'h',dist-1})
					elseif IsDefined(D.({rr,cc,'v'})) && D.({rr,cc,'v'})==dist-1001
						path=List.SetAdd(path, {rr,cc})
						poss=List.SetAdd(poss, {rr,cc,'v',dist-1001})
					end
				end
			end
		end
	end
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
	echo("path is length: ", Length(path))
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

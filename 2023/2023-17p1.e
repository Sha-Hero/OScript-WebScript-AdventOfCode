/*
 * Shortest path. Max in one direction. No reverse (only 90 deg turns)
 * Djikstra
 * 2413432311323
 * 3215453535623
 * 3255245654254
 * 3446585845452
 * 4546657867536
 * 1438598798454
 * 4457876987766
 * 3637877979653
 * 4654967986887
 * 4564679986453
 * 1224686865563
 * 2546548887735
 * 4322674655533
 * 212 seconds
 */
function String runme()
	List G, Q, entry, review
	Assoc D = Assoc.CreateAssoc()
	integer Starter=Date.Tick(), count
	integer Rs, Cs // number of rows and columns
	Integer dist, r, c, dir, indir, rr, cc, cost, new_dir, new_indir, ans //
	Boolean isvalid=FALSE, isnt_reverse=FALSE
	G=Loaddata("Z:\AdventOfCode\Inputs\2023\17-input.txt")
	Rs = Length(G)
	Cs = Length(G[1])
	dist = 0
	Q = {{0, 1,1, -1,-1}} // dist, r, c, dir, indir
	while Length(Q) > 0
		Q = List.Sort(Q) // 18 secs
		dist=Q[1][1]
		r=Q[1][2]
		c=Q[1][3]
		dir=Q[1][4]
		indir=Q[1][5]
		Q = Q[2:]
		if IsDefined(D.({r,c, dir, indir}))
			continue
		end
		D.({r,c, dir, indir}) = dist
		count = -1
		for entry in {{-1,0},{0,1},{1,0},{0,-1}}
			count += 1
			rr = r+entry[1]
			cc = c+entry[2]
			new_dir = count
			if (new_dir != dir)
				new_indir = 1
			else
				new_indir = indir+1
			end
			isnt_reverse = ((new_dir + 2)%4 != dir)
			
			isvalid = (new_indir<=3)
			if IsDefined(D.({rr,cc, new_dir,new_indir}))
				continue
			elseif rr>0 && rr<=Rs && cc>0 && cc<=Cs && isnt_reverse && isvalid
				cost = Str.StringToInteger(G[rr][cc])
				Q = List.SetAdd(Q, {dist+cost, rr, cc, new_dir, new_indir})
			end
		end
	end
	// Now find the smallest that starts with the last num.

	ans = 99999999999
	entry = Assoc.Keys(D)
	for (count=1; count<=Length(entry); count+=1)
		review = entry[count]
		if (review[1]==Rs && review[2]==Cs)
			ans = Math.Min(ans, D.(review))
		end
	end
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
	echo("Distance is: "+Str.String(ans))
	return "Done."
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

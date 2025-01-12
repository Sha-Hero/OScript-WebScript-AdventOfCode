/*
 * Shortest path. Falling blocks. Path!
 * Djikstra
5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
..etc
 */
// 30 seconds with moderate efficiency.
// 
function String runme()
	List G, Q, entry, path={}, poss={}, mp={}, T
	Assoc D = Assoc.CreateAssoc()
	integer Starter=Date.Tick(), cnt, cnt2
	integer Rs, Cs // number of rows and columns
	Integer dist, r, c, rr, cc, cost, co, ro
	//	Integer size=7, vals=12
	Integer size=71, vals=1024
	boolean ok=true
	T=Loaddata("C:\AdventOfCodeInputs\2024\2024-18-input.txt")
	mp={}; path={}; poss={}
	G=T[:vals]
	for(cnt=1; cnt<=size; cnt+=1)
		mp+={Str.Set(size, '.')}
	end
	Rs = size; Cs = size
	for(cnt=1; cnt<=Length(G); cnt+=1)
		entry = Str.Elements(G[cnt], ',')
		mp[Str.StringToInteger(entry[2])+1][Str.StringToInteger(entry[1])+1]='#'
	end
	while ok
		entry = Str.Elements(T[vals], ',')
		mp[Str.StringToInteger(entry[2])+1][Str.StringToInteger(entry[1])+1]='#'
		if Length(path)>0 && !({Str.StringToInteger(entry[2])+1, Str.StringToInteger(entry[1])+1} in path)
			vals+=1
			continue
		end
		G=mp
		dist = 0
		Q = {{0,1,1, 1, 1}} // Last two are previous coords.
		D = Assoc.CreateAssoc()
		while Length(Q) > 0
			Q = List.Sort(Q) 
			dist=Q[1][1]; r=Q[1][2]; c=Q[1][3]; co=Q[1][4]; ro=Q[1][5]
			Q = Q[2:]
			if IsDefined(D.({r,c}))
				continue
			end
			D.({r,c}) = dist
			for entry in {{-1,0},{0,1},{1,0},{0,-1}}
				rr = r+entry[1]
				cc = c+entry[2]
				if rr>0 && rr<=Rs && cc>0 && cc<=Cs
					if G[rr][cc]=='#'
						continue // skip walls!
					end
					cost=1
					if IsDefined(D.({rr,cc}))
						continue
					end
					Q = List.SetAdd(Q, {dist+cost, rr, cc, r, c})
				end
				if rr == Rs && cc == Cs
					break
				end
			end
		end
		if !IsDefined(D.({Rs, Cs}))
			ok = false
		else
			vals+=1
		end
		// OK, now go backwards. Ignore paths that are more than 1 different.
		r=Rs; c=Cs
		dist=D.({r,c})
		poss = {{r, c, dist}}
		path={{r, c}}
		while Length(poss)>0
			r=poss[1][1]; c=poss[1][2]; dist=poss[1][3]
			poss=poss[2:]
			for entry in {{-1,0},{0,1},{1,0},{0,-1}}
				rr = r+entry[1]
				cc = c+entry[2]
				if IsDefined(D.({rr,cc})) && D.({rr,cc})==dist-1
					path=List.SetAdd(path, {rr,cc})
					poss=List.SetAdd(poss, {rr,cc,dist-1})
				end
			end
		end
	end
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
	echo ("Coords is: ", T[vals], " and it's entry ", vals)
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
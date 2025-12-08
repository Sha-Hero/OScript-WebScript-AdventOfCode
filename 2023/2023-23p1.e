/*
 * Taking path want longest path
 * 2.8 seconds
 * #.#####################
 * #.......#########...###
 * #######.#########.#.###
 * ###.....#.>.>.###.#.###
 * ###v#####.#v#.###.#.###
 * ###.>...#.#.#.....#...#
 * ###v###.#.#.#########.#
 * ###...#.#.#.......#...#
 * #####.#.#.#######.#.###
 * #.....#.#.#.......#...#
 * #.#####.#.#.#########v#
 * #.#...#...#...###...>.#
 * #.#.#v#######v###.###v#
 * #...#.>.#...>.>.#.###.#
 * #####v#.#.###v#.#.###.#
 * #.....#...#...#.#.#...#
 * #.#########.###.#.#.###
 * #...###...#...#...#.###
 * ###.###.#.###v#####v###
 * #...#...#.#.>.>.#.>.###
 * #.###.###.#.###.#.#v###
 * #.....###...###...#...#
 * #####################.#
 * 0.24
 */
function String runme()
	// We're going to load the data and create a list of intersections that it then connects to.
	// Assoc <src vertex> = { { { x-inter1, y-inter1, }, dist1 }, ... { { x-interN, y-interN }, distN } }
	// Every intersection has a special character in front of it, which also points the direction.
	// Get lengths from each intersection to the next.
	List inputF, oneline = {}, results = {}
	Assoc intersection = Assoc.CreateAssoc()
	integer x, y, paths = 0, prevx, prevy
	integer count, sum = 0, Starter=Date.Tick()
	List curpaths = {} // Growing list of paths to take.
	Integer pathChoice = 0
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\23-input.txt")
	// All lists are x, y
	$$endPoint = { Length(inputF[Length(inputF)])-1, Length(inputF) }
	inputF[1][2] = 'v'
	prevx = 2; prevy = 1
	$$inmap = inputF;
	$$interassoc = intersection
	// findNextInter - next square, from square.
	curpaths = findNextInter( { 2, 2, 2, 1}) // Now we have the first intersection. We want to build them up.
	inputF = $$inmap
	intersection = $$interassoc
	while length(curpaths) > 0
		if Length(curpaths) == 1
			curpaths = findNextInter( curpaths[1])
		else
			curpaths = curpaths[2:] + findNextInter( curpaths[1])
		end
		inputF = $$inmap
	end
	// OK - we've got the parsed list of paths. Let's iterate.
	$$pathopts = {}
	getLongest({2,1}, Assoc.Copy(intersection), 0)
	echo(Str.Format("List max is: %1",List.Max($$pathopts)))
	//	echo(Str.Format("List max is: %1, with full list as: %2",List.Max($$pathopts), $$pathopts))
	echo(Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end

function void getLongest( List incomer, Assoc paths, integer curdist )
	List opts
	Assoc pather2
	if incomer==$$endpoint
		$$pathopts = { @$$pathopts, curdist }
	elseif IsDefined(paths.(incomer))
		//	echo (Str.Format("%1 is defined.", incomer))
		for opts in paths.(incomer)
			pather2 = Assoc.Copy(paths)
			Assoc.Delete(pather2, incomer)
			//	echo (Str.Format("Calling on %1.", opts))
			getLongest( opts[1], pather2, curdist+opts[2] )
		end
	else
		//	echo (Str.Format("%1 is NOT defined.", incomer))
	end
	return
end

function List findNextInter( List curcoords )
	integer x = curcoords[1], y= curcoords[2], paths = 0, dist = 1
	integer prevx = curcoords[3], prevy = curcoords[4]
	String u, d, l, r
	Assoc locassoc = $$interassoc
	List retVal = {}
	Boolean inc = false, found=false;
	switch $$inmap[y][x]
		case '^'; curcoords[2]-=1; end
		case 'v'; curcoords[2]+=1; end
		case '<'; curcoords[1]-=1; end
		case '>'; curcoords[1]+=1; end
	end
	$$inmap[y][x] = 'X'
	dist=1
	while 1==1
		found = false
		x = curcoords[1]; y= curcoords[2]
		if x==$$endPoint[1] && y==$$endPoint[2]
			echo("Exit found")
			if IsDefined(locassoc.({prevx, prevy}))
				locassoc.({prevx, prevy}) = { @locassoc.({prevx, prevy}), { { x, y }, dist+1 } }
			else
				locassoc.({prevx, prevy}) = { { { x, y }, dist } }
			end
			$$interassoc = locassoc
			return {}
		end
		if($$inmap[y][x] != 'I'); $$inmap[y][x] = 'X'; end;
		// Getting the up, down, left, right strings.
		if(y<Length($$inmap)); d=$$inmap[y+1][x]; else; d='#'; end;
		if(y>1); u=$$inmap[y-1][x]; else; u='#'; end;
		if(x<Length($$inmap[1])); r=$$inmap[y][x+1]; else; r='#'; end;
		if(x>1); l=$$inmap[y][x-1]; else; l='#'; end;
		// As we traverse... all dots, until an angle, and then one more dot, then more angles.
		// Now - expect one to be a '.', otherwise at least two will be ^v<>
		if (u=='.') || (u=='I') || (u=='^' && !inc)
			//echo("Up to %1",{x, y-1})
			curcoords = {x, y-1}
			if(u=='^'); inc = true; end;
			found = true;
		end
		if (d=='.') || (d=='I') || (d=='v' && !inc)
			//echo("Down to %1",{x, y+1})
			curcoords = {x, y+1}
			if(d=='v'); inc = true; end;
			found = true;
		end
		if (l=='.') || (l=='I') || (l=='<' && !inc)
			//echo("Left to %1",{x-1, y})
			curcoords = {x-1, y}
			if(l=='<'); inc = true; end;
			found = true;
		end
		if (r=='.') || (r=='I') || (r=='>' && !inc)
			//echo("Right to %1", {x+1, y})
			curcoords = {x+1, y}
			if(r=='>'); inc = true; end;
			found = true;
		end
		if !found
			if !inc && (u=='v' || d=='^' || l=='>' || r=='<')
				// we're blocked against an uphill.
				//				echo("Blocked!")
				return {} // It's a path we can't cross.
			elseif inc // && (u=='^' || d=='v' || l=='<' || r=='>')
				// Intersection and now have exit points.
				$$inmap[y][x] = 'I'
				if (u=='^')
					retVal = {@retVal, {x, y-1, x, y}}
				end
				if (d=='v')
					retVal = {@retVal, {x, y+1, x, y}}
				end
				if (l=='<')
					retVal = {@retVal, {x-1, y, x, y}}
				end
				if (r=='>')
					retVal = {@retVal, {x+1, y, x, y}}
				end
				dist += 1
				//				echo(Str.Format("Intersection: %1, distance: %2", { x, y }, dist))
				if IsDefined(locassoc.({prevx, prevy}))
					locassoc.({prevx, prevy}) = { @locassoc.({prevx, prevy}), { { x, y }, dist } }
				else
					locassoc.({prevx, prevy}) = { { { x, y }, dist } }
				end
				$$interassoc = locassoc
				return retVal
			else
				//				echo("Unknown situation.")
				return {}
			end
		end
		dist += 1
	end
	$$interassoc = locassoc
	return curcoords
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

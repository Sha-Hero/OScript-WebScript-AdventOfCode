/*
 * Taking path want longest path
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
 * 418 seconds
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
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\23-input.txt")
	// All lists are x, y
	$endPoint = { Length(inputF[Length(inputF)])-1, Length(inputF) }
	inputF[1][2] = 'v'
	prevx = 2; prevy = 1
	$inmap = inputF;
	$interassoc = intersection
	// findNextInter - next square, from square.
	curpaths = findNextInter( { 2, 2, 2, 1}) // Now we have the first intersection. We want to build them up.
	inputF = $inmap
	intersection = $interassoc
	while length(curpaths) > 0
		if Length(curpaths) == 1
			curpaths = findNextInter( curpaths[1])
		else
			curpaths = curpaths[2:] + findNextInter( curpaths[1])
		end
		inputF = $inmap
	end
	// OK - we've got the parsed list of paths. Let's iterate.
	$pathopts = {}
	getLongest({2,1}, {}, 0)
	echo(Str.Format("List max is: %1, with full list length as: %2",List.Max($pathopts), Length($pathopts)))
	echo(Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end

function void getLongest( List incomer, List taken, integer curdist )
	List opts
	if incomer==$endpoint
		$pathopts = { @$pathopts, curdist }
	elseif !(incomer in taken)
		//echo (Str.Format("%1 is defined.", incomer))
		for opts in $interassoc.(incomer)
			//	echo (Str.Format("Calling on %1. It's this long: %2", opts, Length(pather2)))
			getLongest( opts[1], {@taken, incomer}, curdist+opts[2] )
		end
	else
		//echo (Str.Format("%1 is NOT defined.", incomer))
	end
	return
end

function List findNextInter( List curcoords )
	integer x = curcoords[1], y= curcoords[2], paths = 0, dist = 1
	integer prevx = curcoords[3], prevy = curcoords[4]
	String u, d, l, r
	Assoc locassoc = $interassoc
	List retVal = {}
	Boolean inc = false, found=false;
	if x == 2 && y==2
		// Ya, cheaping out.
		curcoords[1]+=1
	elseif curcoords[1] > curcoords[3]
		curcoords[1]+=1
	elseif curcoords[1] < curcoords[3]
		curcoords[1]-=1
	elseif curcoords[2] > curcoords[4]
		curcoords[2]+=1
	elseif curcoords[2] < curcoords[4]
		curcoords[2]-=1
	end
	$inmap[y][x] = 'X'
	dist=1
	while 1==1
		found = false
		x = curcoords[1]; y= curcoords[2]
		if x==$endPoint[1] && y==$endPoint[2]
			// echo("Exit found")
			if IsDefined(locassoc.({prevx, prevy}))
				locassoc.({prevx, prevy}) = { @locassoc.({prevx, prevy}), { { x, y }, dist+1 } }
			else
				locassoc.({prevx, prevy}) = { { { x, y }, dist } }
			end
			$interassoc = locassoc
			return {}
		end
		if($inmap[y][x] != 'I'); $inmap[y][x] = 'X'; end;
		// Getting the up, down, left, right strings.
		if(y<Length($inmap)); d=$inmap[y+1][x]; else; d='#'; end;
		if(y>1); u=$inmap[y-1][x]; else; u='#'; end;
		if(x<Length($inmap[1])); r=$inmap[y][x+1]; else; r='#'; end;
		if(x>1); l=$inmap[y][x-1]; else; l='#'; end;
		// As we traverse... all dots, until an angle, and then one more dot, then more angles.
		// Now - expect one to be a '.', otherwise at least two will be ^v<>
		if (u=='.') || (u=='I') || ((u=='^' || u=='v') && !inc)
			curcoords = {x, y-1}
			if(u=='^' || u=='v'); inc = true; end;
			found = true;
		end
		if (d=='.') || (d=='I') || ((d=='v' || d=='^') && !inc)
			curcoords = {x, y+1}
			if(d=='v' || d=='^'); inc = true; end;
			found = true;
		end
		if (l=='.') || (l=='I') || ((l=='<' || l=='>' ) && !inc)
			curcoords = {x-1, y}
			if(l=='<' || l=='>' ); inc = true; end;
			found = true;
		end
		if (r=='.') || (r=='I') || ((r=='>' || r=='<' ) && !inc)
			curcoords = {x+1, y}
			if(r=='>' || r=='<'); inc = true; end;
			found = true;
		end
		if !found
			if inc
				// Intersection and now have exit points.
				$inmap[y][x] = 'I'
				if (u=='^' || u=='v')
					retVal = {@retVal, {x, y-1, x, y}}
				end
				if (d=='v' || d=='^')
					retVal = {@retVal, {x, y+1, x, y}}
				end
				if (l=='<' || l=='>')
					retVal = {@retVal, {x-1, y, x, y}}
				end
				if (r=='>' || r=='<')
					retVal = {@retVal, {x+1, y, x, y}}
				end
				dist += 1
				// echo(Str.Format("Intersection: %1, distance: %2", { x, y }, dist))
				if IsDefined(locassoc.({prevx, prevy}))
					locassoc.({prevx, prevy}) = { @locassoc.({prevx, prevy}), { { x, y }, dist } }
				else
					locassoc.({prevx, prevy}) = { { { x, y }, dist } }
				end
				if IsDefined(locassoc.({x, y}))
					locassoc.({x, y}) = { @locassoc.({x, y}), { { prevx, prevy }, dist } }
				else
					locassoc.({x, y}) = { { { prevx, prevy }, dist } }
				end
				$interassoc = locassoc
				return retVal
			else
				// echo("Unknown situation.")
				return {}
			end
		end
		dist += 1
	end
	$interassoc = locassoc
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

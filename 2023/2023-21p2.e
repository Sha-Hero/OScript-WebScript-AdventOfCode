/*
 * 2d map - find what spots to arrive in after x steps.
 * Endless 2d, keeps looping.
 * Was SUPER happy with this, but it's not the right approach.
 * Loved that it handled adding grids to each side.
 * See "GridRepeating" for the code.
 * Lagrange Intgerpolating Polynomial. Finds next sum in series(!)
 * Grid has start in centre of 131x131 grid, with clear lines u/d, l/r
 * Num steps is 26501365 - which is 202300*131 + 65
 * Some genius determined that you thus find: 65, 65+131, 65+2*131, you can interpolate.
 * For incoming: 65=3832, 196=33967, 327=94056, 458=184099, 589=304096
 * Using https://www.dcode.fr/lagrange-interpolating-polynomial
 * Input first three - get fourth. Input first four, get fifth.
 * Going to implement with Lagrange
 * ...........
 * .....###.#.
 * .###.##..#.
 * ..#.#...#..
 * ....#.#....
 * .##..S####.
 * .##..#...#.
 * .......##..
 * .##.#.####.
 * .##..##.##.
 * ...........
 * 7.2 s
 */
function String runme()
	List inputF
	integer count, count2, Starter=Date.Tick()
	integer startx, starty, width, height, boardx=0, boardy=0
	Assoc myspaceslength = Assoc.CreateAssoc()
	Assoc blockers = Assoc.CreateAssoc()
	Assoc boards = Assoc.CreateAssoc()
	List newSpaces={}, newSpacesTemp={}, vall={}
	String curSpot, curDef, tmpb, tmps //tmp board, tmp space
	Real totes
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\21-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		for (count2=1; count2<=Length(inputF[1]); count2+=1)
			if (inputF[count][count2]=='#')
				// Blocker
				blockers.(Str.Format("%1:%2", count, count2))=0 // like a block
			elseif(inputF[count][count2]=='S')
				starty=count; startx=count2;
			end
		end
	end
	boards.("0:0") = Assoc.Copy(blockers)
	width=Length(inputF[1]); height=Length(inputF)
	myspaceslength.(0)=1
	myspaceslength.(1)=0
	newSpaces = {Str.Format("0:0:%1:%2", starty, startx)}
	for (count=1; count<=328; count+=1)
		newSpacesTemp = {}
		// iterate through the current spots, find the new ones.
		// check the four spot
		if(count > 1)
			myspaceslength.(count) = myspaceslength.(count-2)
			Assoc.Delete(myspaceslength, count-2)
		end
		for curSpot in newSpaces
			boardy=Str.StringToInteger(Str.Elements(curSpot, ':')[1])
			boardx=Str.StringToInteger(Str.Elements(curSpot, ':')[2])
			starty=Str.StringToInteger(Str.Elements(curSpot, ':')[3])
			startx=Str.StringToInteger(Str.Elements(curSpot, ':')[4])
			// Up
			if starty-1==0
				tmpb = Str.Format("%1:%2", boardy-1, boardx)
				tmps = Str.Format("%1:%2", height, startx)
			else
				tmpb = Str.Format("%1:%2", boardy, boardx)
				tmps = Str.Format("%1:%2", starty-1, startx)
			end
			curDef=tmpb+":"+tmps
			if IsUndefined(boards.(tmpb))
				boards.(tmpb) = Assoc.Copy(blockers)
				// echo("New board: "+tmpb)
			end
			if IsUndefined(boards.(tmpb).(tmps))
				newSpacesTemp = List.SetAdd(newSpacesTemp, curDef)
			end
			// Down
			if starty==height
				tmpb = Str.Format("%1:%2", boardy+1, boardx)
				tmps = Str.Format("%1:%2", 1, startx)
			else
				tmpb = Str.Format("%1:%2", boardy, boardx)
				tmps = Str.Format("%1:%2", starty+1, startx)
			end
			curDef=tmpb+":"+tmps
			if IsUndefined(boards.(tmpb))
				boards.(tmpb) = Assoc.Copy(blockers)
				// echo("New board: "+tmpb)
			end
			if IsUndefined(boards.(tmpb).(tmps))
				newSpacesTemp = List.SetAdd(newSpacesTemp, curDef)
			end
			// Left
			if startx-1==0
				tmpb = Str.Format("%1:%2", boardy, boardx-1)
				tmps = Str.Format("%1:%2", starty, width)
			else
				tmpb = Str.Format("%1:%2", boardy, boardx)
				tmps = Str.Format("%1:%2", starty, startx-1)
			end
			curDef=tmpb+":"+tmps
			if IsUndefined(boards.(tmpb))
				boards.(tmpb) = Assoc.Copy(blockers)
				// echo("New board: "+tmpb)
			end
			if IsUndefined(boards.(tmpb).(tmps))
				newSpacesTemp = List.SetAdd(newSpacesTemp, curDef)
			end
			// Right
			if startx==width
				tmpb = Str.Format("%1:%2", boardy, boardx+1)
				tmps = Str.Format("%1:%2", starty, 1)
			else
				tmpb = Str.Format("%1:%2", boardy, boardx)
				tmps = Str.Format("%1:%2", starty, startx+1)
			end
			curDef=tmpb+":"+tmps
			if IsUndefined(boards.(tmpb))
				boards.(tmpb) = Assoc.Copy(blockers)
				// echo("New board: "+tmpb)
			end
			if IsUndefined(boards.(tmpb).(tmps))
				newSpacesTemp = List.SetAdd(newSpacesTemp, curDef)
			end
			boards.(Str.Format("%1:%2", boardy, boardx)).(Str.Format("%1:%2", starty, startx))=0
		end
		myspaceslength.(count) += Length(newSpacesTemp)
		newSpaces = newSpacesTemp
		newSpacesTemp = {}
		if count%131==65
			//			echo("Count is: "+Str.String(count)+" with: "+Str.String(myspaceslength.(count)))
			vall += { {count, myspaceslength.(count) } }
		end
	end
	// Got a list. looks like this:
	//	vall = { {65,3832}, {196,33967}, {327,94056} }
	echo("Vall is looking good: "+Str.String(vall))
	totes = lagrange( vall, 26501365 )
	echo('Sum is: '+Str.String(totes)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function real lagrange(List f, integer xi, integer n = undefined)
	// f is list of x,y points: e.g. { {1,2}, {2,4}, {8,16} }
	// xi is the term you want to get.
	// n is the number of terms to use. If blank, then uses full set.
	integer result=0, i, j, term
	n=IsDefined(n)?n:Length(f)
	for (i = 1; i <= n; i+=1)
		// Compute individual terms of above formula
		term = f[i][2]
		for (j = 1; j <= n; j+=1)
			if (j != i)
				term = term*(xi - f[j][1]) / (f[i][1] - f[j][1]);
			end
		end
		// Add current term to result
		result += term;
	end
	return result;
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

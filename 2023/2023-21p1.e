/*
 * 2d map - find what spots to arrive in after x steps.
 *
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
 * 0.16 seconds - don't need to track the spaces!
 */
function String runme()
	List inputF
	integer count, count2, Starter=Date.Tick(), sum=0
	integer startx, starty, width, height
	// OK, every step will expand, but also have "inner" steps available
	//  at x+2 steps.
	Assoc myspaceslength = Assoc.CreateAssoc()
	Assoc hitspaces = Assoc.CreateAssoc()
	List newSpaces={}, newSpacesTemp={}
	String curSpot, curDef
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\21-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		for (count2=1; count2<=Length(inputF[1]); count2+=1)
			if (inputF[count][count2]=='#')
				// Blocker
				hitspaces.(Str.Format("%1:%2", count, count2))=0 // like a block
			elseif(inputF[count][count2]=='S')
				starty=count; startx=count2;
			end
		end
	end
	width=Length(inputF[1]); height=Length(inputF)
	hitspaces.(Str.Format("%1:%2", starty, startx))=0
	myspaceslength.(0)=1
	myspaceslength.(1)=0
	newSpaces = {Str.Format("%1:%2", starty, startx)}
	for (count=1; count<=64; count+=1)
		newSpacesTemp = {}
		// iterate through the current spots, find the new ones.
		// check the four spot
		if(count > 1)
			myspaceslength.(count) = myspaceslength.(count-2)
			Assoc.Delete(myspaceslength, count-2)
		end
		for curSpot in newSpaces
			starty=Str.StringToInteger(Str.Elements(curSpot, ':')[1]); startx=Str.StringToInteger(Str.Elements(curSpot, ':')[2])
			curDef=Str.Format("%1:%2", starty-1, startx)
			if starty-1 > 0 && IsUndefined(hitspaces.(curDef))
				newSpacesTemp = List.SetAdd(newSpacesTemp, curDef)
			end
			curDef=Str.Format("%1:%2", starty+1, startx)
			if starty+1 <= height && IsUndefined(hitspaces.(curDef))
				newSpacesTemp = List.SetAdd(newSpacesTemp, curDef)
			end
			curDef=Str.Format("%1:%2", starty, startx-1)
			if startx-1 > 0 && IsUndefined(hitspaces.(curDef))
				newSpacesTemp = List.SetAdd(newSpacesTemp, curDef)
			end
			curDef=Str.Format("%1:%2", starty, startx+1)
			if startx+1 <= width && IsUndefined(hitspaces.(curDef))
				newSpacesTemp = List.SetAdd(newSpacesTemp, curDef)
			end
			hitspaces.(curSpot)=0
		end
		myspaceslength.(count) += Length(newSpacesTemp)
		newSpaces = newSpacesTemp
		newSpacesTemp = {}
	end
	echo('Sum is: '+Str.String(myspaceslength.(count-1))+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
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

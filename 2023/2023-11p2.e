/*
 * Distance between all pairs of "stars"
 * Empty rows/columns count as 1000000
 * For this we just track the rows/columns that they pass and add
 * 1 million for each one.
 * ...#......
 * .......#..
 * #.........
 * ..........
 * ......#...
 * .#........
 * .........#
 * ..........
 * .......#..
 * #...#.....
 * 1.6 s
 */
function String runme()
	List grid = {}, cx = {}, cy = {}, glxs = {}, inputF
	Integer count = 0, cnum, cnum2, cnum3
	integer Starter=Date.Tick()
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\11-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		cx = { @cx, count }
	end
	for (count=1; count<=Length(inputF); count+=1)
		grid = { @grid, inputF[count]}
		cnum2 = 0
		cnum = Str.Chr(inputF[count], '#' )
		if IsUndefined( cnum )
			cy = { @cy, count }
		else
			while IsDefined(cnum)
				cnum2 += cnum
				cx = List.SetRemove( cx, cnum2)
				cnum = Str.Locate( inputF[count][cnum2+1:], '#' )
			end
		end
	end
	// For part 2 we'll just check to see if the galaxies cross any of the lines. cx and cy have the deets
	// Generate the list of galaxies. This could probably be done without creating the whole grids, but hey ho.
	for (count = 1; count <= Length(grid); count += 1)
		cnum2 = 0
		cnum = Str.Chr(grid[count], '#' )
		while IsDefined(cnum)
			cnum2 += cnum
			glxs = { @glxs, { cnum2, count } }
			cnum = Str.Locate( grid[count][cnum2+1:], '#' )
		end
	end
	// Now add 'em up!
	count = 0
	cx = List.Sort( cx ); cy = List.Sort( cy ) // just in case.
	// Now we iterate through the galaxies - one point to another and see
	// if they cross any cx or cy (blank x and x lines.)
	// glxs is glxs[x][y]
	for (cnum = 1; cnum < Length(glxs); cnum += 1)
		for (cnum2 = cnum+1; cnum2 <= Length(glxs); cnum2 += 1)
			count += Math.Abs(glxs[cnum][1]-glxs[cnum2][1]) + Math.Abs(glxs[cnum][2]-glxs[cnum2][2])
			for cnum3 in cx
				if (glxs[cnum][1] < cnum3 && glxs[cnum2][1] > cnum3) || (glxs[cnum][1] > cnum3 && glxs[cnum2][1] < cnum3); count += 999999; end;
			end
			for cnum3 in cy
				if (glxs[cnum][2] < cnum3 && glxs[cnum2][2] > cnum3) || (glxs[cnum][2] > cnum3 && glxs[cnum2][2] < cnum3); count += 999999; end;
			end
		end
	end
	echo(Str.ValueToString(count)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return Str.String(count)
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

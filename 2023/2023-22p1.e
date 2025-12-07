/*
 * Tetris-y. Falling lines with x/y/z alignment
 * Falling down z.
 * Input is start/end of blocks, x/y/z
 * 1,0,1~1,2,1
 * 0,0,2~2,0,2
 * 0,2,3~2,2,3
 * 0,0,4~0,2,4
 * 2,0,5~2,2,5
 * 0,1,6~2,1,6
 * 1,1,8~1,1,9
 * 1.7 s
 */

function String runme()
	List inputF, oneline = {}, results = {}
	integer count, count2, count3, sum = 0, Starter=Date.Tick()
	Assoc grid = Assoc.CreateAssoc() // To hold the 3d grid.
	List fl={}, tl={}, templ // "from" list, "to" list, templist
	integer maxx=0, maxy=0, maxz=0, minner
	integer x1, x2, y1,y2, z1, z2
	integer single=0
	List kosher = {}
	String dir
	Boolean OK=FALSE
	// Load and prep data.
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\22-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		oneline = Str.Elements(inputF[count], '~')
		fl = Str.Elements(oneline[1], ',')
		tl = Str.Elements(oneline[2], ',')
		// Converting to ints AND ADDING 1 because 1-based arrays!!
		for (count2=1; count2<=3; count2+=1)
			fl[count2]=Str.StringToInteger(fl[count2])+1
			tl[count2]=Str.StringToInteger(tl[count2])+1
		end
		// Compared inputs to see is start was ever < end, but no.
		if(fl[1]>maxx); maxx=fl[1]; end;
		if(tl[1]>maxx); maxx=tl[1]; end;
		if(fl[2]>maxy); maxy=fl[2]; end;
		if(tl[2]>maxy); maxy=tl[2]; end;
		if(fl[3]>maxz); maxz=fl[3]; end;
		if(tl[3]>maxz); maxz=tl[3]; end;
		// Munge - want sortable list on Z.
		// Single cube will be considered a Z.
		//
		// { zval, direction, { sx, sy,sz }, { ex, ey, ez } }
		//
		// Sorted therefore is lowest (z), and then whether it's z or not
		// "grid" is the master data.
		dir=fl[3]!=tl[3]?'a':(fl[1]!=tl[1]?'x':(fl[2]!=tl[2]?'y':'a'));
		templ = {fl[3], dir, fl, tl }
		results = {@results, templ }
		kosher = {@kosher, Str.String(count)}
	end
	results = List.Sort(results)
	//	echo(Str.Format("There are %1 items.", Length(results)))
	// OK, data loaded, sorted by Z and we know the maxes.
	// Generate the sparse Assoc
	for(count=1; count<=Length(results); count+=1)
		x1=results[count][3][1]; x2=results[count][4][1]
		y1=results[count][3][2]; y2=results[count][4][2]
		z1=results[count][3][3]; z2=results[count][4][3]
		if(results[count][2]=='a')
			// Z entry
			for(count2=z1; count2<=z2; count2+=1)
				grid.({x1, y1, count2})=count
			end
		elseif(results[count][2]=='x')
			for(count2=x1; count2<=x2; count2+=1)
				grid.({count2, y1, z1})=count
			end
		elseif(results[count][2]=='y')
			for(count2=y1; count2<=y2; count2+=1)
				grid.({x1, count2, z1})=count
			end
		end
	end
	// OK, gridified. SettleDown! Could probably do this above to, but whatev's
	for(count=1; count<=Length(results); count+=1)
		x1=results[count][3][1]; x2=results[count][4][1]
		y1=results[count][3][2]; y2=results[count][4][2]
		z1=results[count][3][3]; z2=results[count][4][3]
		if(results[count][2]=='a')
			// Z entry. Easy case.
			count2=z1-1
			while(count2>0 && IsUndefined(grid.({x1, y1, count2})))
				grid.({x1, y1, count2})=count
				Assoc.Delete(grid, {x1, y1, z2})
				z2 -= 1
				count2 -= 1
			end
			if count2 > 0
				// It means we were blocked - by a single item (because it's z)
				kosher = List.SetRemove( kosher, Str.String(grid.({x1, y1, count2})))
			end
		elseif(results[count][2]=='x')
			// X entry
			single=0
			count2=z1-1
			OK = TRUE
			while OK && count2>0
				for (count3=x1; count3<=x2; count3+=1)
					if IsDefined(grid.({count3, y1, count2}))
						OK = FALSE
						if single == -1
							break
						elseif single > 0 && single != grid.({count3, y1, count2})
							// It means it's hit, and is not one that already touches
							single = -1
						else
							single = grid.({count3, y1, count2})
						end
					end
				end
				if OK
					for (count3=x1; count3<=x2; count3+=1)
						grid.({count3, y1, count2})=count
						Assoc.Delete(grid, {count3, y1, z2})
					end
					z2 -= 1
					count2 -= 1
				end
			end
			if single > 0
				kosher = List.SetRemove( kosher, Str.String(single))
			end
		elseif(results[count][2]=='y')
			// Y entry
			single = 0
			count2=z1-1
			OK = TRUE
			while OK && count2>0
				for (count3=y1; count3<=y2; count3+=1)
					if IsDefined(grid.({x1, count3, count2}))
						OK = FALSE
						if single == -1
							break
						elseif single > 0 && single != grid.({x1, count3, count2})
							// It means it's hit, and is not one that already touches
							single = -1
						else
							single = grid.({x1, count3, count2})
						end
					end
				end
				if OK
					for (count3=y1; count3<=y2; count3+=1)
						grid.({x1, count3, count2})=count
						Assoc.Delete(grid, {x1, count3, z2})
					end
					z2 -= 1
					count2 -= 1
				end
			end
			if single > 0
				kosher = List.SetRemove( kosher, Str.String(single))
			end
		end
	end
	// All settling has completed. Update the code above to:
	//  Create a list with all blocks. Remove any where it's the only
	//  one that a block above is resting on.
	echo(Str.Format("Deletable items count: %1", Length(kosher)))
	//	echo(Str.Format("Deletable items: %1", kosher))
	//	echo(Str.Format("Length=%1", Length(grid)))
	//	echo(Str.Format("grid is: %1", grid))
	//	echo(Str.Format("Maxx: %1, maxy: %2, maxz: %3",maxx, maxy, maxz))
	echo(Str.String(Date.Tick()-Starter)+" ticks")
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

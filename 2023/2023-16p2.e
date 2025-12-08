/*
 * Follow beam splits.
 * Lots of 2d traversal. Cache is key.
 * Note that this took over six minutes to run. Probably more efficiencies
 * if we cached parts of the map, but that is more complicated than
 * I wanted to go down.
 * .|...\....
 * |.-.\.....
 * .....|-...
 * ........|.
 * ..........
 * .........\
 * ..../.\\..
 * .-.-/..|..
 * .|....-|.\
 * ..//.|....
 * 33.8 s
 * Got to 30 seconds. Further opt could be to use assoc....
 */
function String runme()
	$$LD = Assoc.CreateAssoc()
	$$inputF = {}
	Integer Starter = Date.Tick(), curmax = 0, res=0, start
	$$inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\16-input.txt")
	//echo (Str.String($$inputF))
	// Grid is loaded. Traverse.
	for (start=1; start<=Length($$inputF); start+=1)
		Traverse(1, start, 'E') // Git 'er going.
		if (Length($$LD) > curmax)
			curmax = Length($$LD)
		end
		$$LD = Assoc.CreateAssoc()
	end
	for (start=0; start<Length($$inputF); start+=1)
		Traverse(Length($$inputF[1]), Length($$inputF)-start, 'W') // Git 'er going.
		if (Length($$LD) > curmax)
			curmax = Length($$LD)
		end
		$$LD = Assoc.CreateAssoc()
	end
	for (start=1; start<=Length($$inputF[1]); start+=1)
		Traverse(start, 1, 'S') // Git 'er going.
		if (Length($$LD) > curmax)
			curmax = Length($$LD)
		end
		$$LD = Assoc.CreateAssoc()
	end
	for (start=0; start<Length($$inputF[1]); start+=1)
		Traverse(Length($$inputF[1])-start, Length($$inputF), 'N') // Git 'er going.
		if (Length($$LD) > curmax)
			curmax = Length($$LD)
		end
		$$LD = Assoc.CreateAssoc()
	end
	echo ("Done. There are "+Str.String(curmax)+" squares.")
	echo(Str.String(Date.Tick()-Starter)+" ticks")
	return "Done"
end

function void Traverse( integer x, integer y, String dir )
	String d = $$inputF[y][x], key = Str.String(y)+'-'+Str.String(x)
	// \ and / are 90-degree bounce.
	// | and - are splitters if hit on flat.
	// . is empty space.
	while d != ''
		d = $$inputF[y][x]
		key = Str.String(y)+'-'+Str.String(x)
		if IsDefined($$LD.(key))
			if IsDefined(Str.Chr($$LD.(key), dir))
				return // We've been here before with this direction.
			else
				// Key exists but not this direction.
				$$LD.(key) += dir
			end
		else
			// New key and direction.
			$$LD.(key) = dir
		end
		if ((d == '\' && dir == 'E') || (d == '/' && dir == 'W'))
			// Going south
			if y < Length($$inputF)
				y += 1
				dir = 'S'
			else
				d = ''
			end
		elseif ((d == '\' && dir == 'W') || (d == '/' && dir == 'E'))
			// Going north
			if y > 1
				y -= 1
				dir = 'N'
			else
				d = ''
			end
		elseif ((d == '\' && dir == 'N') || (d == '/' && dir == 'S'))
			// Going west
			if x > 1
				x -= 1
				dir = 'W'
			else
				d = ''
			end
		elseif ((d == '\' && dir == 'S') || (d == '/' && dir == 'N'))
			// Going east
			if x < Length($$inputF[y])
				x += 1
				dir = 'E'
			else
				d = ''
			end
		elseif ((d == '|') && (dir == 'W' || dir=='E'))
			// splits N/S
			if y < Length($$inputF); Traverse( x, y+1, 'S'); end;
			if y > 1; y -= 1; dir='N'; else; d=''; end;
		elseif ((d == '-') && (dir == 'N' || dir=='S'))
			// splits E/W
			if x > 1; Traverse( x-1, y, 'W'); end;
			if x < Length($$inputF[y]); x += 1; dir='E'; else; d=''; end;
		else
			if (dir=='E' && x < Length($$inputF[y])); x+=1;
			elseif (dir == 'W' && x > 1); x -=1;
			elseif (dir == 'S' && y < Length($$inputF)); y += 1;
			elseif (dir == 'N' && y > 1); y -= 1;
			else; d = '';
			end
		end
	end
	return
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

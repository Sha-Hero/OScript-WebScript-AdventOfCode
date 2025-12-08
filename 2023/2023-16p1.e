/*
 * Follow beam splits.
 * Lots of 2d traversal
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
 * 0.12 s
 */
function String runme()
	$$LD = Assoc.CreateAssoc()
	$$inputF = {}
	Integer Starter = Date.Tick()
	$$inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\16-input.txt")
	//echo (Str.String($$inputF))
	// Grid is loaded. Traverse.
	Traverse(1,1, 'E') // Git 'er going.
	echo ("Done. There are "+Str.String(Length($$LD))+" squares.")
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

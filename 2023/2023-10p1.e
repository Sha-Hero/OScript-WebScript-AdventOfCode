/*
 * Follow pipes - find farthest spot.
 * Lots of 2d traversal
 * -L|F7
 * 7S-7|
 * L|7||
 * -L-J|
 * L|-JF
 * 0.05 s
 */
function String runme()
	List grid = {}, inputF
	Integer count=1, sx, sy, cx, cy // start x,y cur x,y
	String d, c // direction and character
	List padre
	Integer Starter = Date.Tick()
	PatFind myStr = Pattern.CompileFind( 'S')
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\10-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		grid = { @grid, inputF[count] }
		padre = Pattern.Find( inputF[count], myStr)
		if IsDefined(padre)
			// Found the start
			sx=padre[1]; sy=count
		end
	end
	// Grid is loaded. Traverse.
	cx = sx+1; cy=sy; count=1; d='e'
	// | is a vertical pipe connecting north and south.
	// - is a horizontal pipe connecting east and west.
	// L is a 90-degree bend connecting north and east.
	// J is a 90-degree bend connecting north and west.
	// 7 is a 90-degree bend connecting south and west.
	// F is a 90-degree bend connecting south and east.
	padre = {d}
	count=1
	while cx != sx || cy != sy
		c = grid[cy][cx] // Grid is y then x.
		switch c
			case '|'
				if d == 's'; cy += 1; elseif d == 'n'; cy -= 1; end;
			end
			case '-'
				if d == 'e'; cx += 1; elseif d == 'w'; cx -= 1; end;
			end
			case 'L'
				if d == 'w'; cy -= 1; d='n'; elseif d == 's'; cx += 1; d='e'; end;
			end
			case 'J'
				if d == 'e'; cy -= 1; d='n'; elseif d == 's'; cx -= 1; d='w'; end;
			end
			case '7'
				if d == 'e'; cy += 1; d='s'; elseif d == 'n'; cx -= 1; d='w'; end;
			end
			case 'F'
				if d == 'w'; cy += 1; d='s'; elseif d == 'n'; cx += 1; d='e'; end;
			end
		end;
		padre = { @padre, d }
		count += 1
	end
	echo(Str.String(count/2)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return Str.String(count/2) + ' with path: '+Str.ValueToString(padre)
end

function List parseInput(String incoming)
	List eachrow = { incoming } 
	return eachrow
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

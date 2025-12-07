/*
 * Pipe follow
 * Finding max enclosed. Start top left and check inside/outside.
 * -L|F7
 * 7S-7|
 * L|7||
 * -L-J|
 * L|-JF
 * 0.18 s
 */
function String runme()
	List grid = {}, gridc = {}, inputF = {}
	Integer count=1, cnt2, sx, sy, cx, cy // start x,y cur x,y
	Integer icount = 0, Starter=Date.Tick()
	String d, c // direction and character
	String out // where is 'outside' (u,d,l,r)
	List padre
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\10-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		grid = { @grid, inputF[count] }
		// Building an empty grid that we will populate with just the 
		// valid path. This will remove any extraneous pipes.
		gridc = { @gridc, Str.Set( Length(inputF[count]), '.') } 
		padre = Pattern.Find( inputF[count], 'S')
		if IsDefined(padre)
			// Found the start
			sx=padre[1]; sy=count
		end
	end
	// Grid is loaded. Traverse.
	// Replacing the character. This is based on the actual input, not generalized.
	if grid[sy][sx+1]=='F'
		gridc[sy][sx]='7'
		cx = sx-1; cy=sy; count=1; d='w'
	elseif grid[sy][sx+1]=='7'
		gridc[sy][sx]='L'
		cx = sx+1; cy=sy; count=1; d='e'
	else
		gridc[sy][sx]='F'
		cx = sx+1; cy=sy; count=1; d='e'
	end
	// | is a vertical pipe connecting north and south.
	// - is a horizontal pipe connecting east and west.
	// L is a 90-degree bend connecting north and east.
	// J is a 90-degree bend connecting north and west.
	// 7 is a 90-degree bend connecting south and west.
	// F is a 90-degree bend connecting south and east.
	padre = {d}
	while cx != sx || cy != sy
		c = grid[cy][cx] // Grid is y then x.
		gridc[cy][cx]=c // Filling in the "actual" grid with the path.
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
	// gridc contains only valid path items. Find top-left and start filling in "I".
	sx= Str.Locate( gridc[1], 'F') // Not generalized. This assumes the path hits the top row.
	out = 'u'; d = 'e'; cx = sx+1; cy = 1
	while cx != sx || cy != 1
		c = gridc[cy][cx] // Grid is y then x.
		switch c
			case '|'
				if out == 'r' && cx > 1 && gridc[cy][cx-1] == '.'; gridc[cy][cx-1]='I'; icount+=1; elseif out == 'l' && cx < Length(gridc[cy]) && gridc[cy][cx+1] == '.'; gridc[cy][cx+1]='I'; icount+=1; end;
				if d == 's'; cy += 1; elseif d == 'n'; cy -= 1; end;
			end
			case '-'
				if out == 'u' && cy < Length(gridc) && gridc[cy+1][cx] == '.'; gridc[cy+1][cx]='I'; icount+=1; elseif out == 'd' && cy > 1 && gridc[cy-1][cx] == '.'; gridc[cy-1][cx]='I'; icount+=1; end;
				if d == 'e'; cx += 1; elseif d == 'w'; cx -= 1; end;
			end
			case 'L'
				if d == 'w'
					if out == 'u'
						out = 'r'
						if cy < Length(gridc) && gridc[cy+1][cx] == '.'; gridc[cy+1][cx]='I'; icount+=1; end;
						if cx > 1 && gridc[cy][cx-1] == '.'; gridc[cy][cx-1]='I'; icount+=1; end;
					elseif out == 'd'; out = 'l'
					else; return "ERROR!"
					end
					cy -= 1; d='n'
				elseif d == 's'
					if out == 'r'
						out = 'u'
						if cy < Length(gridc) && gridc[cy+1][cx] == '.'; gridc[cy+1][cx]='I'; icount+=1; end;
						if cx > 1 && gridc[cy][cx-1] == '.'; gridc[cy][cx-1]='I'; icount+=1; end
					elseif out == 'l'; out = 'd'
					else; return "ERROR!"
					end
					cx += 1; d='e'
				end
			end
			case 'J'
				if d == 'e'
					if out == 'u'
						out = 'l'
						if cy < Length(gridc) && gridc[cy+1][cx] == '.'; gridc[cy+1][cx]='I'; icount+=1; end
						if cx < Length(gridc[cy]) && gridc[cy][cx+1] == '.'; gridc[cy][cx+1]='I'; icount+=1; end
					elseif out == 'd'; out = 'r'
					else; return "ERROR!"
					end
					cy -= 1; d='n'
				elseif d == 's'
					if out == 'l'
						out = 'u'
						if cy < Length(gridc) && gridc[cy+1][cx] == '.'; gridc[cy+1][cx]='I'; icount+=1; end
						if cx < Length(gridc[cy]) && gridc[cy][cx+1] == '.'; gridc[cy][cx+1]='I'; icount+=1; end
					elseif out == 'r'; out = 'd'
					else; return "ERROR!"
					end
					cx -= 1; d='w'
				end
			end
			case '7'
				if d == 'e'
					if out == 'd'
						out = 'l'
						if cx < Length(gridc[cy]) && gridc[cy][cx+1] == '.'; gridc[cy][cx+1]='I'; icount+=1; end
						if cy > 1 && gridc[cy-1][cx] == '.'; gridc[cy-1][cx]='I'; icount+=1; end
					elseif out == 'u'; out = 'r'
					else; return "ERROR!"
					end
					cy += 1; d='s'
				elseif d == 'n'
					if out == 'l'
						out = 'd'
						if cx < Length(gridc[cy]) && gridc[cy][cx+1] == '.'; gridc[cy][cx+1]='I'; icount+=1; end
						if cy > 1 && gridc[cy-1][cx] == '.'; gridc[cy-1][cx]='I'; icount+=1; end
					elseif out == 'r'; out = 'u'
					else; return "ERROR!"
					end
					cx -= 1; d='w'
				end
			end
			case 'F'
				if d == 'w'
					if out == 'd'
						out = 'r'
						if cx > 1 && gridc[cy][cx-1] == '.'; gridc[cy][cx-1]='I'; icount+=1; end
						if cy > 1 && gridc[cy-1][cx] == '.'; gridc[cy-1][cx]='I'; icount+=1; end
					elseif out == 'u'; out = 'l'
					else; return "ERROR!"
					end
					cy += 1; d='s'
				elseif d == 'n'
					if out == 'r'
						out = 'd'
						if cx > 1 && gridc[cy][cx-1] == '.'; gridc[cy][cx-1]='I'; icount+=1; end
						if cy > 1 && gridc[cy-1][cx] == '.'; gridc[cy-1][cx]='I'; icount+=1; end
					elseif out == 'l'; out = 'u'
					else; return "ERROR!"
					end
					cx += 1; d='e'
				end
			end
		end;
	end
	// OK - We have a sparsely-populated "I"nternals. Iterate again and any "." that touch I become I.
	count = 1
	while count != 0
		count = 0
		for (cnt2 = 2; cnt2 < Length( gridc ); cnt2 += 1)
			// No internals top or bottom line.
			sy = 0
			sx = Str.Chr( gridc[cnt2], 'I' )
			while IsDefined( sx )
				sy += sx
				if gridc[cnt2-1][sy] == '.'; gridc[cnt2-1][sy] = 'I'; count = 1; icount+=1; end;
				if gridc[cnt2+1][sy] == '.'; gridc[cnt2+1][sy] = 'I'; count = 1; icount+=1; end;
				if gridc[cnt2][sy-1] == '.'; gridc[cnt2][sy-1] = 'I'; count = 1; icount+=1; end;
				if gridc[cnt2][sy+1] == '.'; gridc[cnt2][sy+1] = 'I'; count = 1; icount+=1; end;
				sx = Str.Chr( gridc[cnt2][sy+1:], 'I')
			end
		end
	end
	// OK, all subs have been 
	echo(Str.String(icount)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return Str.String( icount )
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

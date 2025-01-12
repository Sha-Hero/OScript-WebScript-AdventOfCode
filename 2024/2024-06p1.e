/*
 * Find where dude exits map.
 * ....#.....
 * .........#
 * ..........
 * ..#.......
 * .......#..
 * ..........
 * .#..^.....
 * ........#.
 * #.........
 * ......#...
 * 0.04 s
 */
function String runme()
	List inputF
	integer count=0, count2, Starter=Date.Tick(), height, width, sum=0
	Integer cx, cy, cxo, cyo, dir=0 //0 up, 1 right, 2 down, 3 left
	Assoc vistd = Assoc.CreateAssoc()
	Boolean ok=true
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-06-input.txt")
	height=Length(inputF); width=Length(inputF[1])
	echo("Size of grid: ", height, " ", width)
	for (count=1; count<=Length(inputF); count+=1)
		// Find the starting point.
		cx = Str.Locate(inputF[count], '^')
		if IsDefined(cx)
			cy=count
			break;
		end
	end
	echo("Starting point: ", cx, " ", cy)
	vistd.(Str.Format("%1|%2", cy, cx))
	// Let's traverse!
	while ok==true
		cyo=cy; cxo=cx
		if(dir==0)
			if (cy == 1); ok=false; else; cy-=1; end; // we're out
		elseif(dir==2)
			if (cy==height); ok=false; else; cy+=1; end; // we're out
		elseif(dir==3)
			if (cx==1); ok=false; else; cx-=1; end;
		elseif(dir==1)
			if (cx==width); ok=false; else; cx+=1; end;
		else;
			echo("Unknown direction: ", dir)
		end
		if ok
			if (inputF[cy][cx]=='#') // Space is a blocker
				cy=cyo; cx=cxo
				dir = (dir+1)%4 // turn right.
			else // Space is OK
				vistd.(Str.Format("%1|%2", cy, cx)) = 1
			end
		end
	end
	echo("Exiting at: ", cy, " and ", cx)
	echo("Part 1 answer: "+Str.String(Length(Assoc.Keys(vistd)))+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65534); s!=File.E_Eof; s=File.Read(fr, 65534))
			incoming = { @incoming, s }
		end
		File.Close(fr)
	end
	return incoming
end
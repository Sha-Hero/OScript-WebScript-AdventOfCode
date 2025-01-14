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
 * 498 seconds 1577 at home - nope 163 seconds.
 */
function String runme()
	List inputF
	integer count=0, count2, Starter=Date.Tick(), sum=0
	Integer cx, cy, cxo, cyo, dir=0 //0 up, 1 right, 2 down, 3 left
	Assoc vistd = Assoc.CreateAssoc(), v2=Assoc.CreateAssoc()
	Boolean ok=true
	String entry
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-06-input.txt")
	$incopy = inputF
	$height=Length(inputF); $width=Length(inputF[1])
	echo("Size of grid: ", $height, " ", $width)
	for (count=1; count<=Length(inputF); count+=1)
		// Find the starting point.
		cx = Str.Locate(inputF[count], '^')
		if IsDefined(cx)
			cy=count
			break;
		end
	end
	$sx=cx; $sy=cy
	echo("Starting point: ", cx, " ", cy)
	vistd.(Str.Format("%1|%2", cy, cx))
	// Let's traverse!
	while ok
		cyo=cy; cxo=cx
		if(dir==0)
			if (cy == 1); ok=false; else; cy-=1; end; // we're out
		elseif(dir==2)
			if (cy==$height); ok=false; else; cy+=1; end; // we're out
		elseif(dir==3)
			if (cx==1); ok=false; else; cx-=1; end;
		elseif(dir==1)
			if (cx==$width); ok=false; else; cx+=1; end;
		else; echo("Unknown direction: ", dir)
		end
		if ok
			if (inputF[cy][cx]=='#') // Space is a blocker
				cy=cyo; cx=cxo
				dir = (dir+1)%4 // turn right.
			else // Space is OK
				if !IsDefined(vistd.(Str.Format("%1|%2", cy, cx)))
					vistd.(Str.Format("%1|%2", cy, cx)) = {dir}
				else
					vistd.(Str.Format("%1|%2", cy, cx)) = List.SetAdd(vistd.(Str.Format("%1|%2", cy, cx)), dir)
				end
			end
		end
	end
	// OK, got the path. Let's see about looping.
	for entry in Assoc.Keys(vistd)
		$incopy = inputF
		cy = Str.StringToInteger(Str.Elements(entry, "|")[1])
		cx = Str.StringToInteger(Str.Elements(entry, "|")[2])
		$incopy[cy][cx] = '#'
		if(doesitloop($sx, $sy, 0)); sum+=1; end // Starting the run from the beginning each time.
		// If I were doing this again, I might follow/start from each unique space on the path.
	end
	echo("Part 2 answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function boolean doesitloop(Integer cx, Integer cy, Integer dir)
	Integer count=0, cyo, cxo
	Assoc vistd = Assoc.CreateAssoc()
	boolean ok=true
	while ok
		cyo=cy; cxo=cx
		if(dir==0)
			if (cy == 1); ok=false; else; cy-=1; end; // we're out
		elseif(dir==2)
			if (cy==$height); ok=false; else; cy+=1; end; // we're out
		elseif(dir==3)
			if (cx==1); ok=false; else; cx-=1; end;
		elseif(dir==1)
			if (cx==$width); ok=false; else; cx+=1; end;
		end
		if ok
			if ($incopy[cy][cx]=='#') // Space is a blocker
				cy=cyo; cx=cxo
				dir = (dir+1)%4 // turn right.
			else // Space is OK
				if IsDefined(vistd.(Str.Format("%1|%2|%3", cy, cx, dir)))
					// looped
					//					echo("loop!")
					return true
				end
				vistd.(Str.Format("%1|%2|%3", cy, cx, dir)) = 1
			end
		end
	end
	return false
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

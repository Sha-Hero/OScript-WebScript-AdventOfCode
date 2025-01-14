/*
 * Pengo box moves
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<
 * 0.3 seconds!
 */
function String runme()
	List inputF, dirs={},dbg
	Boolean nl=false, fx=false
	integer count=0, count2=0, Starter=Date.Tick(), sum=0
	integer cx, cy
	String d
	$binit={}
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-15-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		if !fx && IsDefined(cx=Str.Locate(inputF[count], '@'))
			cy=count
			fx=true
		end
		if Length(inputF[count])==0 //just the newline
			nl=true
		elseif nl
			dirs = {@dirs, inputF[count]}
		else
			$binit = {@$binit, inputF[count]}
		end
	end
	// cx and cy are the starting point.
	$binit[cy][cx]='.' // make sure we replace the spot with a dot
	// Loaded. Let's iterate.
	for (count=1; count<=Length(dirs); count+=1)
		for (count2=1; count2<=Length(dirs[count]); count2+=1)
			d=dirs[count][count2]
			if(d=='<' && pushit(cx, cy, -1, 0)); cx-=1; $binit[cy][cx]='.'
			elseif(d=='>' && pushit(cx, cy, 1, 0)); cx+=1; $binit[cy][cx]='.'				
			elseif(d=='^' && pushit(cx, cy, 0, -1)); cy-=1; $binit[cy][cx]='.'				
			elseif(d=='v' && pushit(cx, cy, 0, 1)); cy+=1; $binit[cy][cx]='.'				
			end
		end
	end
	// brute force finding the barrels.
	for(count=1; count<=Length($binit); count+=1)
		for (count2=1; count2<=Length($binit[count]); count2+=1)
			if($binit[count][count2]=='O')
				sum+=(count-1)*100+count2-1
			end
		end
	end
	echo("Answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end	

function boolean pushit(integer x, integer y, integer xd, integer yd)
	x+=xd; y+=yd
	if ($binit[y][x]=='.')
		return true
	elseif ($binit[y][x]=='#')
		// Blocked
		return false
	else
		// Assume it's a barrel.
		while($binit[y][x]=='O')
			x+=xd; y+=yd
		end
		if($binit[y][x]=='#')
			// Blocked by wall.
			return false
		else
			// must be blank. Now it's a barrel though!
			$binit[y][x]='O'
			return true
		end
	end
	return false
end
// Load the file.
function List loadData(String path)
	List incoming, biglist
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

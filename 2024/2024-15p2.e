/*
 * Pengo box moves - scaled up!
########
#..O.O.#
##@.O..#
#...O..#
#.#.O..#
#...O..#
#......#
########

<^^>>>vv<v>>v<<
 * 0.4 seconds!
 */
function String runme()
	List inputF, dirs={},dbg
	Boolean nl=false
	integer count=0, count2=0, Starter=Date.Tick(), sum=0
	integer cx, cy
	String d
	$binit={}
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-15-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		if Length(inputF[count])==0 //just the newline
			nl=true
		elseif nl
			dirs = {@dirs, inputF[count]}
		else
			$binit = {@$binit, inputF[count]}
		end
	end
	// Now for part 2 - scale it up.
	for(count=1; count<=Length($binit); count+=1)
		for (count2=Length($binit[count]); count2>=1; count2-=1)
			if($binit[count][count2]=='#')
				$binit[count][count2]='##'
			elseif($binit[count][count2]=='O')
				$binit[count][count2]='[]'
			elseif($binit[count][count2]=='.')
				$binit[count][count2]='..'
			elseif($binit[count][count2]=='@')
				$binit[count][count2]='@.'
				cy=count
			end
		end
	end
	cx = Str.Locate($binit[cy], '@')
	// cx and cy are the starting point.
	$binit[cy][cx]='.' // make sure we replace the spot with a dot
	// Loaded. Let's iterate.
	for (count=1; count<=Length(dirs); count+=1)
		for (count2=1; count2<=Length(dirs[count]); count2+=1)
			d=dirs[count][count2]
			if(d=='<' && pushitH(cx, cy, -1)); cx-=1; $binit[cy][cx]='.'
			elseif(d=='>' && pushitH(cx, cy, 1)); cx+=1; $binit[cy][cx]='.'				
			elseif(d=='^' && pushitV(cx, cy, -1)); cy-=1; $binit[cy][cx]='.'				
			elseif(d=='v' && pushitV(cx, cy, 1)); cy+=1; $binit[cy][cx]='.'				
			end
		end
	end
	// brute force finding the barrels.
	for(count=1; count<=Length($binit); count+=1)
		//		echo($binit[count]) // To print it out if you want.
		for (count2=1; count2<=Length($binit[count]); count2+=1)
			if($binit[count][count2]=='[')
				sum+=(count-1)*100+count2-1
			end
		end
	end
	echo("Answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end	

// Horizontal moves are different from vertical because of the barrels.
function boolean pushitH(integer x, integer y, integer xd)
	String b
	integer tx=x+xd, count=0
	if ($binit[y][tx]=='.')
		return true
	elseif ($binit[y][tx]=='#')
		// Blocked
		return false
	else
		// Assume it's a barrel.
		b=$binit[y][tx]
		while(b=='[' || b==']')
			tx+=xd
			b=$binit[y][tx]
		end
		if(b=='#')
			// Blocked by wall.
			return false
		else
			// Must be blank. Skootch everything over by one.
			for(count=tx; count!=x; count-=xd)
				$binit[y][count]=$binit[y][count-xd]
			end
			return true
		end
	end
	return false
end
// Vertical - tricky. Count all edges, etc.
function boolean pushitV(integer x, integer y, integer yd)
	String b, bold
	List blocker={},ent={}
	Assoc bl=Assoc.CreateAssoc()
	integer ty=y+yd, count=1
	boolean ok=false
	b=$binit[ty][x] 
	if (b=='.')
		return true
	elseif (b=='#')
		// Blocked
		return false
	else
		// Assume it's a barrel. Need to see the vertical potential blockers.
		// And keep track of all items that will be potentially moving.
		if(b=='['); blocker={@blocker, {ty,x}, {ty,x+1}}
		else; blocker={@blocker, {ty,x-1}, {ty,x}}
		end
		bl.(count) = blocker
		while !ok
			ok=true
			blocker={}
			for ent in bl.(count)
				bold=$binit[ent[1]][ent[2]]
				b=$binit[ent[1]+yd][ent[2]]
				if(b=='#')
					return false
				elseif(b=='[')
					// Tricky - need unique values only.
					ok=false
					blocker=List.SetAdd(blocker, {ent[1]+yd,ent[2]})
					if(bold==']')
						blocker=List.SetAdd(blocker, {ent[1]+yd,ent[2]+1})
					end
				elseif(b==']')
					ok=false
					blocker=List.SetAdd(blocker, {ent[1]+yd,ent[2]})
					if(bold=='[')
						blocker=List.SetAdd(blocker, {ent[1]+yd,ent[2]-1})
					end
				end
			end
			count+=1
			bl.(count) = blocker
		end
		// Hey! All good. So.. shuffle everything one.
		while count>=1
			count-=1
			for ent in bl.(count)
				$binit[ent[1]+yd][ent[2]]=$binit[ent[1]][ent[2]]
				$binit[ent[1]][ent[2]]='.'
			end
		end
		return true
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

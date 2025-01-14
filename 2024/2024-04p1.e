/*
 * Find "xmas".
 * MMMSXXMASM
 * MSAMXMSMSA
 * AMXSXMAAMM
 * MSAMASMSMX
 * XMASAMXAMM
 * XXAMMXXAMA
 * SMSMSASXSS
 * SAXAMASAAA
 * MAMMMXMMMM
 * MXMXAXMASX
 * 0.06  seconds
 */
function String runme()
	List inputF
	integer count=0, count2, Starter=Date.Tick(), sum=0, width, height,curx
	String s
	Boolean u, d, l, r
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-04-input.txt")
	// Let's find all the X and build from there.
	height=Length(inputF); width=Length(inputF[1])
	for (count=1; count<=Length(inputF); count+=1)
		u=count>=4?true:false;
		d=count<=height-3?true:false;
		s = inputF[count]; curx=0
		count2=Str.Locate(s, 'X')
		while IsDefined(count2)
			curx += count2
			l=curx>=4?true:false;
			r=curx<=width-3?true:false;
			// OK. Easiest is just brute force the check
			if(u && inputF[count-1][curx]=='M' && inputF[count-2][curx]=='A' && inputF[count-3][curx]=='S'); sum+=1; end;
			if(u && l && inputF[count-1][curx-1]=='M' && inputF[count-2][curx-2]=='A' && inputF[count-3][curx-3]=='S'); sum+=1; end;
			if(u && r && inputF[count-1][curx+1]=='M' && inputF[count-2][curx+2]=='A' && inputF[count-3][curx+3]=='S'); sum+=1; end;
			if(d && inputF[count+1][curx]=='M' && inputF[count+2][curx]=='A' && inputF[count+3][curx]=='S'); sum+=1; end;
			if(d && l && inputF[count+1][curx-1]=='M' && inputF[count+2][curx-2]=='A' && inputF[count+3][curx-3]=='S'); sum+=1; end;
			if(d && r && inputF[count+1][curx+1]=='M' && inputF[count+2][curx+2]=='A' && inputF[count+3][curx+3]=='S'); sum+=1; end;
			if(l && inputF[count][curx-1]=='M' && inputF[count][curx-2]=='A' && inputF[count][curx-3]=='S'); sum+=1; end;
			if(r && inputF[count][curx+1]=='M' && inputF[count][curx+2]=='A' && inputF[count][curx+3]=='S'); sum+=1; end;
			s=s[count2+1:]
			count2=Str.Locate(s, 'X')
		end
	end
	echo("Part 1 answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
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
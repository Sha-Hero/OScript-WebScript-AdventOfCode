/*
 * Find "mas" in shape of X. Easy modification from part 1.
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
 * 0.035  seconds
 */
function String runme()
	List inputF
	integer count=0, count2, Starter=Date.Tick(), sum=0, width, height,curx
	String s
	Boolean v, h // vert and horiz now.
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-04-input.txt")
	// Let's find all the A and build from there.
	height=Length(inputF); width=Length(inputF[1])
	for (count=1; count<=Length(inputF); count+=1)
		v=count>=2&&count<=height-1?true:false;
		s = inputF[count]; curx=0
		count2=Str.Locate(s, 'A') // looking for "A" now as it's the middle character
		while IsDefined(count2)
			curx += count2
			h=v&&curx>=2&&curx<=width-1?true:false;
			// OK. Easiest is just brute force the check
			if(h)
				if(inputF[count-1][curx-1]=='M' && inputF[count+1][curx+1]=='S')
					if (inputF[count-1][curx+1]=='M' && inputF[count+1][curx-1]=='S'); sum+=1;
						elseif (inputF[count-1][curx+1]=='S' && inputF[count+1][curx-1]=='M'); sum+=1; end
					elseif(inputF[count-1][curx-1]=='S' && inputF[count+1][curx+1]=='M')
						if (inputF[count-1][curx+1]=='M' && inputF[count+1][curx-1]=='S'); sum+=1;
							elseif (inputF[count-1][curx+1]=='S' && inputF[count+1][curx-1]=='M'); sum+=1; end
						end
					end
					s=s[count2+1:]
					count2=Str.Locate(s, 'A')
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
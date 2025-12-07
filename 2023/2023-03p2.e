/*
 * Part numbers. Multiply numbers when only two adjacent to a star.
 * Assoc action.
 *
 * 467..114..
 * ...*......
 * ..35..633.
 * ......#...
 * 617*......
 * .....+.58.
 * ..592.....
 * ......755.
 * ...$.*....
 * .664.598..
 * 0.02 s
 */
function String runme()
	List results = {}, oneLine = {}, grid = {}, inputF
	integer rnum = 1, rnum2 = 0, summer = 0, Starter=Date.Tick()
	String search
	inputF=Loaddata()
	for (rnum=1; rnum<=Length(inputF); rnum+=1)
		grid = { @grid, inputF[rnum] }
		oneLine = parseIt(inputF[rnum])
		if Length(oneLine) > 0
			results = { @results, { rnum, oneLine } }
		end
	end
	// Parsed all of the input. Now have a list: list[x][1] is the xth line of the number, and any elements in list[x][2] are the actual numbers list[x][2][y] list[x][2][y][1] start, [x][2][y][2] end, [x][2][y][3]
	oneLine = {}
	integer l, r
	List patter = {}
	Assoc aGears = Assoc.CreateAssoc()
	Assoc bGears = Assoc.CreateAssoc()
	string ts=''

	// ASSUME: Only one gear per number, and max two numbers per gear. Simple case.
	search = "*" // Looking for special characters.
	String totals = ''
	for (rnum=1; rnum<=Length(results); rnum+=1) // Iterate through the rows
		for (rnum2=1; rnum2<=Length(results[rnum][2]); rnum2+=1) // Iterate through the numbers on each row
			l = results[rnum][2][rnum2][1] // leftmost character
			if l>1; l-=1; end
			r = results[rnum][2][rnum2][2] // rightmost character
			if r < Length(grid[1]); r+=1; end // Assume grid is equal width through.
			if results[rnum][1] > 1
				// Get the line above if it exists
				patter = Pattern.Find( grid[ results[rnum][1]-1 ][l:r], search) 
				if IsDefined(patter)
					ts = Str.Format('%1-%2', results[rnum][1]-1, patter[1]+l)
					if Assoc.IsKey(aGears, ts)
						// There's already a key..
						totals = aGears.(ts)
						bGears.(ts)=Str.ValueToString(Str.StringToInteger(totals)*results[rnum][2][rnum2][3]) // Multiply other
					else
						aGears.(ts)=Str.ValueToString(results[rnum][2][rnum2][3])
					end
				end
			end
			patter = Pattern.Find( grid[ results[rnum][1] ][l:r], search ) 
			if IsDefined(patter)
				ts = Str.Format('%1-%2', results[rnum][1], patter[1]+l)
				if Assoc.IsKey(aGears, ts)
					totals = aGears.(ts)
					bGears.(ts)=Str.ValueToString(Str.StringToInteger(totals)*results[rnum][2][rnum2][3]) // Multiply other
				else
					aGears.(ts)=Str.ValueToString(results[rnum][2][rnum2][3])
				end
			end
			if results[rnum][1] < Length(grid)
				// Get the line below if it exists
				patter = Pattern.Find( grid[ results[rnum][1]+1 ][l:r], Pattern.CompileFind( search ) ) 
				if IsDefined(patter)
					ts = Str.Format('%1-%2', results[rnum][1]+1, patter[1]+l)
					if Assoc.IsKey(aGears, ts)
						totals = aGears.(ts)
						bGears.(ts)=Str.ValueToString(Str.StringToInteger(totals)*results[rnum][2][rnum2][3]) // Multiply other
					else
						aGears.(ts)=Str.ValueToString(results[rnum][2][rnum2][3])
					end
				end
			end
		end
	end
	for ts in Assoc.Items( bGears )
		summer += Str.StringToInteger(ts)
	end
	echo('Answer: '+Str.String(summer)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function List parseIt(String incoming)
	String  target = incoming
	String  search = "<[0-9]+>"
	String  s = target
	List    result = Pattern.Find( s, Pattern.CompileFind( search ) )
	List results = {}
	integer counter =0

	// Find the locations of the numbers along with the number itself.
	while ( IsDefined( result ) )
		results = { @results, {counter+result[1], counter + result[2], Str.StringToInteger(result[4]) } }
		counter += result[2]
		s = s[ result[ 2 ]+1 : ]
		result = Pattern.Find( s, Pattern.CompileFind( search ) )
	end
	return results
end

// Load the file.
function List loadData()
	List incoming
	String s
	File fr = File.open("C:\AdventOfCodeInputs\2023\3-input.txt", File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end

/*
 * Mirrored 2d plane
 *
 * #.##..##.
 * ..#.##.#.
 * ##......#
 * ##......#
 * ..#.##.#.
 * ..##..##.
 * #.#.##.#.
 *
 * #...##..#
 * #....#..#
 * ..##..###
 * #####.##.
 * #####.##.
 * ..##..###
 * #....#..#
 * 0.085 s
 */
function String runme()
	$globCache = Assoc.CreateAssoc()
	List inputF, mapList = {{}}, mapListR = {{}}
	integer count, count2=1, countr, sc=0, sum = 0, Starter=Date.Tick()
	List matPot ={}, matPotR={} // match potential...
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\13-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		if inputF[count]==''
			// New map. Reset.
			sc = 0
			count2 += 1
			mapList[count2] = {}
			mapListR[count2] = {}
		else
			mapList[count2] = { @mapList[count2], inputF[count] }
			for (countr=1; countr<=Length(inputF[count]); countr+=1)
				if IsDefined(mapListR[count2][countr])
					mapListR[count2][countr] = Str.String(inputF[count][countr]+mapListR[count2][countr])
				else
					mapListR[count2][countr] = inputF[count][countr]
				end
			end
			if (inputF[count] == inputF[count-1])
				matPot = {@matPot, {count2, sc}}
			end
			sc += 1
		end
	end
	// Data is loaded, now find the mirrors.
	for inputF in matPot
		sc = inputF[2]; count=1
		while (sc+count<=Length(mapList[inputF[1]]) && sc-count+1 >0)
			if mapList[inputF[1]][sc-count+1] == mapList[inputF[1]][sc+count]
			else
				matPot=List.SetRemove(matPot, inputF)
				break
			end
			count+=1
		end
	end
	// Now we check the remaining ones - the rotated ones.
	// Count2 is the number of maps.
	for (count=1; count<=count2; count+=1)
		for (sc=1; sc<Length(mapListR[count]); sc+=1)
			if (mapListR[count][sc] == mapListR[count][sc+1])
				matPotR = {@matPotR, {count, sc}}
			end
		end
	end
	// Data is loaded, now find the mirrors.
	for inputF in matPotR
		sc = inputF[2]; count=1
		while (sc+count<=Length(mapListR[inputF[1]]) && sc-count+1 >0)
			if mapListR[inputF[1]][sc-count+1] == mapListR[inputF[1]][sc+count]
			else
				matPotR=List.SetRemove(matPotR, inputF)
				break
			end
			count+=1
		end
	end
	// Add it up!
	sum=0
	for inputF in matPot
		sum+=(inputF[2]*100)
	end
	for inputF in matPotR
		sum+=inputF[2]
	end
	echo(Str.String(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
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

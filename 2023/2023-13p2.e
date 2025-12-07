/*
 * Mirrored 2d plane
 * Used normal and 90 degree rotated.
 * Turned each line into binary and did binary xor to see if one item differed.
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
 * 0.15 s
 */
function String runme()
	List inputF, mapList = {{}}, mapListR = {{}}
	List matNum = {}, matNumR = {} 
	$powTwo={} // binary
	integer count, count2=1, countr, sc=0, sum = 0, Starter=Date.Tick()
	List matPot ={}, matPotR={} // match potential...
	$mapNums = {1}
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\13-input.txt")
	for (count=0; count<=20; count+=1)
		$powTwo = { @$powTwo, Math.RoundSignificant(Math.Power(2, count),10)}
	end
	for (count=1; count<=Length(inputF); count+=1)
		if inputF[count]==''
			// New map. Reset.
			sc = 0
			count2 += 1
			mapList[count2] = {}
			mapListR[count2] = {}
			$mapNums = {@$mapNums, count2}
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
	// Data is loaded, let's rotate.
	// Count2 is the number of maps.
	for (count=1; count<=count2; count+=1)
		for (sc=1; sc<Length(mapListR[count]); sc+=1)
			if (mapListR[count][sc] == mapListR[count][sc+1])
				matPotR = {@matPotR, {count, sc}}
			end
		end
	end
	// Now get the numbers for each map.
	for (count=1; count<=count2; count+=1)
		matNum = {@matNum, parseInput(mapList[count])}
		matNumR = {@matNumR, parseInput(mapListR[count])}
	end
	// Do the calculations.
	// Start with where matche potentials exist. These lists already exist.
	// Need to match but also need exactly ONE flipped bit.
	// powTwo is the list of powers
	matPot = findMatch( matPot, matNum)
	matPotR = findMatch( matPotR, matNumR)
	// Add up this first bunch.
	sum=0
	for inputF in matPot
		sum+=(inputF[2]*100)
	end
	for inputF in matPotR
		sum+=inputF[2]
	end
	matPot = {}; matPotR = {}
	// OK - whatever is left in mapNums are ones where the middle matches need work.
	// mapList and mapListR.
	for count in $mapNums
		for (count2=1; count2 < Length(matNum[count]); count2+=1)
			if (matNum[count][count2]^matNum[count][count2+1]) in $powTwo
				matPot = {@matPot, {count, count2}}
			end
		end
		for (count2=1; count2 < Length(matNumR[count]); count2+=1)
			if (matNumR[count][count2]^matNumR[count][count2+1]) in $powTwo
				matPotR = {@matPotR, {count, count2}}
			end
		end
	end
	// OK - now check these as if they were before.
	matPot = findMatch( matPot, matNum)
	matPotR = findMatch( matPotR, matNumR)
	for inputF in matPot
		sum+=(inputF[2]*100)
	end
	for inputF in matPotR
		sum+=inputF[2]
	end
	echo("Total is: "+Str.String(sum)+' : '+Str.String($mapNums)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end

function List parseInput(List incoming)
	List eachrow = {} 
	String myst
	Integer count=0, sum=0
	for myst in incoming
		count=0; sum=0	
		while Length(myst)>0
			if(myst[Length(myst)]=='#')
				sum += Math.Power(2, count)
			end
			count+=1
			if Length(myst)>1; myst = myst[:-2]; else; myst=''; end
		end
		eachrow = { @eachrow, sum }
	end
	return eachrow
end

function List findMatch(List pots, List mappers)
	integer sc, count, countr
	list combo
	for combo in pots
		sc = combo[2]; count=1; countr = 0
		if combo[1] in $mapNums
			while (sc+count<=Length(mappers[combo[1]]) && sc-count+1 >0)
				if mappers[combo[1]][sc-count+1] == mappers[combo[1]][sc+count]
				elseif (mappers[combo[1]][sc-count+1]^mappers[combo[1]][sc+count]) in $powTwo
					// It's a binary shift.
					if countr == 1
						pots=List.SetRemove(pots, combo)
						break
					end
					countr=1
				else
					countr=0
					pots=List.SetRemove(pots, combo)
					break
				end
				count+=1
			end
			if countr == 0
				pots=List.SetRemove(pots, combo)
			else
				$mapNums=List.SetRemove($mapNums, combo[1])
			end
		else
			pots=List.SetRemove(pots, combo)
		end
	end
	return pots
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

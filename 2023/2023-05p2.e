/*
 * Seed map. One way - initial seeds, find lowest result
 * Multiple mapping exercise, use RANGES. Trillions of possibilities
 * seeds: 79 14 55 13
 *
 * seed-to-soil map:
 * 50 98 2
 * 52 50 48
 *
 * soil-to-fertilizer map:
 * 0 15 37
 * 37 52 2
 * 39 0 15
 *
 * fertilizer-to-water map:
 * 49 53 8
 * 0 11 42
 * 42 0 7
 * 57 7 4
 *
 * water-to-light map:
 * 88 18 7
 * 18 25 70
 *
 * light-to-temperature map:
 * 45 77 23
 * 81 45 19
 * 68 64 13
 *
 * temperature-to-humidity map:
 * 0 69 1
 * 1 0 69
 *
 * humidity-to-location map:
 * 60 56 37
 * 56 93 4
 * 0.04 s
 */
function String runme()
	List funcRet = {}
	integer count = 0, entCount=0, sCount=0
	integer lseed=-1, lcount=-1, Starter=Date.Tick()
	List seedList = {}, inputF, seedListI = {}
	List Mapper = {}
	List seedPath = {}
	integer dest, source, range, tgt, seednum
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\5-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		if inputF[count]==''
			//doing nothing.
		elseif count == 1
			// First run, it's the seeds.
			seedList = Str.Elements(inputF[count][8:], ' ')
			for (sCount=1; sCount<=Length(seedList); sCount+=2)
				seedListI = { @seedListI, {Str.StringToInteger(seedList[sCount]), Str.StringToInteger(seedList[sCount])+Str.StringToInteger(seedList[sCount+1])-1 } }
			end
		elseif inputF[count][-1]==':'
			// It's a new map list.
			entCount+=1
			Mapper[entCount] = {}
		else
			// Given [1] is the dest, [2] is the source, [3] is the range from [2], therefore: [2] is startnum, [2]+[3]-1 is the endnum, [1]-[2] is the offset
			dest=Str.StringToInteger(Str.Elements(inputF[count], ' ')[1])
			source=Str.StringToInteger(Str.Elements(inputF[count], ' ')[2])
			range=Str.StringToInteger(Str.Elements(inputF[count], ' ')[3])
			Mapper[entCount] = { @Mapper[entCount], { source, source+range-1, dest-source } } // Loading the mappings.
		end
	end
	// Data is loaded. Now..... go through the map! Initial ranges will get split into subsequent ranges. Iterate.
	List curMap={} // Keeps it simple.
	String evo = ""
	for (count=1; count<=Length(Mapper); count+=1)
		entCount=1 // Now take each seed and check it through the list of maps.
		while entCount <= Length(seedListI)
			for (sCount=1; sCount<=Length(Mapper[count]); sCount+=1)
				curMap = Mapper[count][sCount] // Keep it simple. curMap is the start, end, offset.
				if curMap[1] <= seedListI[entCount][1] && curMap[2] >= seedListI[entCount][2]
					// Entire mapping encompasses the seed range. Remap and break.
					seedListI[entCount] = { seedListI[entCount][1]+curMap[3], seedListI[entCount][2]+curMap[3] }
					break;
				elseif curMap[1] <= seedListI[entCount][1] && curMap[2] >= seedListI[entCount][1] &&curMap[2] <= seedListI[entCount][2]
					// Target starts lower seed range, but ends before higher seed range. Split the first off, continue the run with the second. No break.
					seedListI = { @seedListI, { curMap[2]+1, seedListI[entCount][2] } }
					seedListI[entCount] = { seedListI[entCount][1]+curMap[3], curMap[2]+curMap[3] }
					break;
				elseif curMap[1] >= seedListI[entCount][1] && curMap[1] <= seedListI[entCount][2] && curMap[2] >= seedListI[entCount][2]
					// Target starts above seed range, and ends higher than seed range. Split the first off, map the second, then break.
					seedListI = { @seedListI, { seedListI[entCount][1], curMap[1]-1 } }
					seedListI[entCount] = { curMap[1]+curMap[3], seedListI[entCount][2]+curMap[3] }
					break;
				elseif curMap[1] >= seedListI[entCount][1] && curMap[2] <= seedListI[entCount][2]
					// Target starts above lower seed range, but ends before higher seed range. Split into three, continue the run with the third. No break.
					seedListI = { @seedListI, { seedListI[entCount][1], curMap[1]-1 }, { curMap[2]+1, seedListI[entCount][2] } }
					seedListI[entCount] = { curMap[1]+curMap[3], curMap[2]+curMap[3] }
					break;
				end
				// Starts higher or ends lower than the current seed, so this range is unchanged.
			end
			entCount += 1
		end
	end
	// Take the lowest!
	echo('Answer: '+Str.String(List.Sort(seedListI)[1][1])+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
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

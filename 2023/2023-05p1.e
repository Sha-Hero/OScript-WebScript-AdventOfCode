/*
 * Seed map. One way - initial seeds, find lowest result
 * Multiple mapping exercise
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
 * 0.01 s
 */
function String runme()
	List funcRet = {}
	integer count = 0, entCount=0, sCount=0
	integer lseed=-1, lcount=-1, Starter=Date.Tick()
	List seedList = {}, inputF
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
		elseif inputF[count][-1]==':'
			// It's a new map list.
			entCount+=1
			Mapper[entCount] = {}
		else
			// It's a list of data. Dest range, src range, offest.
			// Given [1] is the dest, [2] is the source, [3] is the range from [2], therefore: [2] is startnum, [2]+[3]-1 is the endnum, [1]-[2] is the offset
			dest=Str.StringToInteger(Str.Elements(inputF[count], ' ')[1]); source=Str.StringToInteger(Str.Elements(inputF[count], ' ')[2]); range=Str.StringToInteger(Str.Elements(inputF[count], ' ')[3])
			Mapper[entCount] = { @Mapper[entCount], { source, source+range-1, dest-source } }
		end
	end
	// funcRest will hold the sorted lists for each stage [x] is the stage number, [x][y] are the lists of mappings
	for (count=1; count<=Length(Mapper); count+=1)
		funcRet[count]=List.Sort(Mapper[count])
	end
	// Data is loaded. Now..... go through the map!
	// for each entry in seedlist, go until number is either in a range (in which case we offest), or if source is too high then no offset.
	for (seedNum=1; seedNum<=Length(seedList); seedNum+=1)
		tgt = Str.StringToInteger(seedList[seedNum])
		if seedNum==1; lseed=tgt; end
		seedPath[seedNum] = {}
		for (count=1; count<=Length(funcRet)+1; count+=1)
			seedPath[seedNum] = { @seedPath[seedNum], tgt }
			for (sCount=1; sCount<=Length(funcRet[count]); sCount+=1)
				if funcRet[count][sCount][1] > tgt
					// Stop here.
					break;
				elseif funcRet[count][sCount][2] >= tgt
					// We know startnum is <= seed. If endnum >= then in range, and we add the offset.
					tgt = tgt+funcRet[count][sCount][3]
					break;
				else
					// If we're here, it's because  we need to keep iterating. Don't need to do anything.
				end
			end
		end
		if lcount==-1
			lcount=tgt
		elseif tgt <= lcount
			lcount=tgt
			lseed=Str.StringToInteger(seedList[seedNum])
		end
	end
	string noutput = Str.Format('Low seed = %1 with count = %2<BR>', lseed, lcount)
	// Let it iterate through all the permutations.
	for (count=1; count<=Length(seedPath); count+=1)
		noutput = noutput+'Seed #'+Str.String(count)+': '+Str.String(seedPath[count])+'<BR>'
	end
	echo('Answer: '+Str.String(lcount)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
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
/*
 * 2d map - send all pieces to the "end"
 *
 * O....#....
 * O.OO#....#
 * .....##...
 * OO.#O....O
 * .O.....O#.
 * O.#..O.#.#
 * ..O..#O..O
 * .......O..
 * #....###..
 * #OO..#....
 * 0.056 s
 */
function String runme()
	List inputF, octos, mapListR={}, mapListR2={}
	integer count, countr, sum = 0, Starter=Date.Tick(), cft
	String oneLine, spo, oval, fullst
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\14-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		// Let's rotate the map to make it easier.
		for (countr=1; countr<=Length(inputF[count]); countr+=1)
			if IsDefined(mapListR[countr])
				mapListR[countr] = Str.String(inputF[count][countr]+mapListR[countr])
			else
				mapListR[countr] = inputF[count][countr]
			end
		end
	end
	// Got me a rotated map! Let's tilt it!
	sum=0
	for oneLine in mapListR
		fullst=''
		octos = Str.Elements(oneLine, '#')
		for spo in octos
			// length spo is final length.
			// length Str.Elements is number O
			oval = Str.Join(Str.Elements(spo, 'O'))
			fullst += oval
			for (cft=1; cft<=(Length(spo)-Length(oval)); cft+=1)
				fullst += 'O'
				sum+=Length(fullst)
			end
			fullst += '#'
		end
		fullst = fullst[:-2]
		mapListR2 = { @mapListR2, fullst}
	end
	echo('Sum is: '+Str.String(sum)+' ..  timing: '+Str.String(Date.Tick()-starter)+' ticks.')
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

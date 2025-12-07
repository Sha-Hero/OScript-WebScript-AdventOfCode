/*
 * 2d map - send all pieces to the "end"
 * Global cache, iterate through, find the loop - and the length of the loop
 * and the initial steps it took to get there.
 * Check the values of the loop variables (count, foundit, etc.)
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
 * 39 seconds
 */
function String runme()
	List inputF, octos, input2
	integer count, countr=0, sum = 0, Starter=Date.Tick(), cft=0, foundit=0
	String oneLine, spo, oval, fullst, fcache
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\14-input.txt")
	Assoc globCache = Assoc.CreateAssoc()
	for (count=1; count<=1000000000; count+=1)
		if IsDefined(globCache.(Str.String(inputF)))
			// OK, found a cache, now loop.
			fcache=Str.String(inputF)
			echo("First cache at: "+Str.String(count-1)+' with: '+fcache)
			while count <=1000000000 // one cycle.
				inputF = globCache.(Str.String(inputF))
				foundit+=1
				if countr==0 && fcache == Str.String(inputF)
					//			echo("Circled at: "+Str.String(foundit))
					count = (1000000000-count)-((1000000000-count)%foundit)+count
					countr= 1
				end
				count += 1
			end
			break;
		end
		input2 = inputF
		for (cft=1; cft<=4; cft+=1) // one cycle.
			inputF = rotator(inputF)
		end
		if count != 1; globCache.(Str.String(input2)) = inputF; end;
	end
	sum=0
	for (count=1; count<=Length(inputF); count+=1)
		cft = Length(inputF[count])-Length(Str.ReplaceAll(inputF[count], 'O','')) // number of o's.
		sum+= cft*(Length(inputF)-count+1)
	end
	echo('Sum is: '+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function List rotatorb(List incoming)
	// Rotate it backwards
	integer count, countr, cft, cyc
	List outputter, octos, outputter2={}
	String oneLine, fullst, spo, oval
	for (count=1; count<=Length(incoming); count+=1)
		// Let's rotate the map to make it easier.
		for (countr=1; countr<=Length(incoming[count]); countr+=1)
			if IsDefined(outputter[countr])
				outputter[countr] = Str.String(incoming[count][countr]+outputter[countr])
			else
				outputter[countr] = incoming[count][countr]
			end
		end
	end
	return outputter
end
function List rotator(List incoming)
	integer count, countr, cft, cyc
	List outputter, octos, outputter2={}
	String oneLine, fullst, spo, oval
	for (count=1; count<=Length(incoming); count+=1)
		// Let's rotate the map to make it easier.
		for (countr=1; countr<=Length(incoming[count]); countr+=1)
			if IsDefined(outputter[countr])
				outputter[countr] = Str.String(incoming[count][countr]+outputter[countr])
			else
				outputter[countr] = incoming[count][countr]
			end
		end
	end
	// Got me a rotated map! Let's tilt it!
	for oneLine in outputter
		fullst=''
		octos = Str.Elements(oneLine, '#')
		for spo in octos
			// length spo is final length.
			// length Str.Elements is number O
			oval = Str.Join(Str.Elements(spo, 'O'))
			fullst += oval
			for (cft=1; cft<=(Length(spo)-Length(oval)); cft+=1)
				fullst += 'O'
			end
			fullst += '#'
		end
		fullst = fullst[:-2]
		outputter2 = { @outputter2, fullst}
	end
	return outputter2
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

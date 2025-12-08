/*
 * Enclosed pit size
 * Finding max enclosed. Shoelace formula. Co-ordinates
 * R 6 (#70c710)
 * D 5 (#0dc571)
 * L 2 (#5713f0)
 * D 2 (#d2c081)
 * R 2 (#59c680)
 * D 2 (#411b91)
 * L 5 (#8ceee2)
 * U 2 (#caa173)
 * L 1 (#1b58a2)
 * U 2 (#caa171)
 * R 2 (#7807d2)
 * U 3 (#a77fa3)
 * L 2 (#015232)
 * U 2 (#7a21e3)
 * 0.014 s to complete
 */
function String runme()
	// Need to know the co-ordinates and can find the area.
	// Because we're dealing with "blocks" instead of just points on a grid
	//  we need to add #blocks in outline / 2, +1 for the four corners.
	//  Trust me, I figured it out earlier.
	// Part two - same as part 1 but different parsing.
	Integer Starter=Date.Tick() // Start Tick
	List inputF, coords = {{0,0}}, coord = {}
	Integer count, cx=0, cy=0, cnt2, perim=0
	String d // direction
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\18-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		d = inputF[count][-2:-2]
		cnt2 = HexToDec(inputF[count][-7:-3])
		perim += cnt2
		if (d == '3') // up
			cy-=cnt2
		elseif (d == '1') // down
			cy+=cnt2
		elseif (d == '2') // left
			cx-=cnt2
		else
			cx+=cnt2
		end
		coords = { @coords, { cx, cy }}
	end
	// OK. Got us some coords. Let's shoelace it!
	cnt2 = 0
	for (count=1; count < Length(coords); count += 1)
		cnt2 += coords[count][1]*coords[count+1][2]
		cnt2 -= coords[count+1][1]*coords[count][2]
	end
	// last one.
	cnt2 += coords[count][1]*coords[1][2]
	cnt2 -= coords[1][1]*coords[count][2]
	count = (cnt2/2) + (perim/2) + 1
	echo ("Total area is: "+Str.String(count)+" Timing: "+Str.String(Date.Tick()-Starter)+" ticks.")
	return "Done"
end

function Integer HexToDec(String inhex)
	Integer curnum=0, count, cnt2=0
	for (count=Length(inhex); count>0; count -=1)
		if IsDefined(Str.StringToInteger(inhex[count]))
			// It's a numeral
			curnum += Str.StringToInteger(inhex[count])*Math.Power(16, cnt2) 
		elseif inhex[count] == 'a'
			curnum += 10*Math.Power(16, cnt2) 
		elseif inhex[count] == 'b'
			curnum += 11*Math.Power(16, cnt2) 
		elseif inhex[count] == 'c'
			curnum += 12*Math.Power(16, cnt2) 
		elseif inhex[count] == 'd'
			curnum += 13*Math.Power(16, cnt2) 
		elseif inhex[count] == 'e'
			curnum += 14*Math.Power(16, cnt2) 
		else
			curnum += 15*Math.Power(16, cnt2) 
		end
		cnt2 += 1
	end
	return curnum
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

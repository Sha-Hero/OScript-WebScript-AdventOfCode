/*
 * Split based on rules
 * 0 1 10 99 999
 *  seconds
If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.
If the stone is engraved with a number that has an even number of digits, it is replaced by two stones. The left half of the digits are engraved on the new left stone, and the right half of the digits are engraved on the new right stone. (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
If none of the other rules apply, the stone is replaced by a new stone; the old stone's number multiplied by 2024 is engraved on the new stone.
 *  0.08 sec p1, 1.8 sec p2
 */
function String runme()
	List inputF, nums
	integer count=0, count2=0, Starter=Date.Tick(), sum=0
	$mem = Assoc.CreateAssoc()

	integer depth = 25 // PART 1=25, PART 2=75

	String entry, curkeys, key
	// Input is small, but we're not supposed to share it.
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-11-input.txt")
	for entry in Str.Elements(inputF[1], ' ')
		// Iterate each number one at a time.
		sum+=checker(Str.StringToInteger(entry), depth)
	end
	echo("Answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function Integer checker( Integer val, Integer depth=1)
	String memkey=Str.Format("%1-%2",val, depth), vs = Str.ValueToString(val)
	List ret, tmp
	Integer entry, tsum=0
	if IsDefined($mem.(memkey))
		return $mem.(memkey)
	end
	if depth == 1
		if val==0 || Length(vs)%2!=0
			$mem.(memkey) = 1
			return 1
		else
			$mem.(memkey) = 2
			return 2
		end
	end
	// OK, recurse.
	if(val == 0)
		$mem.(memkey) = checker(1, depth-1)
	elseif(Length(vs)%2==0)
		$mem.(memkey) = checker(Str.StringToInteger(vs[:Length(vs)/2]), depth-1) + \
			checker(Str.StringToInteger(vs[(Length(vs)/2)+1:]), depth-1)
	else
		$mem.(memkey) = checker( val*2024, depth-1 )
	end
	return $mem.(memkey)
end
// Load the file.
function List loadData(String path)
	List incoming, biglist
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
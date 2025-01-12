/*
 * Find books with pages NOT OK. Reorder to be OK and return sum of middle item.
 * 47|53
 * 97|13
 * 97|61
 * 97|47
 * <etc>
 *
 * 75,47,61,53,29
 * 97,61,53,29,13
 * 75,29,13
 * 75,97,47,61,53
 * 0.06 seconds
 */
function String runme()
	List inputF
	integer count=0, count2, Starter=Date.Tick(), sum=0
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-05-input.txt")
	// Getting a split list.
	List rules=inputF[1],books=inputF[2], entry, book
	Assoc ra = Assoc.CreateAssoc()
	Boolean ok = true
	String tmp
	for entry in rules
		ra.(entry[1]) = true
	end
	for book in books
		ok = true
		for (count=1; count<Length(book); count+=1)
			for (count2=count+1; count2<=Length(book); count2+=1)
				if IsDefined(ra.(book[count2]+"|"+book[count]))
					// swap 'em
					tmp = book[count2]
					book[count2] = book[count]
					book[count] = tmp
					ok = false
				end
			end
		end
		if !ok
			sum += Str.StringToInteger(book[(Length(book)+1)/2])
		end
	end
	echo("Part 2 answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

// Load the file.
function List loadData(String path)
	List incoming, biglist
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65534); s!=File.E_Eof; s=File.Read(fr, 65534))
			if s==''
				biglist = {{@incoming}}
				incoming = {}
			else
				incoming = { @incoming, Str.Elements(s, ',') }
			end
		end
		File.Close(fr)
	end
	biglist = {@biglist,{@incoming}}
	return biglist
end
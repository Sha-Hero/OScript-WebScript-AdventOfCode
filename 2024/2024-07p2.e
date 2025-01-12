/*
 * Find combinations that work with + and *
 * 190: 10 19
 * 3267: 81 40 27
 * 83: 17 5
 * 156: 15 6
 * 7290: 6 8 6 15
 * 161011: 16 10 13
 * 192: 17 8 14
 * 21037: 9 7 18 13
 * 292: 11 6 16 20
 * 40 seconds --> 0.083 seconds - going from back to front.
 */
function String runme()
	List inputF, nums
	integer count=0, count2, Starter=Date.Tick(), sum=0, total
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-07-input.txt")
	for(count=1; count<=Length(inputF); count+=1)
		total=Str.StringToInteger(inputF[count][:Str.Locate(inputF[count],':')-1])
		nums = Str.Elements(inputF[count], ' ')[2:]
		for(count2=1; count2<=Length(nums); count2+=1)
			nums[count2] = Str.StringToInteger(nums[count2])
		end
		if(poss(total, nums)); sum+=total; end
	end
	echo("Answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function Boolean poss(integer tot, List elms)
	if(Length(elms)==2)
		if tot==elms[1]+elms[2] || tot==elms[1]*elms[2] || tot==Str.StringToInteger(Str.Format("%1%2",elms[1], elms[2]))
			return true
		else
			return false
		end
	end
	String tstr=Str.ValuetoString(tot), estr=Str.ValueToString(elms[-1])
	if(tot%elms[-1]!=0)
		if(tot<elms[-1])
			return false
		elseif tstr[-Length(estr):]==estr
			return poss(tot-elms[-1], elms[:-2]) || poss(Str.StringToInteger(tstr[:-Length(estr)-1]), elms[:-2])
		else
			return poss(tot-elms[-1], elms[:-2])
		end
	else
		if tstr[-Length(estr):]==estr
			return poss(tot/elms[-1], elms[:-2]) || poss(tot-elms[-1], elms[:-2]) || poss(Str.StringToInteger(tstr[:-Length(estr)-1]), elms[:-2])
		else
			return poss(tot/elms[-1], elms[:-2]) || poss(tot-elms[-1], elms[:-2])
		end
	end
	return false
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
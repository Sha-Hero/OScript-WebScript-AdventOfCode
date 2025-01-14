/*
 * Crossed wires. Inputs and decimal result. Four swapped pairs.
 * Output will be ANDs of xNN and yNN
 * Full adder.
 * Taken from https://www.reddit.com/r/adventofcode/comments/1hl698z/comment/m3kt1je/
x00: 1
x01: 1
x02: 1
y00: 0
y01: 1
y02: 0

x00 AND y00 -> z00
x01 XOR y01 -> z01
x02 OR y02 -> z02
// 0.8 seconds
 */
function String runme()
	List inputF, zeds={}, wrongs={}
	String zed, op, op1, op2, res, subop, subop1, subop2, subres
	integer Starter=Date.Tick(), count, sum=0
	//	$$a=Assoc.CreateAssoc() // Assoc with registers as keys <-- don't need!
	$$c=Assoc.CreateAssoc() // To hold the commands with their pre-reqs.
	Boolean found=false
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-24-input.txt")
	for(count=1; count<=Length(inputF); count+=1)
		if(!found && Length(inputF[count])==0)
			found=true
		else
			if(found)
				$$c.(Str.Elements(inputF[count],' ')[5])={Str.Elements(inputF[count],' ')[1], \
														   Str.Elements(inputF[count],' ')[3], Str.Elements(inputF[count],' ')[2]}
				if Str.Elements(inputF[count],' ')[5][1]=='z'
					zeds+={Str.Elements(inputF[count],' ')[5]}
				end
				//			else
				//				$$a.(Str.Elements(inputF[count],':')[1])=Str.StringToInteger(Str.Elements(inputF[count],' ')[2])
			end
		end
	end
	zeds = List.Sort(zeds, List.Descending)
	zed=zeds[1]
	for res in Assoc.Keys($$c)
		op1=$$c.(res)[1]
		op2=$$c.(res)[2]
		op=$$c.(res)[3]
		if res[1] == "z" && op != "XOR" && res != zed
			wrongs = List.SetAdd(wrongs, res)
		elseif op == "XOR" && !(res[1] in {"x", "y", "z"}) && \
				!(op1[1] in {"x", "y", "z"}) && !(op2[1] in {"x", "y", "z"})
			wrongs = List.SetAdd(wrongs, res)
		elseif op == "AND" && !("x00" in {op1, op2})
			for subres in Assoc.Keys($$c)
				subop1=$$c.(subres)[1]
				subop2=$$c.(subres)[2]
				subop=$$c.(subres)[3]
				if (res == subop1 || res == subop2) && subop != "OR"
					wrongs = List.SetAdd(wrongs, res)
				end
			end
		elseif op == "XOR"
			for subres in Assoc.Keys($$c)
				subop1=$$c.(subres)[1]
				subop2=$$c.(subres)[2]
				subop=$$c.(subres)[3]
				if (res == subop1 || res == subop2) && subop == "OR"
					wrongs = List.SetAdd(wrongs, res)
				end
			end
		end
	end
	echo ( "Wrong ones are: ", wrongs)
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
end
// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65535); s!=File.E_Eof; s=File.Read(fr, 65535))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end

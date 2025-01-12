/*
 * Crossed wires. Inputs and decimal result
x00: 1
x01: 1
x02: 1
y00: 0
y01: 1
y02: 0

x00 AND y00 -> z00
x01 XOR y01 -> z01
x02 OR y02 -> z02
// 0.007 seconds
 */
function String runme()
	List inputF, zeds={}
	String zed
	String retval=''
	integer Starter=Date.Tick(), count, sum=0
	$$a=Assoc.CreateAssoc() // Assoc with registers as keys
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
			else
				$$a.(Str.Elements(inputF[count],':')[1])=Str.StringToInteger(Str.Elements(inputF[count],' ')[2])
			end
		end
	end
	// OK, iterate through the cmds and get the order
	zeds = List.Sort(zeds)
	for zed in zeds
		retval+= Str.ValueToString(findit(zed)) // Build it backwards!
	end
	for(count=1; count<=Length(retval); count+=1)
		sum+=Str.StringToInteger(retval[count])*Math.Power(2, count-1)
	end
	echo ( "Sum is: ", sum)
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
end
function integer findit(String key)
	if !$$a.(key)
		$$a.(key)=calcit($$c.(key))
	end
	return $$a.(key)
end
function integer calcit(List reqs)
	String keya=reqs[1], keyb=reqs[2], op=reqs[3]
	if IsUndefined($$a.(keya))
		$$a.(keya)=calcit($$c.(keya))
	end
	if IsUndefined($$a.(keyb))
		$$a.(keyb)=calcit($$c.(keyb))
	end
	if op=='OR'
		return ($$a.(keya)==1 || $$a.(keyb)==1)?1:0
	elseif op=='AND'
		return ($$a.(keya)==1 && $$a.(keyb)==1)?1:0
	elseif op=='XOR'
		return ($$a.(keya)!=$$a.(keyb))?1:0
	end
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

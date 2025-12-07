/*
 * ASCII code with modulus
 * Simple Assoc with lists.
 * rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
 * 0.2 s
 */
function String runme()
	List inputF, oneline = {}, boxes = List.Allocate(256)
	integer count, sum = 0, Starter=Date.Tick(), boxnum, c2
	String entry
	Assoc tracker = Assoc.CreateAssoc()
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\15-input.txt")
	// This one just has one line.
	for (count=1; count<=Length(boxes); count+=1)
		boxes[count] = {}
	end
	oneline = Str.Elements(inputF[1], ',')
	for entry in oneline
		if entry[Length(entry)]=='-'
			// Minus
			boxnum = parseInput(entry[:-2])+1
			boxes[boxnum] = List.SetRemove(boxes[boxnum], entry[:-2])
		else
			// Equals
			boxnum = parseInput(entry[:-3])+1
			boxes[boxnum] = List.SetAdd(boxes[boxnum], entry[:-3])
			tracker.(entry[:-3]) = entry[Length(entry)]
		end
	end
	c2=1
	for (count=1; count<=Length(boxes); count+=1)
		c2=1
		for entry in boxes[count]
			sum+= count*c2*Str.StringToInteger(tracker.(entry))
			c2 += 1
		end
	end
	// Let's compute!
	// echo(Str.String(boxes))
	// echo(Str.String(tracker))
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end

function Integer parseInput(String incoming)
	integer cur=0, count
	for (count=1; count<=Length(incoming); count+=1)
		cur += Str.Ascii(incoming[count])
		cur = (cur*17)%256
	end
	return cur
end
// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65534); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end

/*
 * ASCII code with modulus
 *
 * rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
 * 0.18 s
 */
function String runme()
	List inputF, oneline = {}, results = {}
	integer count, sum = 0, Starter=Date.Tick()
	String entry
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\15-input.txt")
	// This one just has one line.
	oneline = Str.Elements(inputF[1], ',')
	for entry in oneline
		sum += parseInput(entry)
	end
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

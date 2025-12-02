/*
 * Up and down. ( = up, )= = down. Final floor?
(()())()))(((((()))(()
// 0.007 seconds
 */
function String runme()
	List inputF
	integer Starter=Date.Tick()
	integer l1=0, l2=0, l3=0, endF
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2015\01-input.txt")
	l1=Length(inputF[1])
	l2=Length(Str.ReplaceAll(inputF[1], '(', '')) // Getting all downs
	l3=Length(Str.ReplaceAll(inputF[1], ')', '')) // Getting all ups
	endF=l3-l2
	
	echo(Str.ValueToString(endF)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
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

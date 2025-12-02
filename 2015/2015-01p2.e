/*
 * Up and down. ( = up, )= = down. When first -1?
(()())()))(((((()))(()
// 0.126 seconds
 */
function String runme()
	List inputF
	integer count, Starter=Date.Tick()
	integer curFloor=0
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2015\01-input.txt")
	for (count=1;count<=Length(inputF[1]); count+=1)
		if(inputF[1][count]=='(')
			curFloor+=1
		else
			curFloor-=1
		end
		if(curFloor==-1)
			break
		end
	end
	echo(Str.ValueToString(count)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
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

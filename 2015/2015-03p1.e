/*
 * Present delivery. Directions. Count how many houses get presents.
v>v<vvv<<vv^v<v>v
// 0.435 seconds
 */
function String runme()
	List inputF
	integer count, Starter=Date.Tick(), x=0, y=0
	Assoc hGrid=Assoc.CreateAssoc() // 2d assoc of houses.
	String dir, loc
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2015\03-input.txt")
	hGrid.'0:0' = 1
	for (count=1;count<=Length(inputF[1]); count+=1)
		dir=inputF[1][count]
		if(dir=='^')
			y+=1
		elseif(dir=='v')
			y-=1
		elseif(dir=='<')
			x-=1
		elseif(dir=='>')
			x+=1
		else
			echo("Bad char")
			break;
		end
		loc=Str.String(x)+':'+Str.String(y)
		if(!isDefined(hGrid.(loc)))
			hGrid.(loc)=1
		end
	end
	echo("Houses: "+Str.ValueToString(Length(hGrid))+" : "+Str.String(Date.Tick()-Starter)+" ticks")
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

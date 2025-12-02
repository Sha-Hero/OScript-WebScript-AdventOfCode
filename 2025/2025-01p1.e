/*
 * Combo lock - how many stop at zero
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
// 0.019 seconds
 */
function String runme()
	List inputF
	integer count, Starter=Date.Tick()
	integer curNum=50, numZs=0
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\01-input.txt")
    for(count=1;count<=Length(inputF);count+=1)
        if(inputF[count][1]=='L')
            curNum-=Str.StringToInteger(inputF[count][2:])
        else
            curNum+=Str.StringToInteger(inputF[count][2:])
        end
        if(curNum%100==0)
        	// We only care about when it equals zero.
            numZs+=1
        end
    end
	echo(Str.ValueToString(numZs)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
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

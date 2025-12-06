/*
 * Math - columns with function at bottom
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   + 
// 0.29 seconds
 */
function String runme()
    List inputF, fList, tList
	integer Starter=Date.Tick()
    Integer count, count2, sum=0, tCnt=0
	Assoc curSums
	Boolean first=true
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\06-input.txt")
	fList=Str.Elements(Str.Compress(Str.Trim(inputF[-1])), ' ')
    for(count=1;count<Length(inputF);count+=1)
    	tlist=Str.Elements(Str.Compress(Str.Trim(inputF[count])), ' ')
    	if(first)
    		for(count2=1;count2<=Length(tList);count2+=1)
    			curSums.(count2)=Str.StringToInteger(tList[count2])
    		end
    		first=false
    	else
    		for(count2=1;count2<=Length(tList);count2+=1)
    			if(fList[count2]=='+')
	    			curSums.(count2)+=Str.StringToInteger(tList[count2])
    			else
    				curSums.(count2)*=Str.StringToInteger(tList[count2])
    			end
    		end
    	end
	end
	for(count2=1;count2<=Length(tList);count2+=1)
		sum+=curSums.(count2)
	end
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
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

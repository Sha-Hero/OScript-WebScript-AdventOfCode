/*
 * Math - columns with function at bottom - read top-down
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
// 0.28 seconds
 */
function String runme()
    List inputF, fList, tList
	integer Starter=Date.Tick()
    Integer count, count2, sum=0, tCnt=0
	String curOp, curNum, curChar
	Assoc curSums
	Boolean first=false, blanko=false // to skip blanks...
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\06-input.txt")
    for(count=1;count<=Length(inputF[1]);count+=1)
    	if(inputF[-1][count]!=' ')
    		curOp=inputF[-1][count]
    		first=true
	 		sum+=tCnt
    	else
    		first=false
    	end
    	curNum=''
   		for(count2=1;count2<Length(inputF);count2+=1)
	   		curNum=curNum+inputF[count2][count]
    	end
    	curNum=Str.Trim(curNum)
    	if(Length(curNum)!=0)
	   		if(first)
		    	tCnt=Str.StringtoInteger(curNum)
	   		elseif(curOp=='+')
		    	tCnt+=Str.StringtoInteger(curNum)
			else
		    	tCnt*=Str.StringtoInteger(curNum)
	 		end
 		end
	end
	sum+=tCnt
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

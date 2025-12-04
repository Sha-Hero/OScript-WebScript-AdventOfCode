/*
 * Finding max 12-digit in a list of numbers.
987654321111111
811111111111119
234234234234278
818181911112111
* //  0.08 seconds
 */
function String runme()
    List inputF, ress
    String curMax, curSub // single digits so leave as string!
	integer Starter=Date.Tick()
    Integer count, count2, sum
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\03-input.txt")
    for(count=1;count<=Length(inputF);count+=1)
        curMax=inputF[count][-12:]
        curSub=inputF[count][:-13]
        for(count2=1;count2<=12;count2+=1)
            ress=findMax(curSub, curMax[count2])
            if(ress[1]>0)
                curSub+=curMax[count2]
                curMax[count2]=ress[2]
                curSub=curSub[ress[1]+1:]
            else
                // Didn't find a bigger one. Can stop.
                break
            end
        end
        sum+=Str.StringToInteger(curMax)
    end
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end
function List findMax(String inStr, String curMax)
    integer pos=-1, cnt
    for(cnt=Length(inStr);cnt>=1;cnt-=1)
        if(inStr[cnt]>=curMax)
            pos=cnt
            curMax=inStr[cnt]
        end
    end
    return {pos, curMax}
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

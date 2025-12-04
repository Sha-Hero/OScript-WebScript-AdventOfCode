/*
 * Finding max 2-digit in a list of numbers.
987654321111111
811111111111119
234234234234278
818181911112111
* //  0.06 seconds
 */
function String runme()
    List inputF
    String max1='0', max2='0' // single digits so leave as string!
	integer Starter=Date.Tick()
    Integer count, count2, sum
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\03-input.txt")
    for(count=1;count<=Length(inputF);count+=1)
        for(count2=1;count2<Length(inputF[count]);count2+=1)
            if(inputF[count][count2]>max1)
                max1=inputF[count][count2]
                max2=inputF[count][count2+1]
            elseif(inputF[count][count2]>max2)
                max2=inputF[count][count2]
            end
        end
        if(inputF[count][-1]>max2)
            max2=inputF[count][-1]
        end
        sum+=Str.StringToInteger(max1+max2)
        max1='0';max2='0'
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

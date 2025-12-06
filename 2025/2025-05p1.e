/*
 * Numbers in ranges
3-5
10-14
16-20
12-18

1
5
8
11
17
32
// 0.144 seconds
 */
function String runme()
	List inputF, tList, fRange={}
	integer Starter=Date.Tick()
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\05-input.txt")
	Integer count, count2, sum=0, entry
	List ress
	for(count=1;count<=Length(inputF[1]);count+=1)
		// Get the ranges.
		tList=Str.Elements(inputF[1][count],"-")
		tList[1]=Str.StringToInteger(tList[1])
		tList[2]=Str.StringToInteger(tList[2])
		fRange={ @fRange, tList }
	end
	fRange=List.Sort(fRange)
	// Can probably collapse the ranges. Will wait for now.
	for(count=1;count<=Length(inputF[2]);count+=1)
		entry=Str.StringToInteger(inputF[2][count])
		for(count2=1;count2<=Length(fRange);count2+=1)
			if(fRange[count2][1]>entry)
				break
			elseif(fRange[count2][1]<entry&&fRange[count2][2]>=entry)
				sum+=1
				break
			else
				continue
			end
		end
	end 
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end
// Load the file - MOD - split return
function List loadData(String path)
	List incoming1={}, incoming2={}
	String s
	Integer inpart=1
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65535); s!=File.E_Eof; s=File.Read(fr, 65535))
			if(Length(s)==0)
				inpart=2
				continue
			end
			if(inpart==1)
				incoming1 = { @incoming1, s}
			else
				incoming2 = { @incoming2, s}
			end
		end
		File.Close(fr)
	end
	return { incoming1, incoming2 }
end

/*
 * Secrets - number manipulation
1
10
100
2024
// 5.4 seconds
 */
function String runme()
	List inputF
	integer Starter=Date.Tick(), ca, cb, num, ta, tb, tc, sum=0
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-22-input.txt")
	for(ca=1; ca<=Length(inputF); ca+=1)
		num=Str.StringToInteger(inputF[ca])
		for (cb=1; cb<=2000; cb+=1)
			ta=((num*64)^num)%16777216
			tb=((ta/32)^ta)%16777216
			tc=((tb*2048)^tb)%16777216
			num=tc
		end
		sum+=num
	end
	echo("Sum is: ", sum)
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
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

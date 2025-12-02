/*
 * Valid single-repeat number in range.
11-22,95-115,998-1012,1188511880-1188511890,
* 222220-222224,1698522-1698528,446443-446449,
* 38593856-38593862,565653-565659,824824821-824824827,
* 2121212118-2121212124
* //  0.006 seconds
 */
function String runme()
	List inputF, nList
	integer count, Starter=Date.Tick(), numRs=0, fhalf, curCnt=0
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\02-input.txt")
	for (count=1;count<=Length(inputF); count+=1)
		nList=Str.Elements(inputF[count],'-')
		if(Length(nList[1])==Length(nList[2]) && Length(nList[1])%2==1)
			// Odd numbered. Skip
			continue
		end
		fhalf=Length(nList[1])%2==0?Str.StringToInteger(nList[1][: \
		  Length(nList[1])/2]):Str.StringtoInteger("1"+Str.Set(Length(nList[1])/2, "0"))
		if(Str.StringToInteger((Str.Format("%1%2",fhalf,fhalf)))<Str.StringtoInteger(nList[1]))
			fhalf+=1
		end
		while(Str.StringToInteger((Str.Format("%1%2",fhalf,fhalf))) <= Str.StringToInteger(nList[2]))
			curCnt+=Str.StringToInteger((Str.Format("%1%2",fhalf,fhalf)))
			numRs+=1
			fhalf+=1
		end
	end
	echo(Str.ValueToString(curCnt)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
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
	return Str.Elements(incoming[1], ',')
end

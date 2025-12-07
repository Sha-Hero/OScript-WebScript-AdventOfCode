/*
 * Race. Longer pause, faster vehicle. Max distance.
 * How many seconds to pass the bottom number?
 * Simpe math.
 * Time:      7  15   30
 * Distance:  9  40  200
 * 0.001 s
 */
function String runme()
	List inputF, oneline = {}, results = {}
	List times = {}
	List dist = {}
	integer count=0, ocount=0, scount=0, tcount=1, Starter=Date.Tick()
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\6-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		inputF[count]=inputF[count][Str.Chr(inputF[count], ':')+1:]
	end
	times = List.SetRemove(Str.Elements(inputF[1], ' '), '')
	dist = List.SetRemove(Str.Elements(inputF[2], ' '), '')
	integer tdist = 0
	for (ocount=1; ocount <= Length(times); ocount+=1 )
		for (count=0; count<=Str.StringToInteger(times[ocount]); count+=1)
			tdist=(Str.StringToInteger(times[ocount])-count)*count
			if tdist > Str.StringToInteger(dist[ocount]); scount+=1; end;
		end
		tcount=tcount*scount
		scount=0
	end
	echo('Answer: '+Str.String(tcount)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done."
end

function List parseInput(String incoming)
	List eachrow = { incoming } 
	return eachrow
end
// Load the file.
function List loadData(String path)
	List incoming
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end

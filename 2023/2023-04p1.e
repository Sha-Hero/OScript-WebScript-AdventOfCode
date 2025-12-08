/*
 * Matching numbers from both sides with increasing "weight"
 * Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
 * Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
 * Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
 * Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
 * Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
 * Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
 * 0.01 s
 */
function String runme()
	List inputF, oneline = {}, results = {}, funcRet
	integer count, sum = 0, points, Starter=Date.Tick()
	String retArray
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\4-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		funcRet = parseInput("Card "+Str.ValueToString(count), inputF[count][Str.Chr(inputF[count], ':')+1:])
		points = Math.Power(2,Str.StringToInteger(funcRet[3])-1)
		if points < 1; points = 0; end;
		retArray = retArray+",[["+Str.String(funcRet[1])[2:-2]+"]"+",["+Str.String(funcRet[2])[2:-2]+"]"+",["+Str.String(funcRet[3])+"]"+",["+Str.String(points)+"]]"
		sum += points
	end
	// Trim the leading comma and package it up.
	retArray = "["+retArray[2:]+"]"
	// Add the sum to the return data. This is what we're looking for.
	retArray = "[["+Str.ValueToString(count)+","+Str.ValueToString(sum)+"],"+retArray+"]"
	echo('Answer: '+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function List parseInput(String cardnum, String draws)
	cardnum = Str.Strip(cardnum, "'") // removing leading/trailing quotes.
	draws = Str.Strip(draws, "'") // removing leading/trailing quotes.
	// Just going to union the sides and see how much "shorter" the list is.
	List winnum = Str.Elements(draws, "|")
	List eachrow = { List.SetRemove(Str.Elements(winnum[1], ' '), ''), List.SetRemove(Str.Elements(winnum[2], ' '), '') }
	eachrow = { @eachrow, Str.ValueToString(Length(eachrow[1])+Length(eachrow[2])-Length(List.SetUnion(eachrow[1], eachrow[2]))) }
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

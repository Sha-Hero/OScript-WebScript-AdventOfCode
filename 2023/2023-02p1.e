/*
 * Cube game. Find how many games are valid.
 * Pattern matching and substitution.
 * Game 1: 4 blue, 16 green, 2 red; 5 red, 11 blue, 16 green; 9 green, 11 blue; 10 blue, 6 green, 4 red
 * Game 2: 15 green, 20 red, 8 blue; 12 green, 7 red; 10 green, 2 blue, 15 red; 13 blue, 15 red
 * Game 3: 8 red, 2 blue; 3 green, 10 blue, 10 red; 7 green, 4 blue, 7 red; 8 red, 6 green, 13 blue; 4 green, 3 blue, 10 red; 7 blue, 7 green, 5 red
 */
// Returns an array: game#, rawdraws, blue, red, green
// NOTE: 12 red cubes, 13 green cubes, and 14 blue cubes
// 0.01 s
function String runme()
	integer count = 0, sum = 0, Starter=Date.Tick()
	string retArray=""
	List funcRet = {}, inputF
	// OK, let's load the data and do the work.
	inputF=Loaddata()
	for (count=1; count<=Length(inputF); count+=1)
		funcRet = parseInput("Game "+Str.ValueToString(count), inputF[count][Str.Chr(inputF[count], ':')+1:])
		retArray = retArray+","+funcRet[2]
		sum += funcRet[1]
	end
	// Trim the leading comma and package it up.
	retArray = "["+retArray[2:]+"]"
	// Add the sum to the return data. This is what we're looking for.
	retArray = "[["+Str.ValueToString(count)+","+Str.ValueToString(sum)+"],"+retArray+"]"
	echo('Sum is: '+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return retArray
end

function List parseInput(String gamenum, String draws)
	gamenum = Str.Strip(gamenum, "'") // removing leading/trailing quotes.
	draws = Str.Strip(draws, "'") // removing leading/trailing quotes.
	integer mred=12, mgreen=13, mblue=14
	String gnum = Pattern.Change( gamenum, Pattern.CompileFind( "Game " ), Pattern.CompileChange( '#1' ) )
	if (IsUndefined(gnum)); gnum='0'; end
	List games = Str.Elements( draws, ";")
	String eachRound = "", numBlue="", numRed="", numGreen=""
	for eachRound in games
		numBlue = Pattern.Change( eachRound, "?*[!0-9]+<[0-9]+> *blue?*", '#1' )
		numRed = Pattern.Change( eachRound, "?*[!0-9]+<[0-9]+> *red?*", '#1')
		numGreen = Pattern.Change( eachRound, "?*[!0-9]+<[0-9]+> *green?*", '#1' )
		if (IsUndefined(numBlue)); numBlue='0'; end
		if (IsUndefined(numRed)); numRed='0'; end
		if (IsUndefined(numGreen)); numGreen='0'; end
		if ((Str.StringToInteger(numBlue)>mblue)||(Str.StringToInteger(numRed)>mred)||(Str.StringToInteger(numGreen)>mgreen)); gnum="0"; break; end
	end
	List nums = { Str.StringToInteger(gnum), Str.Format("[%1, %2, %3, %4, %5, '%6']",gnum, Str.ValueToString(draws), Str.ValueToString(numBlue), Str.ValueToString(numRed), Str.ValueToString(numGreen), gnum)}
	return nums
end
// Load the file.
function List loadData()
	List incoming
	String s
	File fr = File.open("C:\AdventOfCodeInputs\2023\2-input.txt", File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			incoming = { @incoming, s}
		end
		File.Close(fr)
	end
	return incoming
end

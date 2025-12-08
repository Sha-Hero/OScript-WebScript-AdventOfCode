/*
 * Camel cards - poker like. Compare hands
 * Mapped A-J as Z-W and did reverse sort.
 * J is wildcard - find best match
 * 32T3K 765
 * T55J5 684
 * KK677 28
 * KTJJT 220
 * QQQJA 483
 * 0.085 sec
 */
function String runme()
	Assoc MyData = Assoc.CreateAssoc()
	List  tempSplit
	String hand, aKey
	Integer hrank,scount, jcount, Starter=Date.Tick()
	List numList = {0, 0, 0, 0, 0}
	List rankList = {{},{},{},{},{},{},{}}
	// OK, let's load the data and do the work.
	List inputF
	integer count, curVal, jokers
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\7-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		tempSplit = Str.Elements(inputF[count], ' ')
		numList = {0, 0, 0, 0, 0}
		jokers=0
		MyData = Assoc.CreateAssoc()
		hand = Str.String(tempSplit[1])
		MyData.value = Str.String(tempSplit[2])
		for (jcount=1; jcount <=5; jcount+=1)
			switch hand[jcount]
				case 'A'; hand[jcount]='Z'; end
				case 'K'; hand[jcount]='Y'; end
				case 'Q'; hand[jcount]='X'; end
				case 'J'; hand[jcount]='-'; jokers+=1; end
				case 'T'; hand[jcount]='V'; end
			end
			if hand[jcount] != '-'
				aKey='z'+Str.String(hand[jcount])
				curVal = Str.StringToInteger(MyData.(aKey))
				if IsDefined(curVal)
					numList[curVal] -= 1
					numList[curVal+1] += 1
					MyData.(aKey) = Str.String(curVal+1)
				else
					numList[1] += 1
					MyData.(aKey) = '1'
				end
			end
		end
		MyData.hand = hand
		if numList[5] == 1 || jokers==5 // five of a kind
			hrank=1
		elseif numList[4] == 1 // four of a kind, a single
			if jokers==1; hrank=1; else; hrank=2; end;
		elseif numList[3] == 1
			if numList[2] == 1 // full house
				hrank=3
			else // triple
				if jokers==1; hrank=2; elseif jokers==2; hrank=1; else; hrank=4; end;
			end
		elseif numList[2] ==2 // two pair
			if jokers==1; hrank=3; else; hrank=5; end;
		elseif numList[2] == 1 // one pair
			if jokers==1; hrank=4; elseif jokers==2; hrank=2; elseif jokers==3; hrank=1; else; hrank=6; end;
		else // high card
			if jokers==1; hrank=6; elseif jokers==2; hrank=4; elseif jokers==3; hrank=2; elseif jokers==4; hrank=1; else; hrank=7; end;
		end
		rankList[hrank] = List.Sort({ @rankList[hrank], { MyData.hand, MyData.value } })
	end
	// Sorted lists. Iterate and multiply.
	curVal=0
	hrank=1
	for (count=7; count>=1; count-=1)
		for (scount=1; scount<=Length(rankList[count]); scount+=1)
			curVal += hrank*Str.StringToInteger(rankList[count][scount][2])
			hrank += 1
		end
	end
	echo('Answer: '+Str.String(curVal)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done."
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

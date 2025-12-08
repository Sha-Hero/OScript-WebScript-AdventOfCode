/*
 * Camel cards - poker like. Compare hands
 * Mapped A-J as Z-W and did reverse sort.
 * 32T3K 765
 * T55J5 684
 * KK677 28
 * KTJJT 220
 * QQQJA 483
 * 0.08 s
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
	integer count, curVal
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\7-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		tempSplit = Str.Elements(inputF[count], ' ')
		numList = {0, 0, 0, 0, 0}
		MyData = Assoc.CreateAssoc()
		hand = Str.String(tempSplit[1])
		MyData.value = Str.String(tempSplit[2])
		for (jcount=1; jcount <=5; jcount+=1)
			switch hand[jcount]
				case 'A'; hand[jcount]='Z'; end
				case 'K'; hand[jcount]='Y'; end
				case 'Q'; hand[jcount]='X'; end
				case 'J'; hand[jcount]='W'; end
				case 'T'; hand[jcount]='V'; end
			end
			aKey='z'+Str.String(hand[jcount])
			curVal = Str.StringToInteger(MyData.(aKey))
			if IsDefined(curVal)
				numList[curVal] -= 1
				numList[curVal+1] += 1
				MyData.(aKey)= Str.String(curVal+1)
			else
				numList[1] += 1
				MyData.(aKey) = '1'
			end
		end
		MyData.hand = hand
		if numList[5] == 1 // five of a kind
			rankList[1] = List.Sort({ @rankList[1], { MyData.hand, MyData.value } })
		elseif numList[4] == 1 // four of a kind, a single
			rankList[2] = List.Sort({ @rankList[2], { MyData.hand, MyData.value } })
		elseif numList[3] == 1
			if numList[2] == 1 // full house
				rankList[3] = List.Sort({ @rankList[3], { MyData.hand, MyData.value } })
			else // triple
				rankList[4] = List.Sort({ @rankList[4], { MyData.hand, MyData.value } })
			end
		elseif numList[2] ==2 // two pair
			rankList[5] = List.Sort({ @rankList[5], { MyData.hand, MyData.value } })
		elseif numList[2] == 1 // one pair
			rankList[6] = List.Sort({ @rankList[6], { MyData.hand, MyData.value } })
		else // high card
			rankList[7] = List.Sort({ @rankList[7], { MyData.hand, MyData.value } })
		end
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

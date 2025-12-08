/*
 * Oasis, pattern determination. Find next number.
 * Definition gave trick to find.
 * 0 3 6 9 12 15
 * 1 3 6 10 15 21
 * 10 13 16 21 30 45
 * So - find the top bracket by iterating down
 * 1   3   6  10  15  21  (28)
 *   2   3   4   5   6   (7)
 *     1   1   1   1   (1)
 *       0   0   0   (0)
 * 0.06 s
 */
function String runme()
	Integer Starter = Date.Tick()
	Integer count=1, curSum=0, tempSum, icount
	List inpElem, levtwo, inputF
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\9-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		inpElem[count] = Str.Elements(inputF[count], ' ')
		// Wish I could force the elements as integers at first.
		for (icount=1; icount<=Length(inpElem[count]); icount+=1)
			inpElem[count][icount] = Str.StringToInteger(inpElem[count][icount])
		end
		levtwo[count] = sDiff(inpElem[count])
		tempSum=0 // last element
		for (icount=Length(levtwo[count]); icount>=1; icount-=1)
			tempSum+=levtwo[count][icount][-1]
		end
		curSum+=tempSum
	end
	echo(Str.String(curSum)+' : '+Str.String(Date.Tick()-Starter)+' ticks.')
	return Str.String(curSum)
end

function List sDiff(List incom)
	List output = {}
	Integer myNum, prev = incom[2]-incom[1], count
	for (count=1; count< Length(incom); count+=1)
		myNum= incom[count+1]-incom[count]
		output = { @output, myNum }
		if IsDefined(prev)
			if prev!=myNum
				prev=undefined
			end
		end
	end
	if IsDefined(prev)
		return { incom, output }
	end
	return { incom, @sDiff(output) }
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

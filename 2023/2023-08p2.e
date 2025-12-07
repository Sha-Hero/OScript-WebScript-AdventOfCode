/*
 * Path length from AAA to ZZZ, multiple Axx to Zzz.
 * Trick was since paths cyclical, GCD for all paths.
 * RL
 * AAA = (BBB, CCC)
 * BBB = (DDD, EEE)
 * CCC = (ZZZ, GGG)
 * DDD = (DDD, DDD)
 * EEE = (EEE, EEE)
 * GGG = (GGG, GGG)
 * ZZZ = (ZZZ, ZZZ)
 * 0.26 s
 */
function String runme()
	Assoc MyData = Assoc.CreateAssoc()
	Integer count = 0, neb
	List inpElem = {}, sLoc={}, pLength = {}
	String path, entry = '', cur=''
	List inputF
	Integer Starter=Date.Tick()
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\8-input.txt")
	// OK, let's load the data and do the work. OScript doesn't like the input format.
	MyData = Assoc.CreateAssoc()
	for (count=1; count<=Length(inputF); count+=1)
		if inputF[count]==''
			//doing nothing.
		elseif count == 1
			// First run, it's the path.
			path = Str.String(inputF[count])
		else
			// It's the L/R maps.
			inpElem = Str.Elements(inputF[count], ' ')
			MyData.(inpElem[1]+'L')=inpElem[3][2:-2]
			MyData.(inpElem[1]+'R')=inpElem[4][:-2]
			if (inpElem[1][3] == 'A') // Keep track of the Axx ones.
				sLoc = { @sLoc, inpElem[1] }
			end
		end
	end
	for cur in sLoc
		neb=1
		while (1==1)
			for (count=1; count<=Length(path); count+=1)
				cur = MyData.(cur+path[count])
			end
			if cur[3] == 'Z'
				pLength = { @pLength, neb*Length(path) }
				break
			end
			neb += 1
		end
	end
	// We have the cycles and lengths. Now.... find LCM for all of them.
	echo('Answer: '+Str.String(lcm(pLength))+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done."
end

function Integer gcd(Integer a, Integer b)
	Integer c
	if a < b; c=b; b=a; a=c; end;
	while b != 0
		c=a%b; a=b; b=c;
	end
	return a
end
function Integer lcm(List incom)
	Integer curLCM=incom[1], count
	for (count=2; count<=Length(incom); count+=1)
		curLCM = (curLCM*incom[count]) / gcd(curLCM, incom[count])
	end
	// Help from https://stackoverflow.com/questions/147515/least-common-multiple-for-3-or-more-numbers
	return curLCM
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

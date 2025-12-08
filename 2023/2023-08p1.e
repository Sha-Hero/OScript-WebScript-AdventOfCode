/*
 * Path length from AAA to ZZZ
 * Just path traversal, given set step-groups.
 * RL
 * AAA = (BBB, CCC)
 * BBB = (DDD, EEE)
 * CCC = (ZZZ, GGG)
 * DDD = (DDD, DDD)
 * EEE = (EEE, EEE)
 * GGG = (GGG, GGG)
 * ZZZ = (ZZZ, ZZZ)
 * 0.06 s
 */
function String runme()
	Assoc MyData = Assoc.CreateAssoc()
	Integer count = 0, Starter=Date.Tick()
	List inpElem = {}
	String path, entry = '', cur=''
	List inputF
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\8-input.txt")
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
		end
	end
	cur = 'AAA'
	Integer neb=1
	while (1==1)
		for (count=1; count<=Length(path); count+=1)
			cur = MyData.(cur+path[count])
		end
		if cur == 'ZZZ'
			break
		end
		neb += 1
	end
	echo('Answer: '+Str.String(neb*Length(path))+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done"
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

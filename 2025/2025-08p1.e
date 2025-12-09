/*
 * Size of three closest point groups.
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
* 3.70 seconds - 2.6 in parsing.
* OMG. Two big mistakes I made on this that cost me a lot of time:
* 1) I used the wrong distance formula between two points in 3d space.
* 2) I forgot that "^" which is exponent in most sane languages, is XOR in OScript.
* ... so 2^4 = 6. *sigh*. Need to use Math.Power... clunky.
// 
 */
function String runme()
	integer Starter=Date.Tick()
	echo("Starting...")
	List inputF
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\08-input.txt")
	List nList={}, tList
	Integer count, count2, sum=0, cntr, numDun=0, numWant=1000
	Assoc dAssoc=Assoc.CreateAssoc({})
	Assoc fAssoc=Assoc.CreateAssoc(Set.FromList({}))
	Assoc lAssoc=Assoc.CreateAssoc({0,0})
	Integer c1=0, c2=0
	Boolean found1=false, found2=false
	for(count=1;count<=Length(inputF);count+=1)
		tList=Str.Elements(inputF[count], ',')
		nList+={{Str.StringToInteger(tList[1]),Str.StringToInteger(tList[2]),Str.StringToInteger(tList[3])}}
	end
	// 3d distances: √(x2−x1)2+(y2−y1)2+(z2−z1)2 <-- but we don't need to get the root
	for(count=1;count<Length(nList);count+=1)
		for(count2=count+1;count2<=Length(nList);count2+=1)
			cntr=Math.Power(nList[count][1]-nList[count2][1],2) + \
				Math.Power(nList[count][2]-nList[count2][2],2) + \
				Math.Power(nList[count][3]-nList[count2][3],2)
			dAssoc.(cntr)+={List.Sort({nList[count],nList[count2]})}
		end
	end
	echo("Ranges: "+Str.String(Date.Tick()-Starter)+" ticks")
	// Got the ranges. Let's solve.
	tList={}
	nList={}
	for cntr in Assoc.Keys(dAssoc)[:numWant]
		found1=false;found2=false
		c1=0;c2=0
		for(count=1;count<=Length(dAssoc.(cntr));count+=1)
			// Might be multiples with same length.
			for(count2=1;count2<=Length(fAssoc);count2+=1)
				if dAssoc.(cntr)[count][1] in fAssoc[count2]
					c1=count2
					found1=true
				elseif dAssoc.(cntr)[count][2] in fAssoc[count2]
					c2=count2
					found2=true
				end
				if(found1&&found2)
					break;
				end
			end
			if(found1&&found2)
				fAssoc[c1]=fAssoc[c1].Union(fAssoc[c2])
				lAssoc[c1]={Length(fAssoc[c1]),c1}
				fAssoc[c2]=Set.FromList({})
				lAssoc[c2]={0,0}
			elseif(found1)
				fAssoc[c1]=fAssoc[c1].Union(Set.FromList({dAssoc.(cntr)[count][2]}))
				lAssoc[c1]={Length(fAssoc[c1]),c1}
			elseif(found2)
				fAssoc[c2]=fAssoc[c2].Union(Set.FromList({dAssoc.(cntr)[count][1]}))
				lAssoc[c2]={Length(fAssoc[c2]),c2}
			else
				fAssoc[count2]=Set.FromList({dAssoc.(cntr)[count][1],dAssoc.(cntr)[count][2]})
				lAssoc[count2]={Length(fAssoc[count2]),count2}
			end
			numDun+=1
			if(numDun==numWant)
				break;
			end
		end
		if(numDun==numWant)
			break;
		end
	end
	echo("Pairs: "+Str.String(Date.Tick()-Starter)+" ticks")
	// Have the pairs.
	tList=List.Sort(Assoc.Items(lAssoc), List.Descending)
	sum=tList[1][1]*tList[2][1]*tList[3][1]
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end
// Load the file
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

/*
 * Numbers in ranges - now what is total range? (ignore second half of input
3-5
10-14
16-20
12-18

1
5
8
11
17
32
// 0.009 seconds
 */
function String runme()
	List inputF, tList, fRange={}, eRange={}
	integer Starter=Date.Tick()
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\05-input.txt")
	Integer count, count2, sum=0, entry, cntr=1
	List ress
	for(count=1;count<=Length(inputF[1]);count+=1)
		// Get the ranges.
		tList=Str.Elements(inputF[1][count],"-")
		tList[1]=Str.StringToInteger(tList[1])
		tList[2]=Str.StringToInteger(tList[2])
		tList[3]=tList[2]-tList[1]+1
		fRange={ @fRange, tList }
	end
	fRange=List.Sort(fRange)
	// Collapse the ranges. Can probably skip ones where eRange(2)<fRange(1)
	eRange={fRange[1]}
	for(count=2;count<=Length(fRange);count+=1)
		for(count2=cntr;count2<=Length(eRange);count2+=1)
			ress=newRange(eRange[count2], fRange[count])
			if(ress=={})
				echo("undef.")
			end
			if(ress=={} || (IsUndefined(ress)&&count2==Length(eRange)))
				eRange+={fRange[count]}
				break
			elseif(IsDefined(ress))
				eRange[count2]=ress
				cntr=count2
				break
			end
		end
	end
	// Got the ranges. Let's add.
	for(count=1;count<=Length(eRange);count+=1)
		sum+=eRange[count][3]
	end
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end
function List newRange(List rList1, List rList2)
	if(rList1[2]<rList2[1] )
		//  |------|
		//		   |---|
		return Undefined
	elseif(rList1[1]<=rList2[1] && rList1[2]>=rList2[2])
		//  |------|
		//	|--|
		return rList1
	elseif(rList1[1]>=rList2[1] && rList1[2]<=rList2[2])
		//	|--|
		//  |------|
		return rList2
	elseif(rList1[1]>=rList2[1] && rList1[1]<=rList2[2] && rList1[2]>=rList2[2])
		//	|-----|
		// |----|
		return {rList2[1],rList1[2], rList1[2]-rList2[1]+1}
	elseif(rList1[1]<=rList2[1] && rList1[2]>=rList2[1] && rList1[2]<=rList2[2])
		// |------|
		//	|------|
		return {rList1[1],rList2[2], rList2[2]-rList1[1]+1}
	elseif( rList1[1]>rList2[2] )
		// Should never happen because it's sorted.
		//		  |------|
		//  |---|
		return {}
	end
end 
// Load the file - MOD - split return
function List loadData(String path)
	List incoming1={}, incoming2={}
	String s
	Integer inpart=1
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65535); s!=File.E_Eof; s=File.Read(fr, 65535))
			if(Length(s)==0)
				inpart=2
				continue
			end
			if(inpart==1)
				incoming1 = { @incoming1, s}
			else
				incoming2 = { @incoming2, s}
			end
		end
		File.Close(fr)
	end
	return { incoming1, incoming2 }
end

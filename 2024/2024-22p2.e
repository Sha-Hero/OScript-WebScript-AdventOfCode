/*
 * Secrets - number manipulation. Find best combo.
1
10
100
2024
// 44 seconds
 */
function String runme()
	List inputF, tlist={}, clist={}, slist
	Assoc bsum = Assoc.CreateAssoc(), tchange = Assoc.CreateAssoc()
	integer Starter=Date.Tick(), ca, cb, num, ta, tb, tc, maxnum=0, tval
	String akey, gkey
	Assoc.UndefinedValue(bsum, 0)
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-22-input.txt")
	for(ca=1; ca<=Length(inputF); ca+=1)
		tchange = Assoc.CreateAssoc()
		num=Str.StringToInteger(inputF[ca])
		tlist={num%10}; clist={}
		for (cb=1; cb<=2000; cb+=1)
			ta=((num*64)^num)%16777216
			tb=((ta/32)^ta)%16777216
			tc=((tb*2048)^tb)%16777216
			num=tc
			tlist+={num%10}; clist+={tlist[cb+1]-tlist[cb]}
			slist={clist[cb-3],clist[cb-2],clist[cb-1],clist[cb]}
			if cb>3 && undefined == tchange.(slist)
				tchange.(slist)=true
				bsum.(slist)+=num%10
				if bsum.(slist)>=maxnum
					maxnum=bsum.(slist)
				end
			end
		end
	end
	echo("Sum is: ", maxnum)
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
end
// Load the file.
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
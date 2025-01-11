/*
 * Key/Lock combo
#####
.####
.####
.####
.#.#.
.#...
.....
// 0.15 seconds
 */
function String runme()
	List inputF, keys={}, locks={}
	integer Starter=Date.Tick(), count, sum=0, c2
	Boolean lock=false, blank=true, ok=true
	List tkey={0,0,0,0,0}, tlock={0,0,0,0,0}
	String p
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-25-input.txt")
	for(count=1; count<=Length(inputF); count+=1)
		if(Length(inputF[count])==0)
			if lock; locks=List.SetAdd(locks, tlock); lock=false; else; keys=List.SetAdd(keys, tkey); end // grab the last one. :-)
			tkey={0,0,0,0,0}; tlock={0,0,0,0,0}
			blank=true
			continue
		else
			if blank // It's a new combo
				lock=inputF[count][1]=='#'?true:false // it's a key.
				blank=false
			end
			for(c2=1; c2<=5; c2+=1)
				if inputF[count][c2]=='#'
					if lock; tlock[c2]+=1; else; tkey[c2]+=1; end
				end
			end
		end
	end
	if lock; locks=List.SetAdd(locks, tlock); lock=false; else; keys=List.SetAdd(keys, tkey); end // grab the last one. :-)
	locks=List.Sort(locks); keys=List.Sort(keys)
	for tlock in locks
		for tkey in keys
			ok=true
			if tlock[1]+tkey[1]>7; break; end
			for(c2=2; c2<=5; c2+=1)
				if tlock[c2]+tkey[c2]>7; ok=false; break; end
			end
			if ok; sum+=1; end
		end
	end
	echo ( "Sum is: ", sum)
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
end
function integer findit(String key)
	if !$$a.(key)
		$$a.(key)=calcit($$c.(key))
	end
	return $$a.(key)
end
function integer calcit(List reqs)
	String keya=reqs[1], keyb=reqs[2], op=reqs[3]
	if IsUndefined($$a.(keya))
		$$a.(keya)=calcit($$c.(keya))
	end
	if IsUndefined($$a.(keyb))
		$$a.(keyb)=calcit($$c.(keyb))
	end
	if op=='OR'
		return ($$a.(keya)==1 || $$a.(keyb)==1)?1:0
	elseif op=='AND'
		return ($$a.(keya)==1 && $$a.(keyb)==1)?1:0
	elseif op=='XOR'
		return ($$a.(keya)!=$$a.(keyb))?1:0
	end
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

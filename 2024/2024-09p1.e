/*
 * Find disk efficiencies
 * 2333133121414131402
 * 8.2 seconds
 */
function String runme()
	List inputF, nums={}
	integer count=0, count2, Starter=Date.Tick(), sum=0, n, curid=0
	String c, tst
	Boolean isfile=true
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-09-input.txt")
	for c in inputF[1]
		n=Str.StringToInteger(c)
		if isfile
			curid+=1
		end
		if n>0
			if isfile
				tst="{"
				for(count=1; count<=n; count+=1); tst+=Str.String(curid-1)+","; end
				tst=tst[:-2]+"}"
				nums={@nums, @Str.StringToValue(tst)}
			else
				nums={@nums, @List.Allocate(n)}
			end
		end
		isfile=isfile?false:true
	end
	// Got the list. Let's compact it.
	count2=Length(nums)
	for(count=1; count<=count2; count+=1)
		if IsUndefined(nums[count])
			while (IsUndefined(nums[count2]))
				count2 -=1
			end
			nums[count]=nums[count2]; nums=nums[:count2-1]
			count2 -=1
		end
	end
	for (count=1; count<=Length(nums); count+=1)
		//		if IsUndefined(nums[count])
		//			break;
		//		end
		sum += (count-1)*nums[count]
	end
	//	echo(nums)
	echo("Part 1 answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

// Load the file.
function List loadData(String path)
	List incoming, biglist
	String s
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr, 65534); s!=File.E_Eof; s=File.Read(fr, 65534))
			incoming = { @incoming, s }
		end
		File.Close(fr)
	end
	return incoming
end
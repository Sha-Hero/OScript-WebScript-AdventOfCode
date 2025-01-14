/*
 * Find disk efficiencies - chunks only
 * 2333133121414131402
 * 24.4 seconds
 * Efficiencies: Basic looping from highest number+1 on all: 437 seconds
 * Looping from highest number on all: 409 seconds
 * Shrinking the file list from the right as we traverse down the numbers: 272 seconds
 * Shrinking the chunk list from the left - skipping zeros: 128 seconds.
 * Future potentials: tracking openings of ones, twos, etc.
 * Some other data structure than lists for manipulation (insertions/deletions may be expensive?)
 */
function String runme()
	List inputF, nums={}, files={}, chunks={}
	integer count=0, count2, Starter=Date.Tick(), sum=0, n, m, j, curid=0
	String c, tst
	Boolean isfile=true, foundit=false, nonzero=false
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-09-input.txt")
	for c in inputF[1]
		n=Str.StringToInteger(c)
		if isfile
			files = {@files, {n, curid}} // length, id
			curid+=1
		else
			chunks = {@chunks, n}
		end
		isfile=isfile?false:true
	end
	// Got the list. Let's compact it.
	curid-=1
	m=Length(files); j=1
	while curid>=1
		// Going from biggest to smallest.
		nonzero=false
		for(count2=m; count2>=1; count2-=1)
			if(files[count2][2]==curid)
				// Got it. Now iterate up through the slots.
				foundit=true
				m=count2
				for(count=j; count<count2; count+=1)
					n = chunks[count]
					if n==0 && !nonzero
						j=count
					end
					if n>0
						nonzero=true
						if(files[count2][1]<=n)
							/// fits!
							nums=files[count2]
							chunks[count]=0
							chunks=chunks[:count]+{n-files[count2][1], @chunks[count+1:] }
							chunks[count2]=chunks[count2]+files[count2][1]
							if IsDefined(chunks[count2+1])
								chunks[count2]+=chunks[count2+1]
								if IsDefined(chunks[count2+2])
									chunks = chunks[:count2]+chunks[count2+2:]
								else
									chunks = chunks[:count2]
								end
							end
							files=files[:count2-1]+files[count2+1:] // removing the old one.
							files=files[:count]+{nums, @files[count+1:]}
							break; // reset it.
						end
					end
				end
			end
			if foundit
				foundit=false
				break
			end
		end
		curid-=1
	end
	// count 'em up!
	n=0
	for (count=1; count<=Length(files); count+=1)
		for (count2=1; count2<=files[count][1]; count2+=1)
			sum += n*files[count][2]
			n+=1
		end
		n += chunks[count]
	end
	echo("Part 2 answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
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
/*
 * Pulse propagation. Queue, state change, etc.
 * Parse and .. queue correctly.
 * broadcaster -> a, b, c
 * %a -> b
 * %b -> c
 * %c -> inv
 * &inv -> a
 * Part 2 - LCM approach, but HAD TO EXAMINE the data!
 * 2.7 seconds
 */
function String runme()
	List inputF, bcast, mqueue={}, squeue = {} // starting queue
	Assoc module = Assoc.CreateAssoc(), conj = Assoc.CreateAssoc()
	integer count, sum = 0, Starter=Date.Tick(), curstate=0, pulse=0 // 0=low
	String modname, elem, cur
	Boolean allHigh = FALSE, foundit=FALSE
	integer x=0, st=0, hh=0, tn=0, dt=0
	//	integer scount = 1, lcount = 0, hcount = 0 // scount is button+broadcast
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\20-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		if inputF[count][:11] == 'broadcaster'
			bcast = Str.Elements(Str.Collapse(inputF[count][16:]), ",")
			for elem in bcast
				//				scount += 1
				squeue = {@squeue, {elem, 0, 'broadcaster'}} // low pulses to everyone.
			end
		else
			// Flip-flop (%) needs only to know current state.
			// Conjunctions (&) know the connected incoming, and values.
			module.(inputF[count][2:Str.Chr(inputF[count], " ")-1]) = {inputF[count][1], Str.Elements(Str.Collapse(inputF[count][Str.Chr(inputF[count], ">")+2:]), ","), 0} 
			if (inputF[count][1] == '&')
				conj.(inputF[count][2:Str.Chr(inputF[count], " ")-1]) = {}
			end
		end
	end
	for modname in Assoc.Keys(module)
		for elem in Assoc.Keys(conj)
			if (elem in module.(modname)[2])
				conj.(elem) = {@conj.(elem), {modname, 0} }
			end
		end
	end

	while st==0 || hh==0 || tn==0 || dt==0
		x+=1
		mqueue = { @squeue }
		//		lcount += scount
			
		while Length(mqueue) > 0
			// Queue { targetElem, incomingPulse, sourceElem }
			// module (elem) { type, {targetList}, currentState }
			// conj (elem) { { sourceElem, lastInputSourceState } .. }
			cur = mqueue[1][1] // The current element being pinged
			if  IsUndefined(module.(cur))
				mqueue = Length(mqueue)==1?{}:mqueue[2:]
				continue
			end
			curstate=module.(cur)[3]; // getting the current state
			elem = module.(cur)[1] // current element type
			if (mqueue[1][2]==0)
				// Low pulse being sent
				if (elem == '%')
					// Low pulse to a flip-flop swaps on/off
					module.(cur)[3]=curstate==1?0:1 // change the state
					for elem in module.(cur)[2]
						// iterate through and send the new state to its targets
						//						if (curstate==1);lcount+=1;else;hcount+=1;end
						mqueue={ @mqueue, {elem, curstate==1?0:1, cur}};
					end
				elseif (elem == '&') // conjunction. Updates input. If all high then sends low, otherwise sends high
					allHigh = FALSE // incoming pulse is low.
					for (count=1; count <= Length(conj.(cur)); count+=1)
						if(conj.(cur)[count][1] == mqueue[1][3])
							// Updating the incoming pulse memory.
							conj.(cur)[count][2] = mqueue[1][2]
						end
					end
					if(!allHigh && cur=='st' && st==0); st=x; end
					if(!allHigh && cur=='hh' && hh==0); hh=x; end
					if(!allHigh && cur=='tn' && tn==0); tn=x; end
					if(!allHigh && cur=='dt' && dt==0); dt=x; end
					for elem in module.(cur)[2]
						//						if (allHigh);lcount+=1;else;hcount+=1;end
						mqueue={ @mqueue, {elem, allHigh?0:1, cur}};
					end
				end
			else
				// High pulse
				if (elem == '%') // ignored!
				elseif (elem == '&') // conjunction
					allHigh = TRUE
					for (count=1; count <= Length(conj.(mqueue[1][1])); count+=1)
						if(conj.(cur)[count][1] == mqueue[1][3])
							conj.(cur)[count][2] = mqueue[1][2]
						end
						if (conj.(cur)[count][2] == 0)
							allHigh = FALSE
						end
					end
					if(!allHigh && cur=='st' && st==0); st=x; end
					if(!allHigh && cur=='hh' && hh==0); hh=x; end
					if(!allHigh && cur=='tn' && tn==0); tn=x; end
					if(!allHigh && cur=='dt' && dt==0); dt=x; end
					for elem in module.(cur)[2]
						//						if (allHigh);lcount+=1;else;hcount+=1;end
						mqueue={ @mqueue, {elem, allHigh?0:1, cur}};
					end
				end
			end
			mqueue = Length(mqueue)==1?{}:mqueue[2:]
		end
	end
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	echo(Str.Format("st=%1, hh=%2, tn=%3, dt=%4", st, hh, tn, dt))
	echo(Str.String(lcm({st, hh, tn, dt})))
	return "Done!"
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

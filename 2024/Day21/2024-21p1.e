/*
 * Keypads - robots to robots...
029A
980A
179A
456A
379A
+---+---+---+
| 7 | 8 | 9 |
+---+---+---+
| 4 | 5 | 6 |
+---+---+---+
| 1 | 2 | 3 |
+---+---+---+
| 0 | A |
+---+---+
+---+---+
| ^ | A |
+---+---+---+
| < | v | > |
+---+---+---+
// 0.002 seconds
 * See part 2 for a better, faster, more general solution.
 */
function String runme()
	List inputF
	integer Starter=Date.Tick(), sum=0, ca, cb
	String startstr
	$$kl = Assoc.CreateAssoc()
	$$kl.('7')={1,1}; $$kl.('8')={1,2}; $$kl.('9')={1,3}
	$$kl.('4')={2,1}; $$kl.('5')={2,2}; $$kl.('6')={2,3}
	$$kl.('1')={3,1}; $$kl.('2')={3,2}; $$kl.('3')={3,3}
	$$kl.('0')={4,2}; $$kl.('A')={4,3}
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-21-input.txt")
	for(ca=1; ca<=Length(inputF); ca+=1)
		startstr=kpfromto('A',inputF[ca][1])
		startstr+=kpfromto(inputF[ca][1],inputF[ca][2])
		startstr+=kpfromto(inputF[ca][2],inputF[ca][3])
		startstr+=kpfromto(inputF[ca][3],inputF[ca][4])
		for(cb=1; cb<=2; cb+=1)
			startstr=rbfromto(startstr)
		end
		sum+=Length(startstr)*Str.StringToInteger(inputF[ca][:3])
	end
	echo("Sum is: ", sum)
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
end

function String kpfromto( String curkey, String destkey)
	integer y = $$kl.(destkey)[1] - $$kl.(curkey)[1]
	integer x = $$kl.(destkey)[2] - $$kl.(curkey)[2]
	String xstr=x<0?Str.Set(MAth.Abs(x),'<'):(x>0?Str.Set(MAth.Abs(x),'>'):'')
	String ystr=y<0?Str.Set(MAth.Abs(y),'^'):(y>0?Str.Set(MAth.Abs(y),'v'):'')
	if x>0
		if (curkey in {'7', '4', '1'}) && (destkey in {'0', 'A'})
			return xstr+ystr+'A'
		else
			return ystr+xstr+'A'
		end
	elseif x<0
		if (destkey in {'7', '4', '1'}) && (curkey in {'0', 'A'})
			return ystr+xstr+'A'
		else
			return xstr+ystr+'A'
		end
	else
		return ystr+'A'
	end
end
function String rbfromto( String path)
	// parse the path.
	integer c
	String prev='A', retstr=''
	for(c=1; c<=Length(path); c+=1)
		if path[c]=='<'
			if prev=='<'
				retstr+='A'
			elseif prev=='A'
				retstr+='v<<A'
			elseif prev=='v'
				retstr+='<A'
			elseif prev=='^'
				retstr+='v<A'
			end
		elseif path[c]=='^'
			if prev=='^'
				retstr+='A'
			elseif prev=='A'
				retstr+='<A'
			elseif prev=='<'
				retstr+='>^A'
			elseif prev=='>'
				retstr+='^<A'
			end
		elseif path[c]=='v'
			if prev=='v'
				retstr+='A'
			elseif prev=='A'
				retstr+='v<A'
			elseif prev=='<'
				retstr+='>A'
			elseif prev=='>'
				retstr+='<A'
			end
		elseif path[c]=='>'
			if prev=='>'
				retstr+='A'
			elseif prev=='A'
				retstr+='vA'
			elseif prev=='v'
				retstr+='>A'
			elseif prev=='^'
				retstr+='v>A'
			end
		elseif path[c]=='A'
			if prev=='A'
				retstr+='A'
			elseif prev=='<'
				retstr+='>>^A'
			elseif prev=='v'
				retstr+='^>A'
			elseif prev=='^'
				retstr+='>A'
			elseif prev=='>'
				retstr+='^A'
			end
		end
		prev=path[c]
	end
	return retstr
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

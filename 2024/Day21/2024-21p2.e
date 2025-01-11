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
// 0.006 seconds
 *  Output ranged by four times depending on directions taken.
 * Key priorities for directions - left, (up, down) right
 */
function String runme()
	List inputF
	integer Starter=Date.Tick(), sum=0, ca, cb, yo=0
	String startstr
	$$mm = Assoc.CreateAssoc()
	$$n = Assoc.CreateAssoc()
	$$kl = Assoc.CreateAssoc()
	$$kl.('7')={1,1}; $$kl.('8')={1,2}; $$kl.('9')={1,3}
	$$kl.('4')={2,1}; $$kl.('5')={2,2}; $$kl.('6')={2,3}
	$$kl.('1')={3,1}; $$kl.('2')={3,2}; $$kl.('3')={3,3}
	$$kl.('0')={4,2}; $$kl.('A')={4,3}
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-21-input.txt")
	seedit()
	for(ca=1; ca<=Length(inputF); ca+=1)
		yo=0
		startstr=kpfromto('A',inputF[ca][1])
		startstr+=kpfromto(inputF[ca][1],inputF[ca][2])
		startstr+=kpfromto(inputF[ca][2],inputF[ca][3])
		startstr+=kpfromto(inputF[ca][3],inputF[ca][4])
		yo=rbfromtom(25, 'A'+startstr)
		sum+=yo*Str.StringToInteger(inputF[ca][:3])
	end
	echo("Sum is: ", sum)
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
end

function String kpfromto( String curkey, String destkey)
	integer y = $$kl.(destkey)[1] - $$kl.(curkey)[1]
	integer x = $$kl.(destkey)[2] - $$kl.(curkey)[2]
	String xstr=x<0?Str.Set(MAth.Abs(x),'<'):(x>0?Str.Set(MAth.Abs(x),'>'):'')
	String ystr=y<0?Str.Set(MAth.Abs(y),'^'):(y>0?Str.Set(MAth.Abs(y),'v'):'')
	if x<0
		if (destkey in {'7', '4', '1'}) && (curkey in {'0', 'A'})
			return ystr+xstr+'A'
		else
			return xstr+ystr+'A'
		end
	elseif x>0
		if (curkey in {'7', '4', '1'}) && (destkey in {'0', 'A'})
			return xstr+ystr+'A'
		else
			return ystr+xstr+'A'
		end
	else
		return ystr+'A'
	end
end
function integer rbfromtom( integer curd, String path)
	// parse the path.
	integer c=0, c2, cc=0
	String tstr
	if Isdefined($$n.(path+Str.String(curd)))
		return $$n.(path+Str.String(curd))
	end
	for(c2=1; c2<Length(path); c2+=1)
		if IsDefined($$n.(path[c2:c2+1]+Str.String(curd)))
			c+=$$n.(path[c2:c2+1]+Str.String(curd))
		else
			tstr='A'+$$mm.(path[c2:c2+1]+'1')
			cc=rbfromtom( curd-1, tstr)
			$$n.(path[c2:c2+1]+Str.String(curd))=cc
			c+=cc
		end
	end
	return c
end
// Meh. Get it started.
function void seedit()
	$$mm.('<<1') = 'A'
	$$mm.('A<1') = 'v<<A'
	$$mm.('v<1') = '<A'
	$$mm.('^<1') = 'v<A'
	$$mm.('^^1') = 'A'
	$$mm.('>^1') = '<^A' // left up 
	$$mm.('<^1') = '>^A'
	$$mm.('A^1') = '<A'
	$$mm.('<v1') = '>A'
	$$mm.('vv1') = 'A'
	$$mm.('>v1') = '<A'
	$$mm.('Av1') = '<vA' // left down
	$$mm.('^>1') = 'v>A' // down right
	$$mm.('v>1') = '>A'
	$$mm.('>>1') = 'A'
	$$mm.('A>1') = 'vA'
	$$mm.('AA1') = 'A'
	$$mm.('<A1') = '>>^A'
	$$mm.('vA1') = '^>A' // up right
	$$mm.('>A1') = '^A'
	$$mm.('^A1') = '>A'
	String tk
	for tk in Assoc.Keys($$mm)
		$$n.(tk)=Length($$mm.(tk))
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

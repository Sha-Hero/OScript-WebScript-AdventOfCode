/*
 * OP codes
Register A: 729
Register B: 0
Register C: 0

Program: 0,1,5,4,3,0
 *
Combo operands 0 through 3 represent literal values 0 through 3.
Combo operand 4 represents the value of register A.
Combo operand 5 represents the value of register B.
Combo operand 6 represents the value of register C.
Combo operand 7 is reserved and will not appear in valid programs.
 *
 */
//  0.001 seconds
// 
function String runme()
	List inputF, cmds
	integer Starter=Date.Tick(), count
	integer a, b, c, ret, cmb, cmd, raw
	List outt={}
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-17-input.txt")
	a=Str.StringToInteger(inputF[1][13:])
	b=Str.StringToInteger(inputF[2][13:])
	c=Str.StringToInteger(inputF[3][13:])
	cmds=Str.Elements(inputF[5][10:], ',')
	for(count=1; count<=Length(cmds); count+=2)
		cmd=Str.StringToInteger(cmds[count])
		raw=Str.StringToInteger(cmds[count+1])
		cmb=raw<4?raw:(raw==4?a:(raw==5?b:(raw==6?c:raw)));
		if(cmd==0); a=a/Math.Power(2, cmb)
		elseif(cmd==1); b=b^raw
		elseif(cmd==2); b=cmb%8
		elseif(cmd==3 && a!=0); count=raw-1
		elseif(cmd==4); b=b^c
		elseif(cmd==5); outt+={ cmb%8 }
		elseif(cmd==6); b=a/Math.Power(2, cmb)
		elseif(cmd==7); c=a/Math.Power(2, cmb)
		end
	end
	echo(outt)
	echo ( "Total time: "+Str.String(Date.Tick()-Starter))
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

/*
 * Present delivery. Alternate between two people.
v>v<vvv<<vv^v<v>v
// 0.432 seconds
 */
function String runme()
	List inputF
	integer count, Starter=Date.Tick(), xS=0, xR=0, yS=0, yR=0
	Assoc hGrid=Assoc.CreateAssoc() // 2d assoc of houses.
	String dir, loc
	Boolean Santa=true
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2015\03-input.txt")
	hGrid.'0:0' = 1
	for (count=1;count<=Length(inputF[1]); count+=1)
		dir=inputF[1][count]
		if(dir=='^')
			if(Santa);yS+=1;else;yR+=1;end;
		elseif(dir=='v')
			if(Santa);yS-=1;else;yR-=1;end;
		elseif(dir=='<')
			if(Santa);xS-=1;else;xR-=1;end;
		elseif(dir=='>')
			if(Santa);xS+=1;else;xR+=1;end;
		else
			echo("Bad char")
			break;
		end
		if(Santa)
			loc=Str.String(xS)+':'+Str.String(yS)
			Santa=FALSE
		else
			loc=Str.String(xR)+':'+Str.String(yR)
			Santa=TRUE
		end
		if(!isDefined(hGrid.(loc)))
			hGrid.(loc)=1
		end
	end
	echo("Houses: "+Str.ValueToString(Length(hGrid))+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
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

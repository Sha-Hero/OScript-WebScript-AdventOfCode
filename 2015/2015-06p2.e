/*
 * Light Grid. How many lit-and brightness?
turn on 0,0 through 999,999
toggle 0,0 through 999,0
//  94.2 seconds
 */
function String runme()
	List inputF, tList, sList
	integer count, Starter=Date.Tick(), countx, county
	integer x1, x2, y1, y2, tSum=0, sizer=0
	Assoc lights = Assoc.CreateAssoc()
	echo("Seeding...")
	for(countx=0;countx<=999;countx+=1)
 		for(county=0;county<=999;county+=1)
			lights.(Str.ValueToString(countx)+","+Str.ValueToString(county))=0
		end
	end
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2015\06-input.txt")
	for (count=1;count<=Length(inputF); count+=1)
		// Grab the coords. List - [2] is first, [4] is end
		tList = Str.Elements(inputF[count][6:], ' ')
		sList = Str.Elements(tList[2], ',')
		x1=Str.StringToInteger(sList[1])
		y1=Str.StringToInteger(sList[2])
		sList = Str.Elements(tList[4], ',')
		x2=Str.StringToInteger(sList[1])
		y2=Str.StringToInteger(sList[2])
		sizer=(y2-y1+1)*(x2-x1+1)
		if(inputF[count][:8]=="turn on ")
			tSum+=sizer
			for(countx=x1;countx<=x2;countx+=1)
				for(county=y1;county<=y2;county+=1)
					lights.(Str.ValueToString(countx)+","+Str.ValueToString(county))+=1
				end
			end
		elseif(inputF[count][:9]=="turn off ")
			for(countx=x1;countx<=x2;countx+=1)
				for(county=y1;county<=y2;county+=1)
					if(lights.(Str.ValueToString(countx)+","+Str.ValueToString(county))>0)
						tSum-=1
						lights.(Str.ValueToString(countx)+","+Str.ValueToString(county))-=1
					end
				end
			end
		else
			// Toggle
			tSum+=sizer*2
			for(countx=x1;countx<=x2;countx+=1)
				for(county=y1;county<=y2;county+=1)
					lights.(Str.ValueToString(countx)+","+Str.ValueToString(county))+=2
				end
			end
		end
	end
	echo(Str.ValueToString(tSum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
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
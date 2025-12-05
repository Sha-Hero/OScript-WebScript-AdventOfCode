/*
 * Count rolls with 3 or fewer adjacents
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
//  0.226 seconds
 */
function String runme()
    List inputF
	integer Starter=Date.Tick()
    Integer count, count2, tSum,sum=0
	Boolean isOne=false
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\04-input.txt")
    for(count=1;count<=Length(inputF);count+=1)
	    for(count2=1;count2<=Length(inputF[1]);count2+=1)
    		tSum=0
	    	isOne=false
	    	if(inputF[count][count2]=='@')
	    		isOne=true
				if(count2!=1)
	    			tSum+=inputF[count][count2-1]=='@'?1:0;
				end
				if(count2!=Length(inputF[1]))
	    			tSum+=inputF[count][count2+1]=='@'?1:0;
				end
	    		if(count!=1)
	    			tSum+=inputF[count-1][count2]=='@'?1:0;
					if(count2!=1)
		    			tSum+=inputF[count-1][count2-1]=='@'?1:0;
					end
					if(count2!=Length(inputF[1]))
		    			tSum+=inputF[count-1][count2+1]=='@'?1:0;
					end
				end
				if(count!=Length(inputF))
	    			tSum+=inputF[count+1][count2]=='@'?1:0;
					if(count2!=1)
		    			tSum+=inputF[count+1][count2-1]=='@'?1:0;
					end
					if(count2!=Length(inputF[1]))
		    			tSum+=inputF[count+1][count2+1]=='@'?1:0;
					end
				end
	    	end
	    	sum+=isOne&&tSum<4?1:0;
	    end
    end
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
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

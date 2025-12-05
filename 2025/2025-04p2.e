/*
 * Count rolls with 3 or fewer adjacents, remove, repeat
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
//  1.1 seconds
 */
// Pretty happy. Brute force with 2d list at 8 seconds, then changed to 
// sparse assocs to get some performance boost.
// Set the assoc undefined to 0 for simple addition - helps with edges.
// Use the xy coords as assoc keys.
function String runme()
    List inputF
	integer Starter=Date.Tick()
    Integer count, count2, tSum, sum=0
	Boolean first=true
    Assoc rolls =Assoc.CreateAssoc(), rolls2=Assoc.CreateAssoc()
	Assoc.UndefinedValue( rolls, 0 )
	Assoc.UndefinedValue( rolls2, 0 )
	echo("Starting...")
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\04-input.txt")
	// This is just brute force and likely could be cleaned up significantly.
	// but.. I'm competing against some others, so it'll do for now. :-D
	// Possible enhancement - load @ as assoc keys and delete. 
    for(count=1;count<=Length(inputF);count+=1)
	    for(count2=1;count2<=Length(inputF[1]);count2+=1)
	    	if(inputF[count][count2]=='@')
	    		rolls.(count*1000+count2)=1
	    	end
	    	
	    end
    end
	echo("Seeded...")
    integer c1m,c1p,c2m,c2p,c1,c2
    while(Length(rolls) != Length(rolls2))
    	if(first)
	    	rolls2 = Assoc.Copy(rolls)
    		first=false
    	end
    	rolls = Assoc.Copy(rolls2)
		for count in Assoc.Keys(rolls)
			c1=1000*(count/1000)
			c2=count%1000
			c1m=c1-1000
			c1p=c1+1000
			c2m=c2-1
			c2p=c2+1
			tSum=rolls.(c1m+c2m) + rolls.(c1m+c2) + rolls.(c1m+c2p) + rolls.(c1+c2m) + \
			rolls.(c1+c2p) + rolls.(c1p+c2m) + rolls.(c1p+c2) + rolls.(c1p+c2p)
			if(tSum<4)
				sum+=1
				Assoc.Delete(rolls2, (count))
			end
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

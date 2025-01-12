/*
 * Find area and perimeter of all.
RRRRIICCFF
RRRRIICCCF
VVRRRCCFFF
VVRCCCJFFF
VVVVCJJCFE
VVIVCCJJEE
VVIIICJJEE
MIIIIIJJEE
MIIISIJEEE
MMMISSJEEE
 * 1.1 seconds
 */
function String runme()
	List inputF, key, res, inners
	integer count=0, count2=0, Starter=Date.Tick(), sum=0, p=0
	Assoc a = Assoc.CreateAssoc()//, p = Assoc.CreateAssoc()
	String s, k
	boolean ul,uu,ur,sl,sr,dl,dd,dr
	ul=uu=ur=sl=sr=dl=dd=dr=false
	$curlist={}
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-12-input.txt")
	$height=Length(inputF); $width=Length(inputF[1])
	Assoc.UndefinedValue(a, {'-', {}})
	for (count=1; count<=$height; count+=1)
		for(count2=1; count2<=$width; count2+=1)
			a.({count, count2}) = {inputF[count][count2], {count, count2}}
		end
	end

	while Length(a)>0
		inners={}
		p=0
		key=a[1]
		res=price(a, key[1], key[2])
		// $curlist now has the whole list. Check for inners?
		for inners in $curlist
			uu=({inners[1]-1,inners[2]} in $curlist)?true:false;
			dd=({inners[1]+1,inners[2]} in $curlist)?true:false;
			if (uu||dd)
				sl=({inners[1],inners[2]-1} in $curlist)?true:false;
				sr=({inners[1],inners[2]+1} in $curlist)?true:false;
				if (sl||sr)
					ur=({inners[1]-1,inners[2]+1} in $curlist)?true:false;
					dl=({inners[1]+1,inners[2]-1} in $curlist)?true:false;
					dr=({inners[1]+1,inners[2]+1} in $curlist)?true:false;
					ul=({inners[1]-1,inners[2]-1} in $curlist)?true:false;
					if(!ul&&uu&&sl); p+=1; end
					if(uu&&!ur&&sr); p+=1; end
					if(sl&&!dl&&dd); p+=1; end
					if(dd&&!dr&&sr); p+=1; end
				end
			end
		end
		sum+=res[1]*(res[2]+p)
		for res in $curlist
			Assoc.Delete(a, res)
		end
		$curlist={}
	end
	// Let's iterate through the areas.
	echo("Answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function List price(Assoc v, String g, List coord)
	Integer y=coord[1], x=coord[2], tsum=1, psum=0
	List tlist={}
	Boolean u=true, d=true, l=true, r=true // to keep track of other plots.
	if coord in $curlist
		return {0,0}
	end
	v.(coord)={'.', coord}
	$curlist = List.SetAdd($curlist, coord)
	if(v.({y-1,x})[1] == g || v.({y-1,x})[1] == '.'); u=false; end;
	if(v.({y+1,x})[1] == g || v.({y+1,x})[1] == '.'); d=false; end;
	if(v.({y,x-1})[1] == g || v.({y,x-1})[1] == '.'); l=false; end;
	if(v.({y,x+1})[1] == g || v.({y,x+1})[1] == '.'); r=false; end;
	if(u&&l); psum+=1; end
	if(u&&r); psum+=1; end
	if(d&&l); psum+=1; end
	if(d&&r); psum+=1; end
	// Those are outer corners. We find the inners later.
	if(v.({y-1,x})[1] == g)
		tlist=price(v, g, {y-1,x})
		tsum+=tlist[1]
		psum+=tlist[2]
	end
	if(v.({y+1,x})[1] == g)
		tlist=price(v, g, {y+1,x})
		tsum+=tlist[1]
		psum+=tlist[2]
	end
	if(v.({y,x-1})[1] == g)
		tlist=price(v, g, {y,x-1})
		tsum+=tlist[1]
		psum+=tlist[2]
	end
	if(v.({y,x+1})[1] == g)
		tlist=price(v, g, {y,x+1})
		tsum+=tlist[1]
		psum+=tlist[2]
	end
	return {tsum, psum}
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
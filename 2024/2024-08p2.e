/* Repeating nodes.
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
 */
//  0.02 seconds
// 
function String runme()
	List inputF, plots={}, tl
	integer Starter=Date.Tick(), c, c2
	Assoc a = Assoc.CreateAssoc()
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-08-input.txt")
	integer height=Length(inputF), width=Length(inputF[1]), x, y, s1, s2
	
	for(c=1; c<=height; c+=1)
		for(c2=1; c2<=width; c2+=1)
			if(inputF[c][c2]!='.')
				if !IsDefined(a.(Str.ValueToString(Str.ASCII(inputF[c][c2]))))
					a.(Str.ValueToString(Str.ASCII(inputF[c][c2])))={{c, c2}}
				else
					// Already exists. Let's find the coords.
					plots = List.SetAdd(plots, {c, c2})
					for tl in a.(Str.ValueToString(Str.ASCII(inputF[c][c2])))
						plots = List.SetAdd(plots, {tl[1], tl[2]})
						y=Math.Abs(tl[1]-c); x=Math.Abs(tl[2]-c2)
						s1=y; s2=x
						if(tl[1]>=c && tl[2]>=c2) // bottom right
							while(tl[1]+s1 <=height && tl[2]+s2 <=width)
								plots = List.SetAdd(plots, {tl[1]+s1, tl[2]+s2})
								s1+=y; s2+=x
							end
							s1=y; s2=x
							while(c-s1 >0 && c2-s2 >0)
								plots = List.SetAdd(plots, {c-s1, c2-s2})
								s1+=y; s2+=x
							end
						elseif(tl[1]>=c && tl[2]<=c2) // bottom left
							while(tl[1]+s1 <=height && tl[2]-s2 >0)
								plots = List.SetAdd(plots, {tl[1]+s1, tl[2]-s2})
								s1+=y; s2+=x
							end
							s1=y; s2=x
							while(c-s1 >0 && c2+s2 <=width)
								plots = List.SetAdd(plots, {c-s1, c2+s2})
								s1+=y; s2+=x
							end
						elseif(tl[1]<=c && tl[2]>=c2) // top right
							while(tl[1]-s1 >0 && tl[2]+s2 <=width)
								plots = List.SetAdd(plots, {tl[1]-s1, tl[2]+s2})
								s1+=y; s2+=x
							end
							s1=y; s2=x
							while(c+s1 <=height && c2-s2 >0)
								plots = List.SetAdd(plots, {c+s1, c2-s2})
								s1+=y; s2+=x
							end
						elseif(tl[1]<=c && tl[2]<=c2) // top left
							while(tl[1]-s1 >0 && tl[2]-s2 >0)
								plots = List.SetAdd(plots, {tl[1]-s1, tl[2]-s2})
								s1+=y; s2+=x
							end
							s1=y; s2=x
							while(c+s1 <=height && c2+s2 <=width)
								plots = List.SetAdd(plots, {c+s1, c2+s2})
								s1+=y; s2+=x
							end
						end
					end
					a.(Str.ValueToString(Str.ASCII(inputF[c][c2])))+={{c, c2}}
				end
			end
		end
	end
	echo("There are this many anti-nodes: ", Length(plots))
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

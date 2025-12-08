/*
 * piece filter
 * Finding pieces natching criteria
 * px{a<2006:qkq,m>2090:A,rfg}
 * pv{a>1716:R,A}
 * lnx{m>1548:A,A}
 * rfg{s<537:gd,x>2440:R,A}
 * qs{s>3448:A,lnx}
 * qkq{x<1416:A,crn}
 * crn{x>2662:A,R}
 * in{s<1351:px,qqz}
 * qqz{s>2770:qs,m<1801:hdj,R}
 * gd{a>3333:R,R}
 * hdj{m>838:A,pv}
 *
 * {x=787,m=2655,a=1222,s=2876}
 * {x=1679,m=44,a=2067,s=496}
 * {x=2036,m=264,a=79,s=2244}
 * {x=2461,m=1339,a=466,s=291}
 * {x=2127,m=1623,a=2188,s=1013}
 * 0.03 s
 */
function String runme()
	Integer Starter=Date.Tick() // Start Tick
	List inputF, ratings, val, good={}
	Integer count, c2=1, c3, tcount=0
	Assoc workflows, pv
	String key, res, let
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\19-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		if inputF[count]==""
			break
		end
		key = inputF[count][:Str.Chr(inputF[count],'{')-1]
		workflows.(key)= CalcIt(inputF[count][Str.Chr(inputF[count],'{')+1:-2])
	end
	// Assume always x, m, a, s
	for (count+=1; count<=Length(inputF); count+=1)
		ratings[c2]= Str.StringToValue(Str.Strip(Str.ValueToString(Str.Elements(inputF[count][2:-2],",")),'xmas='))
		for (c3=1; c3<=4; c3+=1)
			ratings[c2][c3] = Str.StringToInteger(ratings[c2][c3])
		end
		c2+=1
	end
	// Loaded. Now let's iterate!
	for (count=1; count<=Length(ratings); count+=1)
		res = ""
		pv.x=ratings[count][1]; pv.m=ratings[count][2]; pv.a=ratings[count][3]; pv.s=ratings[count][4];
		key = "in"
		while res !="A" && res != "R"
			val = workflows.(key)
			for (c2=1; c2<=Length(val); c2+=1)
				if Type( val[c2] ) == stringType
					res = val[c2]
					if res == "A"
						//						echo ("Accepted: "+Str.String(count))
						for let in {'x','m','a','s'}
							tcount+= pv.(let)
						end
						good = {@good, Str.String(count)}
					elseif res == "R"
						//						echo ("Rejected: "+Str.String(count))
					else
						// New workflows.
						key = val[c2]
					end
					break;
				end
				if (val[c2][1][2] == ">")
					//					echo("Check if "+val[c2][1][1]+" is greater than: "+Str.String(val[c2][1][3])+" and it's: "+Str.String(pv.(val[c2][1][1])))
					if pv.(val[c2][1][1]) > val[c2][1][3]
						key=res=val[c2][2]
						if res == "A"
							//							echo ("Accepted: "+Str.String(count))
							for let in {'x','m','a','s'}
								tcount+= pv.(let)
							end
							good = {@good, Str.String(count)}
						end
						break
					end
				else
					//					echo("Check if "+val[c2][1][1]+" is less than: "+Str.String(val[c2][1][3])+" and it's: "+Str.String(pv.(val[c2][1][1])))
					if pv.(val[c2][1][1]) < val[c2][1][3]
						key=res=val[c2][2]
						if res == "A"
							for let in {'x','m','a','s'}
								tcount+= pv.(let)
							end
							good = {@good, Str.String(count)}
						end
						break
					end
				end
			end
		end
	end
	echo ("Total is: "+Str.String(tcount)+" Timing: "+Str.String(Date.Tick()-Starter)+" ticks.")
	return "Done"
end

function List CalcIt(String liner)
	List pieces = Str.Elements(liner,",")
	Integer elm
	String res
	res=pieces[-1]
	for (elm=Length(pieces)-1; elm>0; elm-=1)
		if res=="A" || res=="R"
			if pieces[elm][-1]==res
				// Means there's a duplicate. Shrink it!
				pieces[elm]=res
				pieces=pieces[:-2]
			else
				res = "N"
			end
		end
		// { { { 'x', '>', 12312 }, 'A' }, { { 'm', '<', 1200 }, 'A' }, 'R' }
		if Length(pieces[elm]) > 1
			pieces[elm] = Str.Elements(pieces[elm], ":")
			pieces[elm][1]= {pieces[elm][1][1], pieces[elm][1][2], Str.StringToInteger(pieces[elm][1][3:])}
		end
	end
	return pieces
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

/*
 * piece filter
 * Part 2: Finding ALL pieces matching criteria where
 * x, m, a, and s can be anything from 1 to 4000.
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
 * 0.06 s
 */
function String runme()
	Integer Starter=Date.Tick() // Start Tick
	List inputF
	Integer count, tcount, c2, c3
	Assoc ntryh= Assoc.CreateAssoc(), ntryl = Assoc.CreateAssoc()
	Integer vl
	String key, let
	Boolean kosher = TRUE
	$workflows = Assoc.CreateAssoc()
	$acclist = {}
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\19-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		if inputF[count]==""
			break
		end
		key = inputF[count][:Str.Chr(inputF[count],'{')-1]
		$workflows.(key)= CalcIt(inputF[count][Str.Chr(inputF[count],'{')+1:-2])
	end
	// Part 2 we don't need to load the pieces.
	// Want to iterate through the workflow, split for each check
	//   and build a list of "approved" value ranges.
	// Start with the "in" key.
	pathfinder("in", {})
	// Now... parse the results! Inefficient to do this twice.
	for (count=1; count<=Length($acclist); count+=1)
		ntryl.x=ntryl.m=ntryl.a=ntryl.s=1
		ntryh.x=ntryh.m=ntryh.a=ntryh.s=4000
		//		echo(Str.String($acclist[count]))
		for (c2=1; c2<=Length($acclist[count]); c2+=1)
			let = $acclist[count][c2][1]
			vl = $acclist[count][c2][3]
			if ($acclist[count][c2][2] == '>')
				vl+=1
				ntryl.(let)= ntryl.(let) <= vl ? vl : ntryl.(let)
			elseif ($acclist[count][c2][2] == '>=')
				ntryl.(let)= ntryl.(let) <= vl ? vl : ntryl.(let)
			elseif ($acclist[count][c2][2] == '<')
				vl-=1
				ntryh.(let)= ntryh.(let) >= vl ? vl : ntryh.(let)
			elseif ($acclist[count][c2][2] == '<=')
				ntryh.(let)= ntryh.(let) >= vl ? vl : ntryh.(let)
			end
		end
		c3 = 1
		for let in {'x','m','a','s'}
			if ntryh.(let) < ntryl.(let)
				// High is lower than low. Low is higher than high.
				c3=0;
				break
			end
			c3 *=  ntryh.(let) - ntryl.(let)+1
		end
		tcount += c3
	end
	echo ("Total is: "+Str.String(tcount)+" Timing: "+Str.String(Date.Tick()-Starter)+" ticks.")
	return "Done"
end

function void pathFinder(String inkey, List curneed)
	// Recursive function to find paths.
	List val = {}, good={}, alt
	Integer c2
	String res
	if inkey == "A"
		$acclist = { @$acclist, {curneed}}
		return
	elseif inkey == "R"
		// Rejected. Don't return anything.
		return
	end
	val = $workflows.(inkey)
	for (c2=1; c2<=Length(val); c2+=1)
		if Type( val[c2] ) == stringType
			res = val[c2]
			if res == "A"
				$acclist = { @$acclist, curneed}
			elseif res == "R"
				// Rejected. Don't return anything.
			else
				// New workflows.
				inkey = val[c2]
				pathfinder(val[c2], curneed)
			end
			break;
		end
		if (val[c2][1][2] == ">")
			inkey=res=val[c2][2]
			if res == "A"
				$acclist = { @$acclist, {@curneed, val[c2][1]}}
			elseif res == "R"
				// Rejected. Don't return anything.
			else
				pathfinder(inkey, {@curneed, val[c2][1]})
			end
			// It's splitting. We'll continue with the opposite
			curneed = {@curneed, {val[c2][1][1], '<=', val[c2][1][3]}}
		else
			inkey=res=val[c2][2]
			if res == "A"
				$acclist = { @$acclist, {@curneed, val[c2][1]}}
			elseif res == "R"
				// Rejected. Don't return anything.
			else
				// It's splitting. We'll continue with the opposite
				pathfinder(inkey, {@curneed, val[c2][1]})
			end
			curneed = {@curneed, {val[c2][1][1], '>=', val[c2][1][3]}}
		end
	end
	return
end
function List CalcIt(String liner)
	// Clean the wf input.
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

/*
 * Biggest rectangle with two corners.
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
// 60 seconds
 */
function String runme()
	integer Starter=Date.Tick()
	echo("Starting...")
	List inputF
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2025\09-input.txt")
	List nList={}, tList, tListN, tListP, l1, l2, l3, l4
	Integer count, count2, sum=0, cntr
	Assoc dAssoc=Assoc.CreateAssoc({})
	String lastGreen, lastDir
	Boolean found=false, bk=false, kosher=false
	tList=Str.Elements(inputF[2], ',')
	tList={Str.StringToInteger(tList[1]),Str.StringToInteger(tList[2])}
	tListN=Str.Elements(inputF[3], ',')
	tListN={Str.StringToInteger(tListN[1]),Str.StringToInteger(tListN[2])}
	//ul, ur, dr, dl
	lastGreen='0001'
	lastDir='l'
//	lastGreen='1000'
//	lastDir='u'
	nList={{@tList,lastGreen}}
	inputF[Length(inputF)+1]=inputF[1]
	inputF[Length(inputF)+1]=inputF[2]
	for(count=3;count<=Length(inputF);count+=1)
		tListP=tList
		tList=tListN
		tListN=count==Length(inputF)?Str.Elements(inputF[1], ','):Str.Elements(inputF[count+1], ',');
		tListN={Str.StringToInteger(tListN[1]),Str.StringToInteger(tListN[2])}
		if(tListN[1]==tList[1])
			if(tListN[2]>tList[2])
				// Going up
				if(lastDir=='l')
					if(lastGreen[4]=='1')
						lastGreen='1011'
					elseif(lastGreen[1]=='1')
						lastGreen='0100'
					end
				elseif(lastDir=='r')
					if(lastGreen[3]=='1')
						lastGreen='0111'
					elseif(lastGreen[2]=='1')
						lastGreen='1000'
					end
				end
				lastDir='u'
			elseif(tListN[2]<tList[2])
				// Going down
				if(lastDir=='l')
					if(lastGreen[4]=='1')
						lastGreen='0010'
					elseif(lastGreen[1]=='1')
						lastGreen='1101'
					end
				elseif(lastDir=='r')
					if(lastGreen[3]=='1')
						lastGreen='0001'
					elseif(lastGreen[2]=='1')
						lastGreen='1110'
					end
				end
				lastDir='d'
			end
		elseif(tListN[2]==tList[2])
			if(tListN[1]>tList[1])
				// Going right
				if(lastDir=='u')
					if(lastGreen[1]=='1')
						lastGreen='1101'
					elseif(lastGreen[2]=='1')
						lastGreen='0010'
					end
				elseif(lastDir=='d')
					if(lastGreen[4]=='1')
						lastGreen='1011'
					elseif(lastGreen[3]=='1')
						lastGreen='0100'
					end
				end
				lastDir='r'
			elseif(tListN[1]<tList[1])
				// Going left
				if(lastDir=='d')
					if(lastGreen[3]=='1')
						lastGreen='0111'
					elseif(lastGreen[4]=='1')
						lastGreen='1000'
					end
				elseif(lastDir=='u')
					if(lastGreen[1]=='1')
						lastGreen='0001'
					elseif(lastGreen[2]=='1')
						lastGreen='1110'
					end
				end
				lastDir='l'
			end
		end
		nList+={{@tList, lastGreen}}
	end
	// 
	echo("Finding possible rectangles : "+Str.String(Date.Tick()-Starter)+" ticks")
	for(count=1;count<Length(nList);count+=1)
		for(count2=count+1;count2<=Length(nList);count2+=1)
			// Modify to check open directions
			if(nList[count][1]>nList[count2][1])
				// farther right
				if(nList[count][2]>nList[count2][2])
					// up and right
					if(nList[count][3][4]=='1'&&nList[count2][3][2]=='1')
						kosher=true
					end
				elseif(nList[count][2]<nList[count2][2])
					// down and right
					if(nList[count][3][1]=='1'&&nList[count2][3][3]=='1')
						kosher=true
					end
				end
			elseif(nList[count][1]<nList[count2][1])
				// farther left
				if(nList[count][2]>nList[count2][2])
					// up and left
					if(nList[count][3][3]=='1'&&nList[count2][3][1]=='1')
						kosher=true
					end
				elseif(nList[count][2]<nList[count2][2])
					// down and left
					if(nList[count][3][2]=='1'&&nList[count2][3][4]=='1')
						kosher=true
					end
				end
			end
			if(kosher)
				cntr=(Math.ABS(nList[count][1]-nList[count2][1])+1) * \
					(Math.ABS(nList[count][2]-nList[count2][2])+1)
				dAssoc.(cntr)+={List.Sort({nList[count],nList[count2]})}
				kosher=false
			end
		end
	end
	echo("Finding longest kosher one : "+Str.String(Date.Tick()-Starter)+" ticks")
	// Now go through the points 
	found=false
	for count in List.Sort(Assoc.Keys(dAssoc), List.Descending)
		for(count2=1;count2<=Length(dAssoc.(count));count2+=1)
			tListP=nList[1]
			for tList in nList[2:]
				if(tList==dAssoc.(count)[count2][1]||tList==dAssoc.(count)[count2][2])
					// it's one of the points
					continue
				end
				l1=List.Sort({dAssoc.(count)[count2][1][1], dAssoc.(count)[count2][2][1]})
				l2=List.Sort({dAssoc.(count)[count2][1][2], dAssoc.(count)[count2][2][2]})
				l3=List.Sort({tListP[1], tList[1]})
				l4=List.Sort({tListP[2], tList[2]})
				if(tList[1]>l1[1]&&tList[1]<l1[2]&&tList[2]>l2[1]&&tList[2]<l2[2])
					// Inside, so this block is disqualified
					count2=Length(dAssoc.(count))+1
					bk=true
					break
				elseif((l3[1]<l1[1]&&l3[2]>l1[2]&&l4[1]>l2[1]&&l4[2]<l2[2]) || \
					(l3[1]>l1[1]&&l3[2]<l1[2]&&l4[1]<l2[1]&&l4[2]>l2[2]))
					// Inside, so this block is disqualified
					count2=Length(dAssoc.(count))+1
					bk=true
					break
				end
				// Check also if points go through this.
				tListP=tList
			end
			if(!bk)
				found=true
				sum=count
				break;
			else
				bk=false
			end
		end
		if(found);break;end;
	end
	echo(Str.ValueToString(sum)+" : "+Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end
// Load the file
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

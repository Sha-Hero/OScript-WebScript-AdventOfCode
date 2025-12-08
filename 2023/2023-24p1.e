/*
 * Intersecting line segments
 * Numbers were too high for oscript to handle them with traditional. y=mx+b.
 * Uses minimum distance from point to line (https://paulbourke.net/geometry/pointlineplane/)
 * 19, 13, 30 @ -2,  1, -2
 * 18, 19, 22 @ -1, -1, -2
 * 20, 25, 34 @ -2, -2, -4
 * 12, 31, 28 @ -1, -2, -1
 * 20, 19, 15 @  1, -5, -3
 * between 7 and 27
 * 0.18 s
 */
function String runme()
	// Load in the data and see where intersections occur (if any)
	List inputF, oneline, points = {}
	integer Starter=Date.Tick()
	integer totes = 0, hbound = 400000000000000, lbound = 200000000000000
	inputF=Loaddata("Z:\AdventOfCode\Inputs\2023\24-input.txt")
	integer bean = 0, i ,j
	real x1, x2, x3, x4, y1, y2, y3, y4, x, y, denom, ua
	//compare lines to one another
	for (i = 1; i < Length(inputF); i+=1) 
		x1 = inputF[i][1]
		x2 = inputF[i][4] + x1;
		y1 = inputF[i][2]
		y2 = inputF[i][5] + y1;
		for ( j = i + 1; j <= Length(inputF); j+=1) 
			x3 = inputF[j][1]
			x4 = inputF[j][4] + x3;
			y3 = inputF[j][2]
			y4 = inputF[j][5] + y3;
			denom = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)
			if (denom != 0)
				ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denom
				x = x1 + ua * inputF[i][4]
				y =  y1 + ua * inputF[i][5]
				//check event happens in the future    
				if ((x > x1) == ((x2 - x1) > 0)) && ((y > y1) == ((y2 - y1) > 0)) && \
						((x > x3) == ((x4 - x3) > 0)) && ((y > y3) == ((y4 - y3) > 0)) && \
						(x >= lbound) && (x <= hbound) && (y >= lbound) && (y <= hbound) 
					bean+=1
				end
			end
		end
	end
	echo(Str.Format("Answer part 1: %1. ", bean)+Str.String(Date.Tick()-Starter)+" ticks")
end

// Load the file.
function List loadData(String path)
	List incoming, tlist = {}
	String s, t
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			tlist = {}
			for t in Str.Elements(Str.Strip(Str.Replace(s,'@',','),' '),',')
				tlist = { @tlist, Str.StringToInteger(t)}
			end
			incoming = { @incoming, tlist }
		end
	end
	return incoming
end

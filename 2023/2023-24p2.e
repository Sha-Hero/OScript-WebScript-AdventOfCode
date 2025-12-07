/*
 * Intersecting line segments
 * Numbers were too high for oscript to handle them with traditional.
 * ARG! Can globalise a script but cannot access it as a global.
 * 19, 13, 30 @ -2,  1, -2
 * 18, 19, 22 @ -1, -1, -2
 * 20, 25, 34 @ -2, -2, -4
 * 12, 31, 28 @ -1, -2, -1
 * 20, 19, 15 @  1, -5, -3
 * between 7 and 27
 */
function String runme()
	// Load in the data and see where intersections occur (if any)
	getMath()
	List inputF
	integer Starter=Date.Tick()
	inputF=Loaddata("C:\AdventOfCodeInputs\2023\24-input.txt")
	// Turns out only need the first three hailstones to find the line!
	// NUMBERS ARE TOO BIG FOR OSCRIPT. Take different approach... Convert to strings?
	List a, b, c, va, vb, vc, x
	List tlist, J1, K1, J2, K2, J, K
	String answer
	a=inputF[1][1:3]
	va=inputF[1][4:6]
	b=inputF[2][1:3]
	vb=inputF[2][4:6]
	c=inputF[3][1:3]
	vc=inputF[3][4:6]
	
	//# Let our 6 unknowns be: p = (x, y, z) and v = (vx, vy, vz)
	//# Solve the linear system of 6 equations given by:
	//#
	//#   (p - a) X (v - va) == (p - b) X (v - vb)
	//#   (p - a) X (v - va) == (p - c) X (v - vc)
	//#
	//# Where X represents the vector cross product.

	tlist = get_equations(a, va, b, vb)
	J1=tlist[1]; K1 =tlist[2]
	tlist = get_equations(a, va, c, vc)
	J2=tlist[1]; K2 = tlist[2]
	J = {@J1, @J2}
	K = {@K1, @K2}
	// echo(matrix_inverse(J))
	x = matrix_mul(matrix_inverse(J), K)
	answer = $$bm.a("bigAdd", x[1], $$bm.a("bigAdd", x[2], x[3]))
	echo('Sum is: '+answer+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
end

function List matrix_transpose(List m)
	List newlist={}, tlist = {}
	Integer i, j
	for(i=1; i<=Length(m[1]); i+=1)
		tlist = {}
		for(j=1; j<=Length(m); j+=1)
			tlist = { @tlist, m[j][i]}
		end
		newlist = { @newlist, tlist }
	end
	return newlist
end

function List matrix_minor(List m, Integer i, Integer j)
	// returns a list missing the i-th element of m, and the j-th element of the remaining list.
	List row = {}
	Integer c
	if(i==1)
		m = m[2:]
	elseif(i==Length(m))
		m = m[1:i-1]
	else
		m = m[1:i-1]+m[i+1:]
	end
	for (c=1; c<=Length(m); c+=1)
		if(j==1)
			row = { @row, m[c][2:]}
		elseif(j==Length(m[c]))
			row = { @row, m[c][1:j-1]}
		else
			row = { @row, m[c][1:j-1]+m[c][j+1:]}
		end
	end
	return row
end

function String matrix_det(List m)
	String determinant, a, b
	String ta, tb //readability
	integer c
	if Length(m) == 2
		a = $$bm.a("bigMul", m[1][1], m[2][2])
		b = $$bm.a("bigMul", m[1][2], m[2][1])
		return $$bm.a("bigSub", $$bm.a("bigMul", m[1][1], m[2][2]), $$bm.a("bigMul", m[1][2], m[2][1]) )
	end
	determinant = "0"
	for (c=1; c<=Length(m); c+=1)
		ta = $$bm.a("bigMul", m[1][c], matrix_det(matrix_minor(m, 1, c)))
		tb = $$bm.a("bigMul", Str.ValueToString(Math.Power(-1, c-1))[2:], ta)
		determinant = $$bm.a("bigAdd", determinant, tb)
	end
	return determinant
end


function List matrix_mul(List m, List vec)
	List res = {}, row
	Integer i
	String summer
	for row in m
		summer = "0"
		for(i=1; i<=Length(row); i+=1)
			summer = $$bm.a("bigAdd", summer, $$bm.a("bigMul", row[i], vec[i]))
		end
		res = { @res, summer }
	end
	return res
end

//# Adapted from: https://stackoverflow.com/a/39881366/3889449
function List matrix_inverse(List m)
	List row, minor
	Integer r, c
	String determinant = matrix_det(m), ta, tb
	List cofactors = {}

	for (r=1; r<=Length(m); r+=1)
		row = {}
		for (c=1; c<=Length(m); c+=1)
			minor = matrix_minor(m, r, c)
			row = { @row, ( $$bm.a("bigMul", Str.ValueToString(Math.Power(-1, ((r-1) + (c-1)) )), matrix_det(minor))) }
		end
		cofactors = {@cofactors, row }
	end
	cofactors = matrix_transpose(cofactors)

	for (r=1; r<=Length(cofactors); r+=1)
		for (c=1; c<=Length(cofactors); c+=1)
			cofactors[r][c] = $$bm.a("bigDiv", cofactors[r][c], determinant, 30)
		end
	end

	return cofactors
end

function List vector_diff(List a, List b)
	return {$$bm.a("bigSub", a[1], b[1]), $$bm.a("bigSub", a[2], b[2]), $$bm.a("bigSub", a[3], b[3])}
end

function List get_equations(List a, List va, List b, List vb)
	//# Return the coefficient matrix (A) and the constant terms vector (B) for
	//# the 3 equations given by:
	//#
	//#   (p - a) X (v - va) == (p - b) X (v - vb)
	List tlist = {}, biga, bigb
	String dx, dy, dz, dvx, dvy, dvz
	tlist = vector_diff(a, b)
	dx=tlist[1]; dy=tlist[2]; dz=tlist[3]
	tlist = vector_diff(va, vb)
	dvx=tlist[1]; dvy=tlist[2]; dvz=tlist[3]

	biga = {
			 {"0", $$bm.a("bigMul", dvz, "-1"), dvy, "0", $$bm.a("bigMul", dz, "-1"), dy},
			 {dvz, "0", $$bm.a("bigMul", dvx, "-1"), dz, "0", $$bm.a("bigMul", dx, "-1")},
			 {$$bm.a("bigMul", dvy, "-1"), dvx, "0", $$bm.a("bigMul", dy, "-1"), dx, "0"}
		   }

	bigb = {
			 $$bm.a("bigSub", $$bm.a("bigSub", $$bm.a("bigMul", b[2], vb[3]), $$bm.a("bigMul", b[3], vb[2])), ($$bm.a("bigSub", $$bm.a("bigMul", a[2], va[3]), $$bm.a("bigMul", a[3], va[2])))),
			 $$bm.a("bigSub", $$bm.a("bigSub", $$bm.a("bigMul", b[3], vb[1]), $$bm.a("bigMul", b[1], vb[3])), ($$bm.a("bigSub", $$bm.a("bigMul", a[3], va[1]), $$bm.a("bigMul", a[1], va[3])))),
			 $$bm.a("bigSub", $$bm.a("bigSub", $$bm.a("bigMul", b[1], vb[2]), $$bm.a("bigMul", b[2], vb[1])), ($$bm.a("bigSub", $$bm.a("bigMul", a[1], va[2]), $$bm.a("bigMul", a[2], va[1]))))
		   }

	return {biga, bigb}
end

// Load the file.
function List loadData(String path)
	List incoming, tlist = {}
	String s, t
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr); s!=File.E_Eof; s=File.Read(fr))
			tlist = Str.Elements(Str.Strip(Str.Replace(s,'@',','),' '),',')
			incoming = { @incoming, tlist }
		end
	end
	return incoming
end
function void getMath()
	file fr=File.Open( "C:\AdventOfCodeSupport\BigMath.e", File.ReadMode )
	string hellooo = "", s
	if (!IsError(fr))
		for (s=File.Read(fr, 65535); s!=File.E_Eof; s=File.Read(fr, 65535))
			hellooo += Str.EOL()+s
		end
		File.Close( fr )
	end
	$$bm=Assoc.CreateAssoc()
	$$bm.a=Compiler.Compile( hellooo )
	return
end
/*
 * Find how many button presses.
Button A: X+94, Y+34
Button B: X+22, Y+67
Prize: X=8400, Y=5400

Button A: X+26, Y+66
Button B: X+67, Y+21
Prize: X=12748, Y=12176

Button A: X+17, Y+86
Button B: X+84, Y+37
Prize: X=7870, Y=6450

Button A: X+69, Y+23
Button B: X+27, Y+71
Prize: X=18641, Y=10279
 * 0.006 seconds!
 */
function String runme()
	List inputF, ba={}, bb={}, p={}
	integer count=0, Starter=Date.Tick(), sum=0
	real xa, ya, xb, yb, xt, yt, butta, buttb
	integer p2offset = 0

	// Part 2 only
	p2offset = 10000000000000 // only for part2!

	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-13-input.txt")
	for (count=1; count<=Length(inputF); count+=4)
		ba=Str.Elements(inputF[count],'+')
		bb=Str.Elements(inputF[count+1], '+')
		p=Str.Elements(inputF[count+2], '=')
		xa=Str.StringToInteger(ba[2][:-4])
		ya=Str.StringToInteger(ba[3])
		xb=Str.StringToInteger(bb[2][:-4])
		yb=Str.StringToInteger(bb[3])
		xt=Str.StringToInteger(p[2][:-4])+p2offset
		yt=Str.StringToInteger(p[3])+p2offset
		butta = (xb*yt - yb*xt) / (xb*ya - yb*xa)
		buttb = (xt-xa*butta) / xb
		if (Math.abs(butta-Math.round(butta))==0) && \
				(Math.abs(buttb-Math.round(buttb))==0)
			sum+=3*butta+buttb	
		end
	end
	echo("Answer: "+Str.String(sum)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return "Done!"
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

/*
 * Race. Longer pause, faster vehicle. Max distance.
 * How many seconds to pass the bottom number?
 * Simpe math.
 * Time:      7  15   30
 * Distance:  9  40  200
 * 37.6 s
 */
function String runme()
	// This worked, but alternate would be find from edges in.
	integer time = 71530, Starter=Date.Tick()
	integer distance = 940200
	time = 49979494
	distance = 263153213781851
	integer count=0, scount=0
	integer tdist = 0
	for (count=0; count<=time; count+=1)
		tdist=(time-count)*count
		if tdist > distance; scount+=1; end;
	end
	echo('Answer: '+Str.String(scount)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return Str.String(scount)
end

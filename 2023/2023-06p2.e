/*
 * Race. Longer pause, faster vehicle. Max distance.
 * How many seconds to pass the bottom number?
 * Simple math.
 * Time:      7  15   30
 * Distance:  9  40  200
 * 16 s
 * // Start in the middle, count until miss, sub one.
 */
function String runme()
	// This worked, but alternate would be find from edges in.
	integer time = 71530, Starter=Date.Tick()
	integer distance = 940200
	time = 49979494
	distance = 263153213781851
	integer count=0, scount=0
	integer tdist = 0
	for (count=time/2; count>=0; count-=1)
		tdist=(time-count)*count
		if tdist > distance; scount+=2; else; break; end;
	end
	scount-=1;
	echo('Answer: '+Str.String(scount)+' timing: '+Str.String(Date.Tick()-starter)+' ticks.')
	return Str.String(scount)
end

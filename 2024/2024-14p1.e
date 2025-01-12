/*
 * Find where robots are after 100 seconds.
p=0,4 v=3,-3
p=6,3 v=-1,-3
p=10,3 v=-1,2
p=2,0 v=2,-1
p=0,0 v=1,3
p=3,0 v=-2,-2
p=7,6 v=-1,-3
p=3,0 v=-1,-2
p=9,3 v=2,3
p=7,3 v=-1,2
p=2,4 v=2,-3
p=9,5 v=-3,-3
 * 0.008 seconds!
 */
function String runme()
	List inputF, nums={}
	integer count=0, Starter=Date.Tick(), sum=0
	integer x, y, vx, vy, nx, ny
	integer q1=0, q2=0, q3=0, q4=0
	integer width=101, height=103
	String  search = "[!@-0-9]*<-*[0-9]+>,<-*[0-9]+>[!@-0-9]+<-*[0-9]+>,<-*[0-9]+>"
	PatFind finder = Pattern.CompileFind( search )
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-14-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		nums=Pattern.Find( inputF[count], finder )
		x=Str.StringToInteger(nums[4])+1 // 1-based arrays!
		y=Str.StringToInteger(nums[5])+1
		vx=Str.StringToInteger(nums[6])
		vy=Str.StringToInteger(nums[7])
		nx=((x+vx*100)%width); nx=nx==0?width:nx; // 1-based again. :-P
		nx=nx<0?nx+=width:nx;
		ny=((y+vy*100)%height); ny=ny==0?height:ny; // 1-based again. :-P
		ny=ny<0?ny+=height:ny;
		if(nx<=(width/2) && ny<=(height/2)); q1+=1
		elseif(nx<=(width/2) && ny>=((height/2)+2)); q2+=1
		elseif(nx>=((width/2)+2) && ny<=(height/2)); q3+=1
		elseif(nx>=((width/2)+2) && ny>=((height/2)+2)); q4+=1
		end
	end
	sum = q1*q2*q3*q4
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

/*
 * Find a tree? Going to guess there are no overlaps..?
 * OMG!! It worked!
 * OK - mathematically, can see there are 101 and 103 cycles.
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
 * 15.5 seconds!
 */
function String runme()
	List inputF, nums={}
	Assoc robotP=Assoc.CreateAssoc()
	Assoc robotV=Assoc.CreateAssoc()
	integer count=0, Starter=Date.Tick(), sum=0
	integer x, y, vx, vy, nx, ny
	integer q1=0, q2=0, q3=0, q4=0
	integer width=101, height=103
	Dynamic key
	String  search = "[!@-0-9]*<-*[0-9]+>,<-*[0-9]+>[!@-0-9]+<-*[0-9]+>,<-*[0-9]+>"
	PatFind finder = Pattern.CompileFind( search )
	inputF=Loaddata("C:\AdventOfCodeInputs\2024\2024-14-input.txt")
	for (count=1; count<=Length(inputF); count+=1)
		nums=Pattern.Find( inputF[count], finder )
		x=Str.StringToInteger(nums[4])+1 // 1-based arrays!
		y=Str.StringToInteger(nums[5])+1
		vx=Str.StringToInteger(nums[6])
		vy=Str.StringToInteger(nums[7])
		robotP.(count) = { x, y}
		robotV.(count) = { vx, vy}
	end
	// Loaded. Let's iterate.
	while(Length(Assoc.Items(robotP)) != Length(Set.ToList(Set.FromList(Assoc.Items(robotP)))))
		// Testing whether the list of values is unique. Assoc values --> set --> list will remove dups.
		for key in Assoc.Keys(robotP)
			nx=((robotP.(key)[1]+robotV.(key)[1])%width); nx=nx==0?width:nx; // 1-based again. :-P
			robotP.(key)[1]=nx<0?nx+=width:nx;
			ny=((robotP.(key)[2]+robotV.(key)[2])%height); ny=ny==0?height:ny; // 1-based again. :-P
			robotP.(key)[2]=ny<0?ny+=height:ny;
		end
		sum+=1
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

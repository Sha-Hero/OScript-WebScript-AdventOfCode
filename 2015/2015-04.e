/*
 * MD5 that has five leading zeroes
bgvyzdsv
* // 0.659/2.6 seconds
 */
function String runme()
	String inputF='bgvyzdsv', chek
	integer count=0, Starter=Date.Tick(), len
	boolean p1=false
	chek=p1?"00000":"000000";
	len=p1?5:6;
	while(1)
		count+=1
		if(Security.Hash(inputF+Str.ValueToString(count), Security.MD5)[:len]==chek)
			echo("Gotcha at: "+Str.ValueToString(count))
			break;
		end
	end
	echo(Str.String(Date.Tick()-Starter)+" ticks")
	return "Done!"
end
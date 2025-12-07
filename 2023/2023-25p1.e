/*
 * Attached components, split into two groups with three cuts.
 * jqt: rhn xhk nvd
 * rsh: frs pzl lsr
 * xhk: hfx
 * cmg: qnr nvd lhk bvb
 * rhn: xhk bvb hfx
 * bvb: xhk hfx
 * pzl: lsr hfx nvd
 * qnr: nvd
 * ntq: jqt hfx bvb xhk
 * nvd: lhk
 * lsr: lhk
 * rzs: qnr cmg lsr rsh
 * frs: qnr lhk lsr
*/
function String runme()
	// Load in the data and see where intersections occur (if any)
	integer Starter=Date.Tick(), sumret, topcount=-1
	String key, topkey
	List scopy
	$S = {}
	$input = Assoc.CreateAssoc()
	$inputlen = Assoc.CreateAssoc()
	Loaddata("C:\AdventOfCodeInputs\2023\25-inputsmall.txt")
	echo("Input is: "+Str.ValueToString($input))
	$S = Assoc.Keys($input)
	echo("Keys are: "+Str.ValueToString($S))
	// JAvascript code
	sumret = sumMap()
	while (sumret != 3)
		scopy=List.SetUnion($S, {})
		topcount=-1;topkey=''
//		echo(Str.Format("S, count and sum map is : %1, %2", [...S], count, sumMap());
		// Find the key with the max count
		for key in scopy
			if count(key) > topcount
				topcount = count(key)
				topkey = key
			end
		end
		scopy = List.SetRemove(scopy, topkey)
//		const maxKey = [...S].reduce((a, b) => count(a) > count(b) ? a : b);
//		S.delete(maxKey);
		sumret = sumMap()
//	echo(sumret)
	end

		/*

// While loop equivalent

// Final result calculation
const remainingNodes = [...S];
const remainingNeighbors = new Set();

// Collect unique neighbors for all remaining nodes
remainingNodes.forEach(node => {
  G.get(node).forEach(neighbor => {
    remainingNeighbors.add(neighbor);
  });
});

const result = remainingNodes.length * remainingNeighbors.size;
console.log(result);

	*/
	
	echo(Str.Format("Answer: %1. ", $cntA * $cntB)+Str.String(Date.Tick()-Starter)+" ticks")
end

// Sum function for the map
function integer sumMap()
	List scopy = $S
	String key
	Integer sum = 0
	for key in scopy
		sum += count(key)
	end
	return sum
end
// Count function for each key
function integer count(String v)
	List neighbors = $input.(v)
	integer len = 0
	String node
	for node in neighbors
		if !(node in $S)
//			echo(Length($S))
			len += 1
		end
	end
	return len
end

// Load the file.
function void loadData(String path)
	String s, t
	File fr = File.open(path, File.ReadMode)
	if (!IsError(fr))
		for (s=File.Read(fr);s!=File.E_Eof;s=File.Read(fr))
			if !Assoc.IsKey($input, s[:3])
				$input.(s[:3]) = {}
				$inputlen.(s[:3]) = 0
			end
			for t in Str.Elements(s[6:],' ')
				if !Assoc.IsKey($input, t)
					$input.(t) = {}
					$inputlen.(t) = 0
				end
				$input.(s[:3]) = { @$input.(s[:3]), t}
				$input.(t) = { @$input.(t), s[:3]}
				$inputlen.(s[:3]) += 1
				$inputlen.(t) += 1
			end
		end
	end
	return
end

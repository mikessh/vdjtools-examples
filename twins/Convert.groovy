new File(args[0][1..-1]).withPrintWriter { pw ->
    new File(args[0]).splitEachLine("\t") { List<String> splitLine ->
	if (splitLine.size() < 7) {
    	    splitLine=[splitLine, "."].flatten()
        } else if (splitLine[6] == "NA") {
    	    splitLine[6] = "."
	}

	pw.println([splitLine[0..4],splitLine[6],splitLine[5]].flatten().join("\t"))
    }
}
# point the vdjtools executable
VDJTOOLS="java -Xmx8G -jar vdjtools-1.0-SNAPSHOT.jar"

# shows higher clonality for MS samples
$VDJTOOLS RarefactionPlot -m metadata.txt -l sample_id -f state diversity/
$VDJTOOLS CalcDiversityStats -metadata.txt diversity/

# shows the private nature of MS clonotypes
$VDJTOOLS BatchIntersectPair -m metadata.txt /overlap/
$VDJTOOLS BatchIntersectPairPlot -f state overlap/

# shows HSCT-induced changes for MS8 in more details
$VDJTOOLS IntersectPair -p ../samples/MS8.txt.gz ../samples/MS14.txt.gz overlap/

# shows V usage level trends and cluster samples
$VDJTOOLS BatchIntersectPairPlot -m vJSD -f state overlap/ vusage/
$VDJTOOLS CalcSegmentUsage -m metadata.txt -p -f state vusage/
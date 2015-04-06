# point the vdjtools executable
VDJTOOLS="java -Xmx20G -jar ../vdjtools-1.0-SNAPSHOT.jar"

# shows higher clonality for MS samples
$VDJTOOLS RarefactionPlot -m metadata.txt -l sample_id -f state diversity/
$VDJTOOLS CalcDiversityStats -m metadata.txt diversity/
# replicate Fig2b
cd diversity/
Rscript ../diversity_post.R
cd ..

# shows the private nature of MS clonotypes
# naive analysis shows batch bias
$VDJTOOLS CalcPairwiseDistances -m metadata.txt overlap/
$VDJTOOLS ClusterSamples -p -f lane overlap/ overlap/lane
$VDJTOOLS TestClusters overlap/lane overlap/lane
# real state of things
$VDJTOOLS CalcPairwiseDistances -i aa!nt -m metadata.txt overlap/
$VDJTOOLS ClusterSamples -p -f state -i aa!nt overlap/ overlap/state
$VDJTOOLS TestClusters -i aa!nt overlap/state overlap/state

# shows V usage level trends and cluster samples
$VDJTOOLS CalcSegmentUsage -m metadata.txt -p -f state vusage/

# shows HSCT-induced changes for MS8 in more details
$VDJTOOLS OverlapPair -p ../samples/MS8.txt.gz ../samples/MS14.txt.gz hsct/
$VDJTOOLS PlotFancyVJUsage ../samples/MS8.txt.gz hsct/MS8
$VDJTOOLS PlotFancyVJUsage ../samples/MS14.txt.gz hsct/MS8-HSCT


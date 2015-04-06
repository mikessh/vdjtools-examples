# point vdjtools executable
VDJTOOLS="java -Xmx20G -jar ../vdjtools-1.0-SNAPSHOT.jar"

# demonstrate  basic analysis
$VDJTOOLS CalcBasicStats -m metadata.txt out/0
$VDJTOOLS CalcSpectratype -m metadata.txt out/1
$VDJTOOLS CalcSegmentUsage -m metadata.txt -p -f age -n out/2
$VDJTOOLS PlotFancySpectratype ../samples/A4-i125.txt.gz out/3
$VDJTOOLS PlotSpectratypeV ../samples/A4-i125.txt.gz out/4
$VDJTOOLS PlotFancyVJUsage .../samples/A4-i125.txt.gz out/5

# demonstrate diversity estimates
$VDJTOOLS PlotQuantileStats ../samples/A4-i125.txt.gz out/6
$VDJTOOLS CalcDiversityStats -m metadata.txt out/7
$VDJTOOLS RarefactionPlot -m metadata.txt -f age -n -l sample.id out/8

# demonstrate sample overlap
$VDJTOOLS OverlapPair -p ../samples/A4-i189.txt.gz ../samples/A4-i190.txt.gz out/9
$VDJTOOLS CalcPairwiseDistances -m metadata.small.txt out/10
$VDJTOOLS ClusterSamples -p -f age -n -l sample.id out/10 out/10.age

# demonstrate database annotation
$VDJTOOLS ScanDatabase -m metadata.txt -f --filter "__origin__=~/EBV/" out/11

# demonstrate sample operations and filtering
$VDJTOOLS Decontaminate -m metadata.txt -c out/dec/
$VDJTOOLS Downsample -m metadata.txt -c -x 10000 out/ds/
$VDJTOOLS FilterNonFunctional -m metadata.txt -c out/nf/
$VDJTOOLS JoinSamples -p -m metadata.small.txt out/12
$VDJTOOLS PoolSamples -w -m metadata.small.txt out/13


######################
# For VDJtools paper #
######################

# Check for sex bias in clustering
$VDJTOOLS CalcPairwiseDistances -i aa!nt -m metadata.txt paper/
$VDJTOOLS ClusterSamples -p -f sex -i aa!nt -l sample.id paper/ paper/sex
$VDJTOOLS TestClusters -i aa!nt paper/sex

# Diversity estimate benchmark
$VDJTOOLS CalcDiversityStats -m metadata.txt paper/
cd paper
Rscript ../analyze.R
cd ..

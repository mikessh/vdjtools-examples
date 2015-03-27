# point vdjtools executable
VDJTOOLS="java -Xmx6G -jar ../vdjtools-1.0-SNAPSHOT.jar"

# demonstrate  basic analysis
$VDJTOOLS CalcBasicStats -m metadata.txt out/0
$VDJTOOLS CalcSpectratype -m metadata.txt out/1
$VDJTOOLS CalcSegmentUsage -m metadata.txt -p -f age -n out/2
$VDJTOOLS PlotFancySpectratype ../samples/A4-i125.txt.gz out/3
$VDJTOOLS PlotSpectratypeV ../samples/A4-i125.txt.gz out/4
$VDJTOOLS PlotFancyVJUsage .../samples/A4-i125.txt.gz out/5

# demonstrate diversity estiamtes
$VDJTOOLS PlotQuantileStats ../samples/A4-i125.txt.gz out/6
$VDJTOOLS CalcDiversityStats -m metadata.txt -x 5000 out/7
$VDJTOOLS RarefactionPlot -m metadata.txt -f age -n -l sample.id out/8

# demonstrate sample intersection
$VDJTOOLS IntersectPair -S mitcr -p ../samples/A4-i189.txt.gz ../samples/A4-i190.txt.gz out/9
$VDJTOOLS BatchIntersectPair -m metadata.txt out/10
$VDJTOOLS BatchIntersectPairPlot -f age -n -l sample.id out/10 out/10.age
$VDJTOOLS BatchIntersectPairPlot -m vJSD -f sex -l sample.id out/10 out/10.sex

# demonstrate database annotation
$VDJTOOLS ScanDatabase -m metadata.txt -f --filter "__origin__=~/EBV/" out/11

# demonstrate sample maniputaltion
$VDJTOOLS Decontaminate -m metadata.txt -c out/dec/
$VDJTOOLS Downsample -m metadata.txt -c -x 5000 out/ds/
$VDJTOOLS FilterNonFunctional -m metadata.txt -c out/nf/
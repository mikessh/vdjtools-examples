# point to vdjtools executable
VDJTOOLS="java -Xmx8G -jar ../vdjtools-1.0-SNAPSHOT.jar"

# perform basic analysis
$VDJTOOLS CalcBasicStats -m metadata.txt out/0
$VDJTOOLS CalcSpectratype -m metadata.txt out/1
$VDJTOOLS CalcSegmentUsage -m metadata.txt -p -f "Time post HSCT, months" -n out/2

# monitor diversity reconstitution
$VDJTOOLS CalcDiversityStats -m metadata.txt out/3
$VDJTOOLS RarefactionPlot -m metadata.txt -f "Time post HSCT, months" -n -l sample.id out/4

# clonotype tracking
$VDJTOOLS IntersectPair -p ../samples/minus48months.txt.gz ../samples/4months.txt.gz out/5
$VDJTOOLS IntersectSequential -m metadata.txt -f "Time post HSCT, months" -x 0 -p out/6

# check expansion of CMV/EBV clonotypes
$VDJTOOLS ScanDatabase -m metadata.txt -f --filter "__origin__.contains('CMV')||__origin__.contains('EBV')" out/7
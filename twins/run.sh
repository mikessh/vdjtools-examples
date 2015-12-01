# CAUTION
# really large datasets, protocol that doesn't use UMIs
wget http://labcfg.ibch.ru/tcrdata/MZTwins_txt.tar.gz
tar -zxvf MZTwins_txt.tar.gz
# Manually convert to VDJtools format
for f in Tw*.txt
do
   groovy Convert.groovy $f;
done
# compute similarity measures
java -Xmx40G -jar ../vdjtools.jar CalcPairwiseDistances -m metadata.txt -p .
# benchmark
Rscript analyze.R
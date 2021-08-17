#!/bin/bash
MONTH=$(date +"%b"| tr [a-z] [A-Z])
RELEASEDATE=$(date +"%d%H%MZ${MONTH}%y")

echo "Release date: ${RELEASEDATE}"

for DIR in ???; do
  egrep -v "^#" ${DIR}/CIV.txt >> tmp.txt
  egrep -v "^#" ${DIR}/LEO.txt >> tmp.txt
  egrep -v "^#" ${DIR}/MIL.txt >> tmp.txt
done

echo '#TAK ADSB IDs' > ${RELEASEDATE}.txt
echo '#Copyright 2021 Stefan Gofferje' >> ${RELEASEDATE}.txt
echo '#License: CC-BY-SA 4.0' >> ${RELEASEDATE}.txt
echo '#Format:' >> ${RELEASEDATE}.txt
echo '#"hexid","SIDC","registration","operator"' >> ${RELEASEDATE}.txt
echo >> ${RELEASEDATE}.txt
cat tmp.txt | sort | egrep -v "^$" >> ${RELEASEDATE}.txt
zip ${RELEASEDATE}.zip ${RELEASEDATE}.txt
rm tmp.txt ${RELEASEDATE}.txt

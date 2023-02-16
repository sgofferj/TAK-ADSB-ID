#!/bin/bash
MONTH=$(date +"%b"| tr [a-z] [A-Z])
RELEASEDATE=$(date +"%d%H%MZ${MONTH}%y")

echo "Release date: ${RELEASEDATE}"

for DIR in ???; do
  egrep -v "^#" ${DIR}/CIV.txt >> tmp.txt
  egrep -v "^#" ${DIR}/LEO.txt >> tmp.txt
  egrep -v "^#" ${DIR}/MIL.txt >> tmp.txt
  egrep -v "^#" ${DIR}/SPC.txt >> tmp.txt
done

cat tmp.txt | sed "s/\"//g" | \
jq -Rsn '
  {"aircraft":
    [inputs
     | . / "\n"
     | (.[] | select(length > 0) | . / ",") as $input
     | {"hexid": $input[0], "cot": $input[1], "reg": $input[2], "type": $input[3], "operator": $input[4]}]}
' >${RELEASEDATE}.json


echo '#TAK ADSB IDs' > ${RELEASEDATE}.txt
echo '#Copyright 2021 Stefan Gofferje' >> ${RELEASEDATE}.txt
echo '#License: CC-BY-SA 4.0' >> ${RELEASEDATE}.txt
echo '#Format:' >> ${RELEASEDATE}.txt
echo '#"hexid","SIDC","registration","type","operator"' >> ${RELEASEDATE}.txt
echo >> ${RELEASEDATE}.txt
cat tmp.txt | sort | egrep -v "^$" >> ${RELEASEDATE}.txt
zip ${RELEASEDATE}.zip ${RELEASEDATE}.txt ${RELEASEDATE}.json
rm tmp.txt ${RELEASEDATE}.txt ${RELEASEDATE}.json

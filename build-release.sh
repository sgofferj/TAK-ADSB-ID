#!/bin/bash
MONTH=$(date -u +"%b"| tr [a-z] [A-Z])
RELEASEDATE=$(date -u +"%d%H%MZ${MONTH}%y")

echo "RELEASE_TAG=${RELEASEDATE}"

echo > tmp.txt

for DIR in src/???; do
  egrep -hv "^#" ${DIR}/*.txt >> tmp.txt
done

sed -i "/^$/d" tmp.txt
sed -i "s/^\(\"......\"\)/\L\1/g" tmp.txt

sort tmp.txt > tmp_sorted.txt
mv tmp_sorted.txt tmp.txt

cat tmp.txt | jq -cnR 'reduce (inputs / "," | map(fromjson)) as $i ({}; .[$i[0]] = $i[1:])' > cotdb_indexed.json

cat tmp.txt | sed "s/\"//g" | \
jq -cRsn '
  {"aircraft":
    [inputs
     | . / "\n"
     | (.[] | select(length > 0) | . / ",") as $input
     | {"hexid": $input[0], "cot": $input[1], "reg": $input[2], "type": $input[3], "operator": $input[4]}
    ]
  }
' >cotdb.json

AIRCRAFT=$(jq '. | length' cotdb_indexed.json)

echo "AIRCRAFT=${AIRCRAFT}"

sed -i "s/\(message\=\)[0-9]*\&/\1${AIRCRAFT}\&/g" Readme.md

echo '#TAK ADSB IDs' > cotdb.txt
echo '#Copyright 2021 Stefan Gofferje' >> cotdb.txt
echo '#License: CC-BY-SA 4.0' >> cotdb.txt
echo '#Format:' >> cotdb.txt
echo '#"hexid","CoT type","registration","type","operator"' >> cotdb.txt
echo >> cotdb.txt
cat tmp.txt | sort | egrep -v "^$" >> cotdb.txt
rm tmp.txt 

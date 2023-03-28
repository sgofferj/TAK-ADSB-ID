#!/bin/bash
MONTH=$(date +"%b"| tr [a-z] [A-Z])
RELEASEDATE=$(date +"%d%H%MZ${MONTH}%y")

echo "Release date: ${RELEASEDATE}"

for DIR in src/???; do
  egrep -v "^#" ${DIR}/CIV.txt >> tmp.txt
  egrep -v "^#" ${DIR}/LEO.txt >> tmp.txt
  egrep -v "^#" ${DIR}/MIL.txt >> tmp.txt
  egrep -v "^#" ${DIR}/SPC.txt >> tmp.txt
done

sed -i "/^$/d" tmp.txt
grep -c , tmp.txt

cat tmp.txt | sort | \
jq -R '[split(",")[] | fromjson] |
       [{key: .[0], value: .[1:]}] |
       from_entries' | jq -s 'add' > cotdb_indexed.json

cat tmp.txt | sort | egrep -v "^$" | sed "s/\"//g" | \
jq -Rsn '
  {"aircraft":
    [inputs
     | . / "\n"
     | (.[] | select(length > 0) | . / ",") as $input
     | {"hexid": $input[0], "cot": $input[1], "reg": $input[2], "type": $input[3], "operator": $input[4]}
    ]
  }
' >cotdb.json

echo '#TAK ADSB IDs' > cotdb.txt
echo '#Copyright 2021 Stefan Gofferje' >> cotdb.txt
echo '#License: CC-BY-SA 4.0' >> cotdb.txt
echo '#Format:' >> cotdb.txt
echo '#"hexid","SIDC","registration","type","operator"' >> cotdb.txt
echo >> cotdb.txt
cat tmp.txt | sort | egrep -v "^$" >> cotdb.txt
#zip ${RELEASEDATE}.zip cotdb.txt cotdb.json  #disabled while I try to find a better way of packaging
rm tmp.txt cotdb.txt

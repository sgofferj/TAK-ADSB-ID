for FILE in src/*/*.txt; do
  sed -i "s/^\"\(.*\)\",\"a-f-A-M-V\",\"\(.*\)\",\"\(.*\)\"/\"\1\",\"a-f-A-M-F\",\"\2\",\"\3 VIP\"/g" ${FILE}
  sed -i "s/^\"\(.*\)\",\"a-n-A-M-V\",\"\(.*\)\",\"\(.*\)\"/\"\1\",\"a-n-A-M-F\",\"\2\",\"\3 VIP\"/g" ${FILE}
  sed -i "s/^\"\(.*\)\",\"a-h-A-M-V\",\"\(.*\)\",\"\(.*\)\"/\"\1\",\"a-h-A-M-F\",\"\2\",\"\3 VIP\"/g" ${FILE}
done

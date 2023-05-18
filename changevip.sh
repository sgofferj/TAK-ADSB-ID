for FILE in src/*/*.txt; do
  sed -i "s/^\"\(.*\)\",\"a-f-A-M-V\",\"\(.*\)\",\"\(.*\)\"/\"\1\",\"a-f-A-M-F\",\"\2\",\"\3 VIP\"/g" ${FILE}
done


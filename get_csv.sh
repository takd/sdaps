if [ ! -d "_csv" ]; then
mkdir _csv
fi
for d in ./_projektek/*/ ; do
    echo "mappa: $d"
    python ./sdaps.py "${d::-1}" csv export
    #mv "${d::-1}/data_1.csv" "./_csv/${d::-1}.csv"
done

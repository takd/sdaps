if [ ! -d "_csv" ]; then
mkdir _csv
fi
for d in _projektek/* ; do
    echo "mappa: $d"
    ./sdaps.py "$d" csv export
    mv "$d/data_1.csv" "./_csv/${d#*/}.csv"
done

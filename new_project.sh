#!/bin/bash
#Automatizáló szkript a konzultációs csoport SDAPS rendszeréhez
#Takács Donát 2017

#A _nyers könyvtár meglétének ellenőrzése
if [ ! -d "_nyers" ]; then
    echo 'Hiányzik a "_nyers" könyvtár! Létrehozom, töltsd fel a foldolgozandó .tif fájlokkal!'
    mkdir _nyers
    exit
fi

#Esemény időpontja
echo "Mikor történt az esemény? (ÉÉÉÉ-HH-NN)"
read -e datum

#Esemény típusa
echo "Konzultáció, vagy kurzus?"
select alkalom in "Konzultáció" "Kurzus" "Egyéb";
do
    break
done

#Esemémény tárgya
echo "Mi volt a tárgya?"
read -e targy

#tex-fájl kiválasztása az esemény típusa alapján
echo "$alkalom"
FAJL="_template/egyeb.tex"
if [ "$alkalom" = "Kurzus" ]; then
    FAJL="_template/kurzus.tex"
else
    FAJL="_template/konzultacio.tex"
fi

#satírozás
echo "Hogyan értelmezzük a satírozott mezőket? (Az x-el való megjelölés mindenképpen érvényes marad.)"
select satir in "A satírozás is megjelölésnek számít (ajánlott)" "A satírozás javításnak számít";
do
    break
done

echo "$satir"

#ellenőrzés
echo "------------------------------------------"
echo "A megadott adatok:"
echo "$alkalom $datum napon, $targy témájában"
if [ ! -d "_projektek" ]; then
mkdir _projektek
fi
MAPPA="_projektek/$alkalom-$datum-$targy"
echo "A projekt mappája: $MAPPA"
echo "A felhasznált kérdőív: $FAJL"
echo "$satir"
echo "------------------------------------------"
echo "Helyes adatok? (y/n)"
read -e helyese
if [ "$helyese" = "y" ]; then
    echo "Adatok megerősítve, projekt elkészítése..."
else
    echo "Művelet megszakítva."
    exit
fi

################################################
#Feladatok futtatása

#satírozás
if [ "$satir" = "A satírozás is megjelölésnek számít (ajánlott)" ]; then
    touch mindentelfogad
fi

#Az erre a kiértékelésre specifikus információk hozzáadása az összefoglaló-class új példányához
echo "\newcommand{\datum}{$datum}" | cat - tex/sdapsreport_base.cls > temp && mv temp tex/sdapsreport.cls
echo "\newcommand{\targy}{$targy}" | cat - tex/sdapsreport.cls > temp && mv temp tex/sdapsreport.cls
echo "\newcommand{\alkalom}{$alkalom}" | cat - tex/sdapsreport.cls > temp && mv temp tex/sdapsreport.cls
echo "\usepackage[utf8]{inputenc}" | cat - tex/sdapsreport.cls > temp && mv temp tex/sdapsreport.cls

#Projektkönyvtár elkészítése
./sdaps.py "$MAPPA" setup_tex "$FAJL"
echo "------------------------------------------"
echo "Sikeresen elkészült a projektkönyvtár."

#.tif fájlok hozzáadása a projekthez, majd azok eltávolítása
echo "Képfájlok hozzáadása..."
./sdaps.py "$MAPPA" add _nyers/*.tif
echo "------------------------------------------"
echo "Képfájlok sikeresen hozzáadva a projekthez, és annak mappájába áthelyezve."
rm _nyers/*.tif

#Kiértékelés
echo "A kérdőívek kiértékelése..."
./sdaps.py "$MAPPA" recognize
echo "------------------------------------------"
echo "Sikeres kiértékelés."

#Összefoglaló készítése, majd a közös mappába másolása
echo "Összefoglaló készítése..."
cp "_template/mszo.png" "$MAPPA/mszo.png"
./sdaps.py "$MAPPA" report_tex
if [ ! -d "_osszefoglalok" ]; then
mkdir _osszefoglalok
fi
cp "$MAPPA/report_1.pdf" "_osszefoglalok/$alkalom-$datum-$targy.pdf"
echo "Az összefoglaló sikeresen elkészült. Helye: _osszefoglalok/$alkalom-$datum-$targy.pdf"

#Ideiglenes fájlok eltávolítása
rm tex/sdapsreport.cls
rm mindentelfogad

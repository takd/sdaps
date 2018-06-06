# MSZO konzultáció- és kurzusértékelő-rendszer

Ez a rendszer az SDAPS 1.9.2 rendszer egy forkja, mely a [BME Gépész Szakkollégium Mechatronika Szakosztály konzultációs csoportja](http://gszk.ktk.bme.hu/node/101) számára készült. Az SDAPS segítségével kinyomtatható kérdőívek hozhatóak létre, melyeket szkennelés után digitálisan összesíteni lehet.

Mivel az SDAPS még folyamatos fejlesztés alatt van, így nem tökéletes, valamint nem is teljesen felhasználóbarát, ezért szükségesnek éreztem a módosítását és kiterjesztését, hogy használható legyen az MSZO konzultációs csoportja számára. 

Külön kihívást jelentett, hogy a program eredeti struktúrája nem egyezik meg azzal a folyamattal, ahogyan mi használjuk. Ugyanis mi nem nyomtatunk minden értékelendő alkalomhoz külön kérdőívet, csak kétféle kérdőív létezik -- egy a konzultációkhoz, és egy a kurzusokhoz -- azonban természetesen szeretnénk elkülöníteni az eredményeket eseményenként.

## Főbb változtatások:
* `defs.py` módosítása, hogy helyesen működhessenek a satírozás különböző értelmezései
* `calculate.py` módosítása a helyes szórás-számítás érdekében
* a testreszabhatóbb összefoglalók készítésének lehetősége a `sdapsreport.cls` alkalmanként történő létrehozásával a saját `sdapsreport_base.cls` alapján
* a kérdőívek generált részeinek magyarra fordítása

## Főbb kiterjesztések
* A központi kezelőfelület a `new_project.sh` szkript. Főbb funkciói:
  * A `_nyers` mappába elhelyezett szkennelt `*.tif` fájlok automatikus összegyűjtése
  * Esemény típusának, tárgyának és időpontjának bekérése, satírozás értelmezésének kezelése
  * Az esemény tulajdonságai alapján átlátható projektmappa létrehozása a megfelelő tex kérdőív alapján
  * A válaszok feldolgozása SDAPS segítségével
  * Az eseményhez szabott összefoglaló készítése SDAPS segítségével, annak megfelelő átnevezése és az összes összefoglaló átlátható összegyűjtése
* Két saját LaTeX-kérdőív
  * Egy a konzultációkra, egy a kurzusokra
  * Feleletválasztós és szabadkézi mezőkkel
* A `get_csv.sh` szkript segítségével az összes értékelés összegyűjtése .csv formátumban a félév végi értékeléshez.

## Telepítés

1. Az SDAPS csak Linux-on fut, Windows-on a Windows Linux Subsystem segítségével érdemes használni, a jelen rendszer is WSL-en volt kifejlesztve, Ubuntu rendszerrel. A telepítés lépései [itt olvahatóak](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

2. Mivel az SDAPS stabil verziója jóval a fejlesztési verzió mögött kullog, és WSL-en egyébként is meglehetősen nehéz a telepítése, valamit az egyini módosítások miatt forrásból kell telepíteni, a jelent git repóból. Érdemes egy saját, windows-os mappánkba navigálni először, így a fájlműveleteket később a megszokott módon végezhetjük, majd oda letölteni a rendszert:

```
cd /mnt/meghajto/sajat/mappam/
git clone https://github.com/takd/sdaps.git
cd sdaps
```

3. Az SDAPS különböző programkönyvtárak meglehetősen kiterjedt rendszerére támaszkodik, melyekhez a fejlesztő nem biztosít összegyűjtött, egyszerűen telepíthető listát. Az eredeti README-ben van egy többé-kevésbé összeszedett lista, de az még a python 3 port előtt készült. Így sok próbálkozással magam állítottam össze egy listát, amelyben 2018. 06. 06-án minden benne volt, ami a rendszer használatához kellett. Ezek a `dependencies.sh` futtatásával telepíthetőek:

```
./dependencies.sh
```

4. Ezek után még le kell fordítani a C-könyvtárakat:

```
./setup.py build
```

5. Ha minden jól ment, a rendszer készen áll a használatra.

## Használat

GUI nincs, így minden műveletet a terminálon keresztül kell végezni. Ha a telepítést azonban egy windows-os mappába végeztük a fentiek szerint, az sokat könnyít a helyzeten.

### Beszkennelt kérdőívek feldolgozása, új projekt létrehozása:

1. A kérdőíveket legalább 300 DPI minőségben, monokróm (fekete-fehér, nem szürkeárnyalatos) színben, TIF formátumban kell beszkennelni az optimális működés érdekében.

2. Egyszerre egy eseményhez tartozó kérdőíveket kell bemásolni a `_nyers` mappába.

3. Ezek után futtathatjuk a feldolgozó szkriptet: `./new_project.sh`

Megjegyzés: kérdőíveket nyomtatáshoz úgy a legegyszerűbb generálni, ha a `konzultacio.tex`, illetve `kurzus.tex` fájlok véglegesítése után csinálunk egy-egy üres projektet a szkripttel, majd a projektmappából kimásoljuk a megfelelő `questionnaire.pdf` fájlokat.

### CSV-összefoglalók készítése

1. A `./get_csv.sh` futtatásával a _projektek mappában lévő értékeléseit a szkript egyenként legenerálja CSV formátumban, majd összegyűjti őket a `_csv` mappába.

2. Ezek után ezeket tetszőleges módszerrel feldolgozhatjuk, pl. Excelben, vagy Wolfram Mathematicában.

## További megjegyzések  
Ha lehet, kerüljük az ékezetes mappákat (de a `new_project.sh` futtatásánálhasználhatunk ékezetes kifejezéseket), az ilyen jellegű problémák erkerülése érdekében:
> ('UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in position 4: ordinal not in range(128)')

A teljesebb megértés érdekében érdemes elolvasni az SDAPS eredeti, bár jelenleg kissé hiányos és régi dokumentációját, valamit böngészni a holnap többi részét is: https://sdaps.org/

A rendszer ezen kiterjesztésére is ugyanazok a licenszek vonatkoznak, mint az eredeti SDAPS szoftverre.

## Továbbfejlesztési lehtőségek
* Lokalizáció szebb implementációja
* Félév végi kiértékelés további automatizálása

Alább olvasható az eredeti README:

--------------------------------------------------------

# SDAPS

This Program can be used to carry out paper based surveys.

SDAPS uses a specialised LaTeX class to define questionnaires. This is tightly
integrated and is an easy way to create machine readable questionnaires.

After this, the program can create an arbitrary number of (unique)
questionnaires that can be printed and handed out. After being filled out, you
just scan them in, let sdaps run over them, and let it create a report with
the results.


## Requirements

Depending on what part of SDAPS you use, different dependencies are
required.

general (including recognize):
 * Python 3.6
 * distutils and distutils-extra
 * python3-cairo (including development files)
 * libtiff (including development files)
 * pkg-config
 * zbarimg binary for "code128" and "qr" styles
 * python3 development files

graphical user interface (gui):
 * GTK+ and introspection data
 * python3-gi

reportlab based reports (report):
 * reportlab
 * Python Imaging Library (PIL)

LaTeX based questionnaires (setup_tex/stamp):
 * pdflatex and packages:
   * PGF/TikZ
   * translator (part of beamer)
   * and more

LaTeX based reports:
 * pdflatex and packages:
   * PGF/TikZ
   * translator (part of beamer)
 * siunitx

Import of other image formats (convert, add --convert):
 * python3-opencv
 * Poppler and introspection data
 * python3-gi

Debug output (annotate):
 * Poppler and introspection data
 * python3-gi

## Installation

You can install sdaps using "./setup.py install". The C extension will
be compiled automatically, but of course you have to have all the
dependencies installed for this to work.

Please note that this git repository uses submodules to pull in the LaTeX
code. This means you need to run
 $ git submodule init
and then run
 $ git submodule update
to checkout and update the repository after a pull.

Alternatively, do the initial clone using "git clone --recursive".

## Standalone execution

As an alternative to installing sdaps it is also supported to run it without
installation. To do this run "./setup.py build" to build the binary modules
and translation. After this execute sdaps using the provided "sdaps.py"
script in the toplevel directory.

## Using SDAPS

Please run sdaps with "--help" after installing it for a list of commands.
Also check the website http://sdaps.org for some examples.

## Quality of the recognition

The quality of the recognition in SDAPS is quite good in my experience.
There is a certain amount of wrong detections, that mostly arise from people
not checking or filling out the boxes correctly. For example:
 * The cross is not inside the checkbox, but next to it
 * People cross the same box multiple times
 * People use very thick pens
 * Filling out is not done properly

As you can see, most of the errors arise from the possibility to correct
wrong marks by filling out checkboxes. SDAPS tries to be smart about this
by using different heuristics to detect the case, but it is not foolproof.

Suggestions on how to decrease the error rate are of course welcome.

### Matrix Errors

It can happen that SDAPS is not able to calculate the transformation matrix
which transforms the pixel space of the image into the mm coordinate system
used internally. If this happens the affected pages cannot be further
analysed.
It is usually possible to manually correct them using the GUI, but that can
be quite tedious.

See also TROUBLESHOOTING for some more information.

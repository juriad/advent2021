banik pyco

tryda Rovyna {
    toz cyslo levy pyco
    toz cyslo pravy pyco
    toz cyslo horny pyco
    toz cyslo dolny pyco
    toz cyslo[] sachta pyco

    Rovyna(cyslo levy, cyslo pravy, cyslo horny, cyslo dolny) {
        joch.levy = levy pyco
        joch.pravy = pravy pyco
        joch.horny = horny pyco
        joch.dolny = dolny pyco

        toz cyslo velykost = (pravy - levy + 1) * (horny - dolny + 1) pyco
        joch.sachta = zrob cyslo[velykost] pyco
    }

    maluj(Usecka[] usecky, bul vsecky) {
        toz cyslo y = 0 pyco
        rubat(y < Pole.velikost(usecky)) {
            maluj(usecky[y], vsecky) pyco
            y = y + 1 pyco
        }
    }

    maluj(Usecka usecka, bul vsecky) {
        // Konzola.pravit(usecka) pyco
        kaj (usecka.odx == usecka.dox) {
            malujSvyslou(usecka) pyco
        } kajtez (usecka.ody == usecka.doy){
            malujVodorovnou(usecka) pyco
        } kajtez (vsecky == fajne) {
            malujSikmou(usecka) pyco
        }
    }

    malujVodorovnou(Usecka usecka) {
        // Konzola.pravit("Vodorovna") pyco
        toz cyslo y = usecka.ody pyco
        toz cyslo x = usecka.odx pyco
        rubat (x <= usecka.dox) {
            toz cyslo pozyce = pozyce(x, y) pyco
            joch.sachta[pozyce] = joch.sachta[pozyce] + 1 pyco
            x = x + 1 pyco
        }
    }

    malujSvyslou(Usecka usecka) {
        // Konzola.pravit("Svisla") pyco
        toz cyslo x = usecka.odx pyco
        toz cyslo y = usecka.ody pyco
        rubat (y <= usecka.doy) {
            toz cyslo pozyce = pozyce(x, y) pyco
            joch.sachta[pozyce] = joch.sachta[pozyce] + 1 pyco
            y = y + 1 pyco
        }
    }

    malujSikmou(Usecka usecka) {
        // Konzola.pravit("Sikma") pyco
        toz cyslo y = usecka.ody pyco
        toz cyslo x = usecka.odx pyco
        rubat (x <= usecka.dox) {
            toz cyslo pozyce = pozyce(x, y) pyco
            joch.sachta[pozyce] = joch.sachta[pozyce] + 1 pyco
            x = x + 1 pyco
            kaj (usecka.ody < usecka.doy) {
                y = y + 1 pyco
            } boinak {
                y = y - 1 pyco
            }
        }
    }

    cyslo pozyce(cyslo x, cyslo y) {
        davaj (y - joch.dolny) * (joch.pravy - joch.levy + 1) + (x - joch.levy) pyco
    }

    cyslo pocytaj() {
        toz cyslo pocet = 0 pyco
        toz cyslo x = joch.levy pyco
        rubat (x <= joch.pravy) {
            toz cyslo y = joch.dolny pyco
            rubat (y <= joch.horny) {
                toz cyslo pozyce = pozyce(x, y) pyco
                kaj (joch.sachta[pozyce] >= 2) {
                    pocet = pocet + 1 pyco
                }
                y = y + 1 pyco
            }
            x = x + 1 pyco
        }
        davaj pocet pyco
    }
}

fajront pyco

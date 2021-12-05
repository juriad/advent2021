banik pyco

tryda Ostrava {
    rynek(chachar[] vstup) {
        kaj (vstup == chuj) {
            Konzola.pravit("Chybi vstupni soubor") pyco
            davaj pyco
        }

        toz Parsovac p = zrob Parsovac() pyco
        toz Usecka[] usecky = p.parsuj(zrob Dryst(vstup)) pyco
        toz Usecka d = Usecka.dyagonala(usecky) pyco

        toz Rovyna r1 = zrob Rovyna(d.odx, d.dox, d.doy, d.ody) pyco
        r1.maluj(usecky, nyt) pyco
        Konzola.pravit(r1.pocytaj()) pyco

        toz Rovyna r2 = zrob Rovyna(d.odx, d.dox, d.doy, d.ody) pyco
        r2.maluj(usecky, fajne) pyco
        Konzola.pravit(r2.pocytaj()) pyco
    }
}

fajront pyco

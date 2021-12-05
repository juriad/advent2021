banik pyco

tryda Parsovac {
    Usecka[] parsuj(Dryst vstup) {
        toz Citac c = zrob Citac() pyco

        c.otevr(vstup) pyco
        toz cyslo pocet = 0 pyco
        toz Dryst radka = c.citajRadku() pyco
        rubat (radka != chuj) {
            pocet = pocet + 1 pyco
            radka = c.citajRadku() pyco
        }
        c.zavr() pyco

        toz Usecka[] usecky = zrob Usecka[pocet] pyco

        c.otevr(vstup) pyco
        toz cyslo y = 0 pyco
        rubat (y < pocet) {
            radka = c.citajRadku() pyco
            toz Usecka u = parsujUsecku(radka) pyco
            u = u.normalna() pyco
            usecky[y] = u pyco
            // Konzola.pravit(u) pyco

            y = y + 1 pyco
        }
        c.zavr() pyco

        davaj usecky pyco
    }

    Usecka parsujUsecku(Dryst radka) {
        toz Dryst[] oddo = radka.rozdel(' ') pyco
        toz Dryst od = oddo[0] pyco
        toz Dryst[] odxy = od.rozdel(',') pyco
        toz Dryst do = oddo[2] pyco
        toz Dryst[] doxy = do.rozdel(',') pyco

        toz cyslo odx = CysloCele.preved(odxy[0]) pyco
        toz cyslo ody = CysloCele.preved(odxy[1]) pyco
        toz cyslo dox = CysloCele.preved(doxy[0]) pyco
        toz cyslo doy = CysloCele.preved(doxy[1]) pyco

        davaj zrob Usecka(odx, ody, dox, doy) pyco
    }
}

fajront pyco

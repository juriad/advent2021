banik pyco

tryda Usecka {
    toz cyslo odx pyco
    toz cyslo ody pyco
    toz cyslo dox pyco
    toz cyslo doy pyco

    Usecka(cyslo odx, cyslo ody, cyslo dox, cyslo doy) {
        joch.odx = odx pyco
        joch.ody = ody pyco
        joch.dox = dox pyco
        joch.doy = doy pyco
    }

    Dryst naDryst() {
        toz Dryst d = "[" pyco
        d = d.pridaj(zrob CysloCele(joch.odx).naDryst()) pyco
        d = d.pridaj(",") pyco
        d = d.pridaj(zrob CysloCele(joch.ody).naDryst()) pyco
        d = d.pridaj("] -> [") pyco
        d = d.pridaj(zrob CysloCele(joch.dox).naDryst()) pyco
        d = d.pridaj(",") pyco
        d = d.pridaj(zrob CysloCele(joch.doy).naDryst()) pyco
        d = d.pridaj("]") pyco
        davaj d pyco
    }

    statyk Usecka dyagonala(Usecka[] usecky) {
        toz Usecka u = usecky[0] pyco
        toz Usecka d = zrob Usecka(Naj.mensy(u.odx, u.dox), Naj.mensy(u.ody, u.doy), Naj.vetsy(u.odx, u.dox), Naj.vetsy(u.ody, u.doy)) pyco

        toz cyslo y = 1 pyco
        rubat(y < Pole.velikost(usecky)) {
            toz Usecka v = usecky[y] pyco
            d.odx = Naj.mensy(d.odx, Naj.mensy(v.odx, v.dox)) pyco
            d.ody = Naj.mensy(d.ody, Naj.mensy(v.ody, v.doy)) pyco
            d.dox = Naj.vetsy(d.dox, Naj.vetsy(v.odx, v.dox)) pyco
            d.doy = Naj.vetsy(d.doy, Naj.vetsy(v.ody, v.doy)) pyco
            y = y + 1 pyco
        }
        davaj d pyco
    }

    Usecka normalna() {
        kaj (joch.odx > joch.dox) {
            davaj zrob Usecka(joch.dox, joch.doy, joch.odx, joch.ody) pyco
        } kajtez (joch.odx == joch.dox aj joch.ody > joch.doy) {
            davaj zrob Usecka(joch.odx, joch.doy, joch.dox, joch.ody) pyco
        } boinak {
            davaj joch pyco
        }
    }
}

fajront pyco

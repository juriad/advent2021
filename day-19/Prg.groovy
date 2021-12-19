class Prg {
    static class Scanner {
        final int number
        final Set<Beacon> beacons = new LinkedHashSet<>()
        final Map<Scanner, Transformation> matches = new HashMap<>()

        Scanner(int number) {
            this.number = number
        }

        @Override
        String toString() {
            return "{Scanner $number: $beacons}"
        }

        Transformation match(Scanner other) {
            for (r in Rotation.rotations()) {
                int f = 0
                for (b1 in this.beacons) {
                    for (b2 in other.beacons) {
                        def t = Transformation.unify(b1, b2, r)
                        int m = this.match(other, t)
                        if (m >= 12) {
                            // println("${this.number} - ${other.number}: $t $m")
                            return t
                        }
                    }
                    f++
                    if (f > this.beacons.size() - 12) {
                        break
                    }
                }
            }
        }

        int match(Scanner other, Transformation transformation) {
            int matched = 0
            other.beacons.forEach { b ->
                def bb = transformation.transform(b)
                if (this.beacons.contains(bb)) {
                    matched++
                }
            }
            return matched
        }

        boolean equals(o) {
            if (this.is(o)) return true
            if (getClass() != o.class) return false

            Scanner scanner = (Scanner) o

            if (number != scanner.number) return false

            return true
        }

        int hashCode() {
            return number
        }
    }

    static class Beacon {
        final int x
        final int y
        final int z

        Beacon(int x, int y, int z) {
            this.x = x
            this.y = y
            this.z = z
        }

        boolean equals(o) {
            if (this.is(o)) return true
            if (getClass() != o.class) return false

            Beacon beacon = (Beacon) o

            if (x != beacon.x) return false
            if (y != beacon.y) return false
            if (z != beacon.z) return false

            return true
        }

        int hashCode() {
            int result
            result = x
            result = 31 * result + y
            result = 31 * result + z
            return result
        }

        @Override
        String toString() {
            return "[$x, $y, $z]"
        }
    }

    static class Rotation {
        final int[] axes

        Rotation(int ax, int ay, int az) {
            this.axes = [ax, ay, az] as int[]
        }

        private int getAxis(Beacon b, int axis) {
            int a = axes[axis]
            int v
            switch (Math.abs(a)) {
                case 1:
                    v = b.x
                    break
                case 2:
                    v = b.y
                    break
                case 3:
                    v = b.z
                    break
                default:
                    throw new Exception("Invalid axis $a")
            }
            return a < 0 ? -v : v
        }

        Beacon rotate(Beacon b) {
            return new Beacon(getAxis(b, 0), getAxis(b, 1), getAxis(b, 2))
        }

        Rotation invert() {
            // unsure about this
            def ix = axes.findIndexOf { Math.abs(it) == 1 }
            def iy = axes.findIndexOf { Math.abs(it) == 2 }
            def iz = axes.findIndexOf { Math.abs(it) == 3 }
            return new Rotation(
                    (ix + 1) * (axes[ix] < 0 ? -1 : 1),
                    (iy + 1) * (axes[iy] < 0 ? -1 : 1),
                    (iz + 1) * (axes[iz] < 0 ? -1 : 1))
        }

        static List<Rotation> rotations() {
            def dirs = [-1, 1, -2, 2, -3, 3]
            return [-1, 1, -2, 2, -3, 3].stream().flatMap { ax ->
                dirs.stream()
                        .filter { ay -> Math.abs(ax) != Math.abs(ay) }
                        .flatMap { ay ->
                            dirs.stream()
                                    .filter { az -> Math.abs(ax) != Math.abs(az) }
                                    .filter { az -> Math.abs(ay) != Math.abs(az) }
                                    .map { az -> new Rotation(ax, ay, az) }
                        }
            }.collect { it }
        }

        @Override
        String toString() {
            return "(${axes[0]}, ${axes[1]}, ${axes[2]})"
        }
    }

    static class Translation {
        final int dx
        final int dy
        final int dz

        Translation(int dx, int dy, int dz) {
            this.dx = dx
            this.dy = dy
            this.dz = dz
        }

        @Override
        String toString() {
            return "<$dx, $dy, $dz>"
        }

        Translation invert() {
            return new Translation(-dx, -dy, -dz)
        }

        Beacon translate(Beacon b) {
            return new Beacon(b.x + dx, b.y + dy, b.z + dz)
        }

        // what to apply to b2 to get b1
        static Translation unify(Beacon b1, Beacon b2) {
            int dx = b1.x - b2.x
            int dy = b1.y - b2.y
            int dz = b1.z - b2.z
            return new Translation(dx, dy, dz)
        }

        int size() {
            return Math.abs(dx) + Math.abs(dy) + Math.abs(dz)
        }
    }

    static class Transformation {
        final Rotation rotation
        final Translation translation

        Transformation(Rotation rotation, Translation translation) {
            this.rotation = rotation
            this.translation = translation
        }

        Beacon transform(Beacon b) {
            return translation.translate(rotation.rotate(b))
        }

        Transformation inverse() {
            def z = new Beacon(0, 0, 0)
            def zz = translation.translate(rotation.rotate(z))
            def zzz = rotation.invert().rotate(zz)
            return new Transformation(rotation.invert(), Translation.unify(z, zzz))
        }

        static Transformation unify(Beacon b1, Beacon b2, Rotation r) {
            return new Transformation(r, Translation.unify(b1, r.rotate(b2)))
        }

        @Override
        String toString() {
            return "{$rotation, $translation}"
        }
    }

    static List<Scanner> readScanners(File file) {
        List<Scanner> scanners = new ArrayList<>()
        file.withReader('UTF-8') { reader ->
            String line
            Scanner s
            while ((line = reader.readLine()) != null) {
                if (line.startsWith("---")) {
                    String num = line.find("\\d+")
                    s = new Scanner(num as int)
                    scanners.add(s)
                } else if (line.empty) {
                    continue
                } else {
                    String[] xyz = line.split(",")
                    s.beacons.add(new Beacon(xyz[0] as int, xyz[1] as int, xyz[2] as int))
                }
            }
        }
        return scanners
    }

    static void collectBeacons(Scanner s, Set<Beacon> beacons, List<Transformation> transformations,
                               Closure beaconSupplier) {
        beaconSupplier(s).forEach { b ->
            Beacon bb = b
            for (int i = transformations.size() - 1; i >= 0; i--) {
                bb = transformations[i].transform(bb)
            }
            beacons.add(bb)
        }
        s.matches.forEach { m, t ->
            transformations.add(t)
            collectBeacons(m, beacons, transformations, beaconSupplier)
            transformations.remove(t)
        }
    }

    static int findLargestDistance(Set<Beacon> beacons) {
        return beacons.stream().flatMap{b1 ->
            beacons.stream().map{b2 ->
                Translation.unify(b1, b2).size()
            }
        }.max(Comparator.naturalOrder())
        .orElseThrow()
    }

    static void main(String[] args) {
        def f = new File(args[0])

        def scanners = readScanners(f)
        // println(scanners)

        Deque<Scanner> q = new ArrayDeque<>()
        Set<Scanner> matched = new HashSet<>()

        Scanner s = scanners.get(0)
        matched.add(s)
        q.add(s)

        while (!q.empty) {
            Scanner s1 = q.pop()
            scanners.forEach { s2 ->
                if (matched.contains(s2)) {
                    return
                }
                def t = s1.match(s2)
                if (t != null) {
                    println("${s1.number} and ${s2.number} matched using $t")
                    s1.matches[s2] = t
                    matched.add(s2)
                    if (!q.contains(s2)) {
                        q.add(s2)
                    }
                }
            }
        }

        Set<Beacon> beacons = new HashSet<>();
        List<Transformation> transformations = new ArrayList<>()
        collectBeacons(s, beacons, transformations, { ss -> ss.beacons })
        println(beacons.size())

        Set<Beacon> centers = new HashSet<>();
        collectBeacons(s, centers, transformations, { ss -> Set.of(new Beacon(0, 0, 0)) })
        int maxDistance = findLargestDistance(centers)
        println(maxDistance)
    }
}

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

class Prg {
    record ParseResult(Num num, int next) {
    }

    sealed interface Num {
        Reg magnitude();

        static Num add(Num l, Num r) {
            Num sum = new Pair(l, r);
            return normalize(sum);
        }

        static Num normalize(Num n) {
            while (true) {
                Explosion e = explode(n, 0);
                if (e.exploded()) {
                    n = e.n();
                    continue;
                }
                Split s = split(n);
                if (s.split()) {
                    n = s.n();
                    continue;
                }
                break;
            }
            return n;
        }

        record Explosion(Reg l, Num n, Reg r, boolean exploded) {
        }

        static Explosion explode(Num n, int level) {
            return switch (n) {
                case Pair p -> {
                    if (level >= 4) {
                        yield new Explosion((Reg) p.a(), new Reg(0), (Reg) p.b(), true);
                    } else {
                        Explosion a = explode(p.a(), level + 1);
                        if (a.exploded()) {
                            Num bb = a.r() != null ? addRight(p.b(), a.r()) : p.b();
                            yield new Explosion(a.l(), new Pair(a.n(), bb), null, true);
                        }
                        Explosion b = explode(p.b(), level + 1);
                        if (b.exploded()) {
                            Num aa = b.l() != null ? addLeft(p.a(), b.l()) : p.a();
                            yield new Explosion(null, new Pair(aa, b.n()), b.r(), true);
                        }
                        yield new Explosion(null, p, null, false);
                    }
                }
                case Reg r -> new Explosion(null, r, null, false);
            };
        }

        static Num addRight(Num b, Reg carry) {
            return switch (b) {
                case Pair p -> new Pair(addRight(p.a(), carry), p.b());
                case Reg r -> new Reg(r.n() + carry.n());
            };
        }

        static Num addLeft(Num b, Reg carry) {
            return switch (b) {
                case Pair p -> new Pair(p.a(), addLeft(p.b(), carry));
                case Reg r -> new Reg(r.n() + carry.n());
            };
        }

        record Split(Num n, boolean split) {
        }

        static Split split(Num n) {
            return switch (n) {
                case Pair p -> {
                    Split a = split(p.a());
                    if (a.split()) {
                        yield new Split(new Pair(a.n(), p.b()), true);
                    }
                    Split b = split(p.b());
                    if (b.split()) {
                        yield new Split(new Pair(p.a(), b.n()), true);
                    }
                    yield new Split(p, false);
                }
                case Reg r -> {
                    if (r.n() >= 10) {
                        long half = r.n() / 2;
                        yield new Split(new Pair(new Reg(half), new Reg(r.n() - half)), true);
                    }
                    yield new Split(r, false);
                }
            };
        }
    }

    record Pair(Num a, Num b) implements Num {
        @Override
        public Reg magnitude() {
            return new Reg(3 * a.magnitude().n() + 2 * b.magnitude().n());
        }

        @Override
        public String toString() {
            return "[" + a + "," + b + ']';
        }
    }

    record Reg(long n) implements Num, Comparable<Reg> {
        @Override
        public Reg magnitude() {
            return this;
        }

        @Override
        public String toString() {
            return String.valueOf(n);
        }

        @Override
        public int compareTo(Reg o) {
            return Long.compare(this.n, o.n);
        }
    }

    public static void main(String[] args) throws IOException {
        List<Num> numbers = Files.lines(Paths.get(args[0]))
                .map(Prg::parse).toList();
        // numbers.forEach(System.out::println);
        Num sum = numbers.stream()
                .reduce(Num::add)
                .orElseThrow();
        System.out.println(sum);
        System.out.println(sum.magnitude());

        record Pair(Num a, Num b) {}

        Reg maxSum = numbers.stream()
                .flatMap(a -> numbers.stream().filter(b -> !b.equals(a)).map(b -> new Pair(a, b)))
                .map(p -> Num.add(p.a(), p.b()))
                .map(Num::magnitude)
                .max(Comparator.naturalOrder())
                .orElseThrow();
        System.out.println(maxSum);
    }

    private static Num parse(String line) {
        ParseResult result = parse(line, 0);
        return result.num();
    }

    private static ParseResult parse(String line, int start) {
        char c = line.charAt(start);
        return switch (c) {
            case '[' -> {
                ParseResult a = parse(line, start + 1);
                ParseResult b = parse(line, a.next() + 1);
                yield new ParseResult(new Pair(a.num(), b.num()), b.next() + 1);
            }
            default -> new ParseResult(new Reg(Character.digit(c, 10)), start + 1);
        };
    }
}

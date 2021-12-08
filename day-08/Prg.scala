import scala.io.Source

object Prg {
    val DIGITS = Map(
        "abcefg" -> 0, "cf" -> 1, "acdeg" -> 2, "acdfg" -> 3, "bcdf" -> 4,
        "abdfg" -> 5, "abdefg" -> 6, "acf" -> 7, "abcdefg" -> 8, "abcdfg" -> 9)

    def main(args: Array[String]) = {
        var count1478 = 0
        var sum = 0

        for (line <- Source.fromFile(args(0)).getLines) {
            val Array(head, tail) = line.split(" \\| ")
            val counts = head.toCharArray.filterNot(_ == ' ').groupMapReduce(identity)(_ => 1)(_ + _)

            val E = counts.find(_._2 == 4).get._1
            val B = counts.find(_._2 == 6).get._1
            val F = counts.find(_._2 == 9).get._1

            val words = head.split(" ")
            val C = words.find(_.length == 2).get.filterNot(_ == F).head
            val A = words.find(_.length == 3).get.filterNot(c => c == C || c == F).head
            val D = words.find(_.length == 4).get.filterNot(c => c == B || c == C || c == F).head

            val G = counts.find(e => e._2 == 7 && e._1 != D).get._1

            val TRANS = Map(A -> 'a', B -> 'b', C -> 'c', D -> 'd', E -> 'e', F -> 'f', G -> 'g')
            // println(s"TRANS => A$A B$B C$C D$D E$E F$F G$G")

            val number = tail.split(" ").map { num =>
                DIGITS(num.toCharArray.map(TRANS(_)).sorted.mkString)
            }
            number.filter(i => i == 1 || i == 4 || i == 7 || i == 8).foreach(_ => count1478 += 1)
            sum += number.mkString.toInt
        }

        println(count1478)
        println(sum)
    }
}

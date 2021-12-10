enum Shape with ToString, Eq {
    case Round,
    case Square,
    case Curly,
    case Angle
}

enum Type with ToString, Eq {
    case Open,
    case Close
}

enum Brace with ToString, Eq {
    case Brace(Shape, Type)
}

def decodeBrace(b : Char) : Brace = match b {
    case '(' => Brace(Round, Open)
    case ')' => Brace(Round, Close)
    case '[' => Brace(Square, Open)
    case ']' => Brace(Square, Close)
    case '{' => Brace(Curly, Open)
    case '}' => Brace(Curly, Close)
    case '<' => Brace(Angle, Open)
    case '>' => Brace(Angle, Close)
    case x => bug!("Wrong input ${x}")
}

enum Stack with ToString {
    case Stack(List[Brace])
}

def push(stack : Stack, brace : Brace) : Stack = match stack {
    case Stack(s) => Stack(brace :: s)
}

def pop(stack : Stack) : (Option[Brace], Stack) = match stack {
    case Stack(Nil) => (None, stack)
    case Stack(Cons(h, t)) => (Some(h), Stack(t))
}

enum Line with ToString {
    case Valid(List[Brace], Stack)
    case MissingStart(List[Brace], List[Brace])
    case Incomplete(List[Brace], Stack)
    case Corrupted(List[Brace], Stack, Brace, List[Brace])
}

def parseChar(line : Line, char : Char) : Line =
    let b = decodeBrace(char);
    match line {
        case MissingStart(braces, next) => MissingStart(braces, b :: next)
        case Incomplete(_, _) => bug!("Cannot be incomplete when more chars are coming")
        case Corrupted(braces, stack, c, next) => Corrupted(braces, stack, c, b :: next)
        case Valid(braces, stack) => match b {
             case Brace(_, Open) => Valid(b :: braces, push(stack, b))
             case Brace(shape, Close) => match pop(stack) {
                case (None, _) => MissingStart(braces, b :: Nil)
                case (Some(Brace(_, Close)), _) => bug!("Close on stack!")
                case (Some(Brace(shape2, Open)), stack2) => match shape == shape2 {
                    case true => Valid(Brace(shape, Close) :: braces, stack2)
                    case false => Corrupted(braces, stack, b, Nil)
                }
             }
         }
    }

def parseLine(input : String) : Line =
    let res = String.foldLeft(parseChar, Valid(Nil, Stack(Nil)), input);
    match res {
        case Valid(_, Stack(Nil)) => res
        case Valid(braces, stack) => Incomplete(braces, stack)
        case x => x
    }

def corruptScore(brace : Brace) : Int = match brace {
    case Brace(_, Open) => bug!("Cannot score open")
    case Brace(Round, _) => 3
    case Brace(Square, _) => 57
    case Brace(Curly, _) => 1197
    case Brace(Angle, _) => 25137
}

def task1(lines : List[Line]) : Unit & Impure =
    List.flatMap(line -> match line {
        case Corrupted(_, _, brace, _) => brace :: Nil
        case _ => Nil
    }, lines)
    |> List.map(corruptScore)
    |> List.foldLeft((a, b) -> a + b, 0)
    |> println

def incompleteScore(brace : Brace) : Int64 = match brace {
    case Brace(_, Close) => bug!("Cannot score close")
    case Brace(Round, _) => 1i64
    case Brace(Square, _) => 2i64
    case Brace(Curly, _) => 3i64
    case Brace(Angle, _) => 4i64
}

def task2(lines : List[Line]) : Unit & Impure =
    let sorted = List.flatMap(line -> match line {
        case Incomplete(_, Stack(braces)) => braces :: Nil
        case _ => Nil
    }, lines)
    |> List.map(List.foldLeft((a, b) -> a * 5i64 + incompleteScore(b), 0i64))
    |> List.sortWith(Order.compare);

    List.drop(List.length(sorted) / 2, sorted)
    |> List.head
    |> Option.foreach(println)

def main(args: Array[String]): Int32 & Impure =
    let linesResult = Array.get(0i32, args)
    |> File.readLines
    |> Result.map(List.map(parseLine));

    match (linesResult) {
        case Err(_) => bug!("No such file")
        case Ok(lines) => task1(lines); task2(lines)
    };

    0 // exit code

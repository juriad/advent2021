using util

class Node {
    Str name
    Node[] neighbors

    Bool isBig() { return name.isUpper }
    Bool isStart() { return name == "start" }
    Bool isEnd() { return name == "end" }

    new make(Str name)
    {
        this.name = name
        this.neighbors = [,]
    }

    override Str toStr() { return name }

    static Void connect(Node a, Node b) {
        a.neighbors.add(b)
        b.neighbors.add(a)
    }
}

class Stack
{
    Node[] visited
    Node? duplicate

    new make()
    {
        this.visited = [,]
        this.duplicate = null
    }

    Bool contains(Node node) { return visited.contains(node) }

    Void visit(Node node, Bool isDuplicate)
    {
        visited.push(node)
        if (isDuplicate) {
            this.duplicate = node
        }
    }

    Void unvisit()
    {
        Node n := visited.pop()
        if (duplicate == n) {
            duplicate = null
        }
    }

    Bool hasDuplicate() { return duplicate != null }

    override Str toStr() { return "<${visited}+${duplicate}>" }
}

class Prg
{
    Void traverse(Node node, Stack stack, |Stack,Node->Int| cond, |Stack->Void| callback)
    {
        if (node.isEnd)
        {
            callback(stack)
        }
        else
        {
            node.neighbors.each |Node n| {
                Int c := cond(stack, n)
                // echo("${node}: ${c}")
                switch(c) {
                    case 0:
                        // do nothing
                        if (false) {}
                    case 1:
                        stack.visit(n, false)
                        traverse(n, stack, cond, callback)
                        stack.unvisit()
                    case 2:
                        stack.visit(n, true)
                        traverse(n, stack, cond, callback)
                        stack.unvisit()
                    default: throw Err("Invalid stack operation")
                }
            }
        }
    }

    [Str:Node] readGraph(Str fileName) {
        File f := File(Uri.fromStr(fileName))
        [Str:Node] nodes := [:]

        f.eachLine |line| {
            Str[] parts := line.split('-')
            nodes.getOrAdd(parts[0], |Str k -> Node| { return Node(k) })
            nodes.getOrAdd(parts[1], |Str k -> Node| { return Node(k) })
        }

        f.eachLine |line| {
            Str[] parts := line.split('-')
            Node.connect(nodes[parts[0]], nodes[parts[1]])
        }

        return nodes
    }

    Void task1(Node start) {
        Int cnt := 0
        Stack stack := Stack()
        stack.visit(start, false)

        traverse(start, stack, |Stack st, Node n->Int| {
            return (n.isBig || !stack.contains(n)) ? 1 : 0
         }, |Stack st->Void| {
            // echo("${st}")
            cnt++
        })
        echo("Count: ${cnt}")
    }

    Void task2(Node start) {
        Int cnt := 0
        Stack stack := Stack()
        stack.visit(start, false)

        traverse(start, stack, |Stack st, Node n->Int| {
            return (n.isBig || !st.contains(n)) ? 1 : ((!n.isStart && !st.hasDuplicate) ? 2 : 0)
         }, |Stack st->Void| {
            // echo("${st}")
            cnt++
        })
        echo("Count: ${cnt}")
    }


    Void main(Str[] args)
    {
        if (args.size != 1)
        {
            throw Err("Provide input file")
        }
        echo("Hello, ${args[0]}!")

        [Str:Node] nodes := readGraph(args[0])
        Node start := nodes["start"]

        task1(start)
        task2(start)

        return 0
    }
}

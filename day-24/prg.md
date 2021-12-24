
W           X               Y                       Z
inp         0               Y                       Z
inp         Z               Y                       Z
inp         Z%26            Y                       Z
inp         Z%26            Y                       Z/A
inp         Z%26+B          Y                       Z/A
inp         inp=B+Z%26      Y                       Z/A
inp         0=inp=B+Z%26    Y                       Z/A
inp         0=inp=B+Z%26    0                       Z/A
inp         0=inp=B+Z%26    25                      Z/A
inp         0=inp=B+Z%26    25*0=inp=B+Z%26         Z/A
inp         0=inp=B+Z%26    1+25*0=inp=B+Z%26       Z/A
inp         0=inp=B+Z%26    1+25*0=inp=B+Z%26       Z/A*(1+25*0=inp=B+Z%26)
inp         0=inp=B+Z%26    0                       Z/A*(1+25*0=inp=B+Z%26)
inp         0=inp=B+Z%26    inp                     Z/A*(1+25*0=inp=B+Z%26)
inp         0=inp=B+Z%26    C+inp                   Z/A*(1+25*0=inp=B+Z%26)
inp         0=inp=B+Z%26    (C+inp)*(0=inp=B+Z%26)  Z/A*(1+25*0=inp=B+Z%26)
inp         0=inp=B+Z%26    (C+inp)*(0=inp=B+Z%26)  Z/A*(1+25*0=inp=B+Z%26) + (C+inp)*(0=inp=B+Z%26)





t :=   0 = (inp = (Z%26 + B))      {0,1}

Z/A * (t * 25 + 1)    +    (t * (C+inp))
Z/A *   {1, 26}       +      {0, C+inp}

     D1  D2  D3  d3  D4  d4  D5  D6  D7  d7  d6  d5  d2  d1
A = { 1,  1,  1  26,  1, 26,  1,  1,  1, 26, 26, 26, 26, 26}
B = {14, 15, 15, -6, 14, -4, 15, 15, 11, 0,   0, -3, -9, -9}
C = { 1,  7, 13, 10,  0, 13, 11,  6,  1, 7,  11, 14,  4, 10}


t depends on LD, inp and B
inp == LD + B   =>  1 => t=0
inp != LD + B   =>  0 => t=1


t=1 A=1
add new last digit nonzero C+inp

// t=1 A=26
// replace last digit with nonzero C+inp

// t=0 A=1
// same

t=0 A=26
remove last digit


D1 = 1 + inp1
inp14 = D1 - 9
inp14 = inp1 - 8

D2 = 7 + inp2
inp13 = D2 - 9
inp13 = inp2 - 2

D3 = 13 + inp3
inp4 = D3 - 6
inp4 = inp3 + 7

D4 = 0 + inp5
inp6 = D4 - 4
inp6 = inp5 - 4

D5 = 11 + inp7
inp12 = D5 - 3
inp12 = inp7 + 8

D6 = 6 + inp8
inp11 = D6 - 0
inp11 = inp8 + 6

D7 = 1 + inp9
inp10 = D7 - 0
inp10 = inp9 + 1

MAX
1 = 9
2 = 9
3 = 2
4 = 9
5 = 9
6 = 5
7 = 1
8 = 3
9 = 8
10 = 9
11 = 9
12 = 9
13 = 7
14 = 1

99299513899971

MIN
1 = 9
2 = 3
3 = 1
4 = 8
5 = 5
6 = 1
7 = 1
8 = 1
9 = 1
10 = 2
11 = 7
12 = 9
13 = 1
14 = 1

93185111127911

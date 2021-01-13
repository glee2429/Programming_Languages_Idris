
module DendentTypes

%default total


Tuple : Nat -> Type
Tuple Z     = Nat
Tuple (S n) = (Nat,Tuple n)

t0 : Tuple Z
t0 = 2

t1 : Tuple 1
t1 = (2,3)

t3 : Tuple 2
t3 = (2,3,4)

t4 : Tuple 3
t4 = (2,3,4,5)

first : Tuple k -> Nat
first {k=Z}   n     = n
first {k=S i} (n,_) = n

project : Nat -> Tuple k -> Nat
project {k=Z}   Z     n     = n
project {k=Z}   (S j) n     = n
project {k=S i} Z     (n,_) = n
project {k=S i} (S j) (_,t) = project {k=i} j t

lst : Tuple k -> Nat
lst {k=Z}   n     = n
lst {k=S i} (_,t) = lst {k=i} t

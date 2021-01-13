
module DendentTypes

%default total

----------------------------
---- I. Dependent Type -----
----------------------------

Single : Bool -> Type
Single True = Nat
Single False = List Nat
-- 'Single' is a Type Constructor
-- 'Bool' is a Value Argument
-- The result type (Nat or List Nat) depends on argument value

mkSingle : (b : Bool) -> Nat -> Single b
mkSingle True x = x
mkSingle False x = [x]
-- The function. 'Single b,' determines the result type
-- The result is either x or [x] which is the values of different types.

x : Single True
x = 4


-- > mkSingle True 3
-- 3 : Nat
--
-- > mkSingle False 3
-- [3] : List Nat
--
-- > :t x
-- x : Single True
--
-- > :t mkSingle True 4
-- mkSingle True 4 : Nat




-------------------------------
-- II. Overloading Functions --
-------------------------------

sum : (b : Bool) -> Single b -> Nat
sum True  x       = x
sum False []      = 0
sum False (x::xs) = x + sum False xs
-- The function, 'sum,' can take inputs of different types, either x or [...]


-- > sum True 4
-- 4 : Nat
-- > sum False [3,4]
-- 7 : Nat


---------------------------------
-- III. Implicit Parameter ------
---------------------------------
-- Rewrite 'sum' making the value on which the type depends on an implicit parameter.

bsum : {b : Bool} -> Single b -> Nat
bsum {b = True} x = x
bsum {b = False} [] = 0
bsum {b = False} (x::xs) = x + bsum {b = False} xs

-- > bsum {b = True} 4
-- 4 : Nat
-- > bsum {b = False} []
-- 0 : Nat
-- > bsum {b = False} [5, 7]
-- 12 : Nat


-- With the function using 'Implicit Parameter' we need to explicitly specify
-- the value 'b' since Idris can't reconstruct the 'Single' types from 'b'.
-- However, we can add 'value definitions' with 'type declarations' to address this.

xs : Single False
xs = [3,4]

-- > bsum xs
-- 7 : Nat


------------------------------
-- Exercise: Dependent Type --
------------------------------
-- Consider the following dependent type definition for tuple types.

Tuple : Nat -> Type
Tuple Z     = Nat
Tuple (S n) = (Nat,Tuple n)

t0 : Tuple 0
t0 = 2

t1 : Tuple 1
t1 = (2,3)

t2 : Tuple 2
t2 = (2,3,4)

t3 : Tuple 3
t3 = (2,3,4,5)

-- (a) Define the function 'first' that returns the first element of a tuple of type 'Tuple'
first : Tuple k -> Nat
first {k=Z}   n     = n
first {k=S i} (n,_) = n
-- The function type definition, 'first' takes 'Tuple k' and returns Nat
-- In each case, pattern match

-- > first t1
-- 2 : Nat
-- > first t2
-- 2 : Nat
-- > first t3
-- 2 : Nat

-- (b) Define the function 'lst' that returns the last element of a tuple type 'Tuple'
lst : Tuple k -> Nat
lst {k=Z}   n     = n
lst {k=S i} (_,t) = lst {k=i} t
-- The function type definition, 'first' takes 'Tuple k' and returns Nat
-- In each case, pattern match.
-- In the second case, decrement one step and recurse.

-- > lst t1
-- 3 : Nat
-- > lst t2
-- 4 : Nat
-- > lst t3
-- 5 : Nat

-- (c) Define the function 'project' that returns a component at a specific index from a tuple of type 'Tuple'
project : Nat -> Tuple k -> Nat
project {k=Z}   Z     n     = n
project {k=Z}   (S j) n     = n
project {k=S i} Z     (n,_) = n
project {k=S i} (S j) (_,t) = project {k=i} j t

-- > project 0 t2
-- 2 : Nat
-- > project 1 t2
-- 3 : Nat
-- > project 2 t2
-- 4 : Nat

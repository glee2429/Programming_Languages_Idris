%default total
-- always begins with %default total
-- since every Idris program should be terminated.

------------- HOLES -------------
-- Idris programs can have "holes" which mean incomplete parts of programs.
-- As a result, it is possible to program incrementally.

even : Nat -> Bool
even Z = True
even (S k) = ?even_rhs

-- when you run :t even_rhs, you'll get the result below
-- k : Nat
---------------------------------------
-- even_rhs : Bool



-------- DEPENDENT TYPES ----------
-- Types are first-class in Idris,
-- meaning that they can be computer, manipulated, and thrown into functions.

isSingleton : Bool -> Type
isSingleton True = Nat
isSingleton False = List Nat

-- isSingleton can be used to figure out the appropriate type from a Bool
-- and decides whether the type should be a singleton or not.


-- Use case of isSingleton 1: to find out a return type
mkSingle : (x : Bool) -> isSingleton x
mkSingle True = 0
mkSingle False = []

-- Use case of isSingleton 2 w/ varying input types:
-- to calculuate either the sum of a list of Nat or returns the given Nat
-- depending on whether the singleton flag is true.
sum : (single : Bool) -> isSingleton single -> Nat
sum True x = x
sum False [] = 0
sum False (x :: xs) = x + sum False xs

-- (Source: http://docs.idris-lang.org/en/latest/tutorial/interp.html)

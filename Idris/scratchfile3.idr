import Data.Fin
import Data.Vect

%default total


----------------------
---- Finite Sets -----
----------------------
-- Finite sets are literally sets with a finite number of elements.


-- Alternatively, you can write it as follows:

-- data Fin : Nat -> Type where
--   FZ : Fin (S k)
--   FS : Fin k -> Fin (S k)

-- We can see that it is a type constructor that takes a Nat and produces a type.
-- a canonical set of unnamed elements
-- as well as a type that captures integers that fall into the range of zero to (n-1) where n is the argument used to instantiate the Fin type.
-- e.g., Fin 5 can be used as the type of integers between 0 and 4.

-- ANALYSIS of FIN
-- FZ is the zeroth element of a finite set with S k elements
-- FS n is the (n+1)th element of a finite set with S k elements.
-- Fin is indexed by a Nat, which represents the number of elements in the set.

-- Useful application of FIN
-- Represent bounded natural numbers since the first n natural numbers form a finite set of n elements,
-- so we can treat Fin n as teh set of integers greater than or equal to zero and less than n.

index : Fin n -> Vect n a -> a
index FZ     (x :: xs) = x
index (FS k) (x :: xs) = index k xs
index : Fin n -> Vect n a -> a
-- it takes two arguments, an element of the finite set of n elements, and a vector with n elements of type a.
-- Alternatively, we can rewrite the line above as follows:
-- index : {a:Type} -> {n:Nat} -> Fin n -> Vect n a -> a
---------- IMPLICIT ARGUMENTS: {a:Type} -> {n:Nat}
-- The implicit arguments are not given in applications of index, but they can be inferred from Fin n & Vect n a arguments.
-- Any name beginning with a lower case letter which appears as a parameter or index in a type declaration is always bound as an implicit argument.
-- e.g., index {a=Int} {n=2} FZ (2 :: 3 :: Nil)

-- In fact, both implicit and explicit argument is given a name.
-- Alternatively, we can declare index as follows:
-- index : (i:Fin n) -> (xs:Vect n a) -> a
-- index FZ     (x :: xs) = x
-- index (FS k) (x :: xs) = index k xs
-- This function looks up an element in a Vect, by a bounded index gives as a Fin n
-- In other words, index looks up a value at a given location in a vector.
-- The location is bounded by the length of the vector (n in each case), so there's no need for a run-time bounds check.
-- The type checker guarantees that the location is no larger than the length of the vector, and no less than zero.
-- Additionally, there is no need for Nil, because it's impossible.
-- Since there is no element of Fin Z, and the location is a Fin n, then n can not be Z.
-- Therefore, attempting to look up an element in an empty vector would give a compile time type error, since it would force n to be Z.

--- Example 2
-- {} can be used to pattern match on the LHS, i.e. {var = pat} gets an implicit variable and attempts to apttern match on "pat"
isEmpty : Vect n a -> Bool
isEmpty {n = Z} _ = True
isEmpty {n = S k} _ = False

--- USING notation
-- Implicit arguments are useful when
-- 1. there is a dependency ordering
-- 2. the implicit arguments themselves have dependencies.
-- e.g., if you'd like to state the types of the implicit arguments in the following definition

using (x:a, y:a, xs:Vect n a)
  data IsElem : a -> Vect n a -> Type where
    Here : {x:a} -> {xs:Vect n a} -> IsElem x (x :: xs) -- head of the vector
    There : {x,y:a} -> {xs:Vect n a} -> IsElem x xs -> IsElem x (y :: xs) -- tail of the vector

-- An instance of 'IsElem x xs' indicates that x is an element of xs.
testVec : Vect 4 Int
testVec = 3 :: 4 :: 5 :: 6 :: Nil

inVect : IsElem 5 Main.testVec
inVect = There (There Here)


--- IMPLICIT ARGUMENTS & SCOPE
-- TYpechecker will always treat all variables that start with an lowercase letter and are applied to something else as an implicit variable.

-- (Source: http://docs.idris-lang.org/en/latest/tutorial/interp.html)

%default total

--- Dependent type (cont.) ---

------------------------------
--------  VECTOR   -----------
------------------------------

-- Vectors: a standard example of a depedent data type; aka "lists with lengths"

-- import Data.Vect

-- Alternatively, you can declare them as follows:
data Vect : Nat -> Type -> Type where
  Nil  : Vect Z a
  (::) : a -> Vect k a -> Vect (S k) a

-- Functions over Vect
(++) : Vect n a -> Vect m a -> Vect (n + m) a
(++) Nil       ys = ys
(++) (x :: xs) ys = x :: xs ++ ys
-- The type of (++) shows that the resulting vector's length will be the sum of the input lengths.

-- (Source: http://docs.idris-lang.org/en/latest/tutorial/interp.html)

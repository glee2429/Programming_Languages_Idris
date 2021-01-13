%default total

data Bool : Type where
  True : Bool
  False : Bool

data Nat : Type where
  Z : Nat
  S : Nat -> Nat

data List : Type -> Type where
  [] : List a
  (::) : a -> List a -> List a

---------------------------------
-- TYPE USED AS FUNCTION INPUT --
---------------------------------

(++) : {a : Type} -> List a -> List a -> List a
[]        ++ ys = ys
(x :: xs) ++ ys = x :: (xs ++ ys)


id : {a:Type} -> a -> a
id x = x
-- Functions can have types as an input

true1 = id True
zero1 = id 0


-- Exercise: define the function (!!) for extracting the nth element from a list (use zero for the first element)
(!!) : {a : Type} -> List a -> Nat -> Maybe a
[]     !! _     = Nothing
(x::_) !! Z     = Just x
(_::xs)!! (S n) = xs !! n

-- Type definiton: the function should be total, so use Maybe to return Nothing


------------------------------------
--- IDRIS PROGRAM MUST TERMINATE ---
------------------------------------

tail : {a : Type} -> List a -> List a
tail [] = []
tail (_ :: xs) = xs

-- the first case shows that when a list is empty, it will return an empty list.

head : {a : Type} -> List a -> Maybe a
head []      = Nothing
head (x :: _)= Just x
-- Using Maybe is necessary, since when the given input list is empty, the program must terminate and return 'Nothing'

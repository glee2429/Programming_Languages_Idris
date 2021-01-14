module Vectors

import Data.Vect

%default total

-- (a) Define a function 'zipW' that works in the same way
-- as 'zipWith' on lists.
zipW : (a -> b -> c) -> Vect n a -> Vect n b -> Vect n c
zipW f []      []      = []
zipW f (x::xs) (y::ys) = f x y :: zipW f xs ys

-- Zip: it takes two lists and go through interweaving the elements.
-- ZipWith: it doesn't put into a pair. ZipWith (+) -- arbitrary
-- This is similar to mapping, but it maps on the two lists onto the same time.

-- f: the operator on the vectors.
-- Sample output:
-- > zipW (+) v1 v2
-- [4, 6] : Vect 2 Int

-- > zipW (+) [1,2] [2,3]
-- [3, 5] : Vect 2 Integer
--
-- > zipW (*) [1,2] [2,3]
-- [2, 6] : Vect 2 Integer
--
-- > zipW (=) [1,2] [2,3]
-- [1 = 2, 2 = 3] : Vect 2 Type
--
-- > zipW (==) [1,2] [2,3]
-- [False, False] : Vect 2 Bool
--
-- > zipW (==) [False, False] [True, False]
-- [False, True] : Vect 2 Bool


-- (b) Define a function 'lst' that
-- computes the last element of a vector
lst : Vect (S n) a -> a
lst [x]        = x
lst (x::y::xs) = lst (y::xs)
-- When there's only one element in a vector, just return it
-- Otherwise, peel off one at a time from the beginning of the vector

-- > lst [1,2,3,9,4]
-- 4 : Integer


-- (c) Define a function 'initial' that removes
-- the last element of a vector.
initial : Vect (S n) a -> Vect n a
initial [_] = []
initial (x::y::xs) = x::initial (y::xs)

-- > initial [1,2,3,9,4]
-- [1, 2, 3, 9] : Vect 4 Integer
--
-- > initial [False, True, False]
-- [False, True] : Vect 2 Bool


-- (d) Define a function 'palin' that tests whether a vector is a palindrome.
palin : Eq a => Vect n a -> Bool
palin []      = True
palin [x]     = True
palin (x::y::xs) = x==lst (y::xs) && palin (initial (y::xs))

s1 : String
s1 = "amanaplanacanalpanama"

-- p1 : Vect 21 Char
-- p1 = "amanaplanacanalpanama"

v1 : Vect 2 Int
v1 = [1, 2]

v2 : Vect 2 Int
v2 = [3, 4]

v3 : Vect 2 Int
v3 = [5, 6]

p1 : Vect 2 Char
p1 = ['a','b']

p2 : Vect 3 Char
p2 = ['a','b','a']

p3 : Vect 4 Char
p3 = ['a','b','b','a']

p4 : Vect 21 Char
p4 = ['a','m','a','n','a','p','l','a','n','a',
      'c','a','n','a','l','p','a','n','a','m','a']

-- > palin p1
-- False : Bool
--
-- > palin p2
-- True : Bool
--
-- > palin p3
-- True : Bool
--
-- > palin p4
-- True : Bool

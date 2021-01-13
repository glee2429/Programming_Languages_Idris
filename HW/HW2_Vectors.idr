module Vectors

import Data.Vect

%default total

-- (a) Define a function 'zipW' that works in the same way as 'zipWith' on lists.
zipW : (a -> b -> c) -> Vect n a -> Vect n b -> Vect n c
zipW f []      []      = []
zipW f (x::xs) (y::ys) = f x y :: zipW f xs ys


-- (b) Define a function 'lst' that computes the last element of a vector
lst : Vect (S n) a -> a
lst [x]        = x
lst (x::y::xs) = lst (y::xs)

-- (c) Define a function 'initial' that removes the last element of a vector.
initial : Vect (S n) a -> Vect n a
initial [_] = []
initial (x::y::xs) = x::initial (y::xs)

-- (d) Define a function 'palin' that tests whether a vector is a palindrome.
palin : Eq a => Vect n a -> Bool
palin []      = True
palin [x]     = True
palin (x::y::xs) = x==lst (y::xs) && palin (initial (y::xs))

s1 : String
s1 = "amanaplanacanalpanama"

-- p1 : Vect 21 Char
-- p1 = "amanaplanacanalpanama"

p1 : Vect 2 Char
p1 = ['a','b']

p2 : Vect 3 Char
p2 = ['a','b','a']

p3 : Vect 4 Char
p3 = ['a','b','b','a']

p4 : Vect 21 Char
p4 = ['a','m','a','n','a','p','l','a','n','a',
      'c','a','n','a','l','p','a','n','a','m','a']

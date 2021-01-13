import Data.List
import Data.Vect
%default total

-- data Bool : Type where
--   True : Bool
--   False : Bool
--
-- data Nat : Type where
--   Z : Nat
--   S : Nat -> Nat


-- data List : Type -> Type where
--   [] : List a
--   (::) : a -> List a -> List a

---------------------------------
-- TYPE USED AS FUNCTION INPUT --
---------------------------------
-- infixr 7 ++
-- (++) : {a : Type} -> List a -> List a -> List a
-- []        ++ ys = ys
-- (x :: xs) ++ ys = x :: (xs ++ ys)


id : {a:Type} -> a -> a
id x = x
-- Functions can have types as an input



-- Exercise: define the function (!!) for extracting the nth element from a list (use zero for the first element)
infixr 7 !!
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


-------------------------------------
-------- TYPE CONSTRUCTOR -----------
-------------------------------------

-- Type constructor: a function that maps types to types (in Haskell)

-- In Haskell,
-- [] :: * -> *
-- Maybe :: * -> *
-- (->) :: * -> * -> *
-- -- * is a collection of types.
-- -- Arrow(->) is a type constructor.

-- Type constructor: a function that maps {types & values} to types (in Idris)

-- In Idris,
-- List : Type -> Type
-- Maybe : Type -> Type
-- (->) : Type -> Type -> Type


-- Interesting Type Constructors
-- These type constructors take 'Nat', indicating the length of vectors
-- Vect    : Nat -> Type -> Type
-- Segment : Nat -> Type


-----------------------------------------
------------ DEPENDENT TYPE -------------
-----------------------------------------

-- Dependet type: the result of a type constructor depends on types

-- Let's look at the type constructor, Single
Single : Bool -> Type
Single True  = Nat
Single False = List Nat
-- The result type (Nat or List Nat) depends on the argument value (Bool -- either True or False)

-- Let's look at the function, mkSingle, that produces Single b, depending on the type of b
mkSingle : (b : Bool) -> Nat -> Single b
mkSingle True  x = x
mkSingle False x = [x]
-- The result types can be either x or [], which is dependent on Single b.


------------------------------------------
-- TYPE CHECKER: PERFORMING COMPUTATION --
------------------------------------------

x : Single True
x = 4

-- > :t x
-- x : Single True
-- -- This indicates that the type checker simply returns the type defined by x
--
-- > :t mkSingle True 4
-- mkSingle True 4 : Nat
-- -- This indicates that the type checker performs the function, mkSingle,
-- -- and returns the computed value, Nat, which is one step further from Single True


-------------------------------------------
---------- OVERLOADING FUNCTIONS ----------
-------------------------------------------

sum : (b : Bool) -> Single b -> Nat
sum True  x       = x
sum False []      = 0
sum False (x::xs) = x + sum False xs
-- The function, 'sum,' can take inputs of different types, either x or [...]

-- Exercise: Implement a function inc for incrementing values of type Single b
inc : (b : Bool) -> Single b -> Single b
inc True  x       = x + 1
inc False []      = []
inc False (x::xs) = x+1::inc False xs
-- When looking at the definition, you need to provide either True or False of b.
-- Increment does mapping on list.
-- Add the first element of the list then recursively handle the rest of the list


------------------------------------------
----------------- VECTOR -----------------
------------------------------------------

-- Vector: similiar to list, but the size of a vector is given as an input
---------- Just like a list, we have Nil and Cons (::)

-- data Vect : Nat -> Type -> Type where
--   Nil  : Vect Z a
--   (::) : a -> Vect n a -> Vect (S n) a

-- Since the first argument of Vect (Overloaded) takes the length, the length of a vector is preserved.
-- (::) shows that the length is updated to n of a elements.


-- * Comparison between Vector vs. List * --

-- data List : Type -> Type where
--   []   : List a
--   (::) : a -> List a -> List a

-- Example:
-- xs = 1 :: 2 :: 7 :: []
-- ys = 9 :: xs

-- Both xs and ys are List Nat,
-- However, when we translate them into vectors, they are Vect 3 Nat, Vect 4 Nat respectively.

-- * Exercise: Define 'eqNat' and 'eqList' for comparing two natural numbers and two lists of values.

eqNat : Nat -> Nat -> Bool
eqNat   Z      Z    = True
eqNat  (S n) (S m)  = eqNat n m
eqNat   _      _    = False

-- Two zeros are equal, succ of n m compared
-- If empty, just return False

eqList : Eq a => List a -> List a -> Bool
eqList []       []      = True
eqList (x::xs)  (y::ys) = x==y && eqList xs ys
eqList _        _       = False
-- Eq a shows that the elements of the list can be compared for equality

-- * Exercise: Define 'eqVect' for comparing two vectors of values
eqVect : Eq a => Vect n a -> Vect n a -> Bool
eqVect []   [] = True
eqVect (x::xs) (y::ys) = x==y && eqVect xs ys
-- eqVect ONLY takes the vectors of the same size, so you don't have to write the third case.
-- If we apply eqVect to vectors of different sizes, it will result in 'type error(mistmatch)'
-- Vectors of different lengths have different types. (Since the length is baked into the vector type declaration.)

-- * Vector Size * --

-- To find the list of a list, we need to compute the length
-- size : List a -> Nat
-- size [] = Z
-- size (_::xs) = S (size xs)

-- On the other hand, Vector carries the size, so you can use the implicit parameter.
sizeVect : Vect n a -> Nat
sizeVect {n} _ = n

-- * Vector Head & Tail * --
-- head : Vect (S n) a -> a
-- head (x :: _) = x
-- we're looking at n > 0, so the definition is complete.
-- the head can not be applied to zero length vector.

-- tail : Vect (S n) a -> Vect n a
-- tail (_ :: xs) = xs
-- Now the return the size of n, which is smaller than the original vector by 1.


-- * Matrix Constructed by Vectors * --
Matrix : Nat -> Nat -> Type -> Type
Matrix n m a = Vect n (Vect m a)

-- * Exercise: define the functions 'firstRow' and 'firstCol' for matrices.
firstRow : Matrix (S n) m a -> Vect m a
firstRow (xs :: _) = xs

firstCol : Matrix n (S m) a -> Vect n a
firstCol xss = map head xss
-- firstCol []  = []
-- firstCol (xs::xss) = head xs::firstCol xss

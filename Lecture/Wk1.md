# CS 582 W21 Programming Languages II
## Lecture 1 - Course Overview & Idris Intro

### Idris:
Idris is more expressive than Haskell. Two main differences include 1) Dependent Type, and 2) Termination.
Idris only accepts programs that terminate.
As a result, Idris is useful for proof.

### Idris vs. Haskell:
#### I. Idris Data Type: Idris GADT (Generalized Algebraic Data Type) is more general.

e.g., Haskell 

```Haskell
data Bool = True | False
data Nat  = Z | S Nat

data [a]    = [] | (:) a [a]
data List a = [] | (::) a (List a)
```

e.g., Idris has *complete* type of constructor. Type constructor is essentially like function on types.

```Idris
data Bool : Type where 
     True : Bool 
    False : Bool
    
data Nat : Type where
   Z : Nat 
   S : Nat -> Nat
   
data List : Type -> Type where 
      [] : List a
    (::) : a -> List a -> List 
```


#### II. Idris Functions: Functions can be applied to data types
##### Implicit Argument in Idris 
- optional
- automatically inferred by type checker 
- e.g., {a : Type}

Exercise 1. Define the Idris function (!!) for extracting the nth element from a list (use zero for first element).

```Idris
(++) : {a : Type} -> List a -> List a -> List a
[]        ++ ys = ys
(x :: xs) ++ ys = x :: (xs ++ ys)

data Nat : Type where
       Z : Nat
       S : Nat -> Nat
       
(!!) : {a : Type} -> List a -> Nat -> Maybe a
[]      !!  _    = Nothing 
(x::_)  !!  Z    = Just x
(_::xs) !! (S n) = xs !! n
```
In the exercise above, (!!) function returns the result of 'Maybe a' and the reason why we designed this way is to meet the totality condition (Idris programs MUST terminate.)

#### III. Total functions
Always add the line below at the top of all Idris modules, since every program written in Idris should be terminated.
```Idris
%default total
```
- In Haskell, 
```Haskell
tail :: [a] -> [a]
tail (_:xs) = xs

head :: [a] -> a
head (x:_) = x
```
- In Idris, cheating by just using _ is not allowed. You need to define each case.  
```Idris 
tail : {a : Type} -> List a -> List a
tail [] = [] 
tail (_ :: xs) = xs
```

## Lecture 2 - Idris vs. Haskell (cont.) (01/07/2021)
### Type Constructor
- Haskell: a function that maps types to types
- Idris: a function that maps *types and values* to types

### Dependent Types
```Idris
Single : Bool -> Type
Single True   =  Nat
Single False  =  List Nat
```

```Idris
mkSingle : (b : Bool) -> Nat -> Single b
mkSingle True  x = x
mkSingle False x = [x]
```

```Idris
x : Single True
x = 4
```
In this function, "Single" is a *type constructor* and "Bool" is a *value argument*. Depends on the argument value, result types will be either "Nat" or "List Nat"
In other words, in order to determine the result type, we need to **evaluate** the function.

### Overloading Functions

```Idris 
sum : (b : Bool) -> Single b -> Nat 
sum True x        = x
sum False []      = 0
sum False (x::xs) = x + sum False xs
```
In the code block above, we can see that sum function takes values of different types (e.g., x, [])

#### Exercise 2: Implement the function *inc* for incrementing values of type Single b.

```Idris
inc : (b : Bool) -> Single b -> Single b
inc True x        = x + 1
inc False []      = []
inc False (x::xs) = x+1::inc False xs
```
Basically, this function maps Single b into a list with varying types of input (e.g, x, [])

### Vectors
This is when "dependent type" makes things interesting.

```Idris
data Vect : Nat -> Type -> Type where
      Nil : Vect Z a
      (::): a -> Vect n a -> Vect (S n) a
```

#### Exercise 2: Define the Idris functions *eqNat* and *eqList* for comparing two natural numbers and two lists of values.
```Idris
data Nat : Type where
     Z : Nat
     S : Nat -> Nat
```
Using Induction, eqNat can be expressed as follows:
```Idris
eqNat : Nat -> Nat -> Bool
eqNat Z Z = True
eqNat (S n) (S m) = eqNat n m
eqNat _ _ = False
```

```Idris 
eqList : Eq a => List a -> List a -> Bool
eqList [] [] = True
eqList (x::xs) (y::ys) = x==y && eqList xs ys 
eqList _ _ = False
```
#### Exercise 3: Define the Idris function *eqVect* for comparing two vectors of values.
Think about the *type* of the eqVect!

```Idris
eqVect : Eq z => Vect n a -> Vect n a -> Bool
eqVect [] [] = True
eqVect (x::xs) (y::ys) = x==y && eqVect xs ys
```

Leverage that the two vectors should be equal in length, so we don't have to consider that case. Then, we need just two cases to think about. First, when the lists are empty, and then use "total function" by looking at the incrementally smaller chunks.

#### Question
- Q: How does Idris evaluate the following expression? eqVect [2,3] [2,3,4]
- A: Produces a type error since eqVect function requires two vectors of the same length. (Vec is more restrictive than list.)

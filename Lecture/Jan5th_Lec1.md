# CS 582 W21 Programming Languages II
## Lecture 1 - Course Overview & Idris Intro

### Idris:
Idris is more expressive than Haskell. Two main differences include 1) Dependent Type, and 2) Termination.
Idris only accepts programs that terminate.
As a result, Idris is useful for proof.

#### Idris vs. Haskell:
I. Idris: GADT (Generalized Algebraic Data Type) is more general.

e.g., Haskell

```Haskell
data Bool = True | False
data Nat = Z | S Nat

data [a] = [] | (:) a [a]
data List a = [] | (::) a (List a)
```

II. Idris: Functions can be applied to data types

Exercise 1. Define the Idris function (!!) for extracting the nth element from a list (use zero for first element).

```Idris
(++) : {a : Type} -> List a -> List a -> List a
[]        ++ ys = ys
(x :: xs) ++ ys = x :: (xs ++ ys)

data Nat : Type where
   Z : Nat
   S : Nat -> Nat
```

III. Total functions
Always add the line below at the top of all Idris modules, since every program written in Idris should be terminated.
```Idris
%default total
```

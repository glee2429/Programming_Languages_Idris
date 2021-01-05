January 5th, 2021
Lecture 1

#### Idris:
Idris is more expressive than Haskell. Two main differences include 1) Dependent Type, and 2) Termination.
Idris only accepts programs that terminate.
As a result, Idris is useful for proof.

##### Idris vs. Haskell:
- Idris: GADT (Generalized Algebraic Data Type) is more general.

```Haskell
data Bool = True | False
data Nat = Z | S Nat

data [a] = [] | (:) a [a]
data List a = [] | (::) a (List a)
```

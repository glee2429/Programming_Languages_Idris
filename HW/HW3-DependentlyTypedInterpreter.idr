module DependentlyTypedInterpreter

%default total


---------------------------------------------------------------------
-- Syntax
---------------------------------------------------------------------

-- "ordimary" data type definition
--
-- data Term = Num Nat | Plus Term Term | Equal Term Term | If Term Term Term


-- GADT representation
--
data Ty = Nat | Bool


data Term : Ty -> Type where
  Num   : Nat -> Term Nat
  Plus  : Term Nat -> Term Nat -> Term Nat
  Equal : Term t -> Term t -> Term Bool
  Cond  : Term Bool -> Term t -> Term t -> Term t


-- Example terms
--
n : Term Nat
n = Num 3 `Plus` Num 5

b : Term Bool
b = Equal (Num 8) n

c : Term Bool
c = Equal b b

--err : Term Nat
--err = n `Plus` b


---------------------------------------------------------------------
-- Denotational Semantics
---------------------------------------------------------------------


{-

-- Value as an "ordinary" data type
--
data Value = N Nat | B Bool

error : Value
error = N 999
-- sem needs error handling, since Idris can't link the type of terms
-- to the type of resulting values
--
sem : Term t -> Value
sem (Num n)   = N n
sem (Plus t u) with (sem t,sem u)
  | (N n,N m) = N (n+m)
  --| _         = error
sem (Equal t u) with (sem t,sem u)
  | (N n,N m) = B (n == m)
  | (B b,B c) = B (b == c)
  | _         = error
sem (Cond t u v) with (sem t)
  | (B True)  = sem u
  | (B False) = sem v
  | _         = error

-}


-- dependent Value type
--
data Value : Ty -> Type where
  N : Nat  -> Value Nat
  B : Bool -> Value Bool

-- sem doesn't need error handling, since Idris can link the type of
-- terms to the type of resulting values
--
sem : Term t -> Value t
sem (Num n)   = N n
sem (Plus t u) with (sem t,sem u)
  | (N n,N m) = N (n+m)
sem (Equal t u) with (sem t,sem u)
  | (N n,N m) = B (n == m)
  | (B b,B c) = B (b == c)
sem (Cond t u v) with (sem t)
  | (B True)  = sem u
  | (B False) = sem v
  

vn : Value Nat
vn = sem n

vb : Value Bool
vb = sem b

vc : Value Bool
vc = sem c

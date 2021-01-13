module DependentlyTypedInterpreter

%default total

-- GADT representation
--
data Value = N Nat | B Bool
-- This is TYPE

data Ty = TyNat | TyBool
-- TyNat and TyBool are 'Data Constructor' NOT types.
-- To meet the totality condition
error : Value
error = N 999

data Term : Ty -> Type where
  Num   : Nat -> Term TyNat
  Plus  : Term TyNat -> Term TyNat -> Term TyNat
  Equal : Term t -> Term t -> Term TyBool
  Cond  : Term TyBool -> Term t -> Term t -> Term t

-- t and u are ambiguous (can be either Nat or Bool)
sem : Term t -> Value
sem (Num n)   = N n
sem (Plus t u) with (sem t,sem u)
  | (N n,N m) = N (n+m)
  | _         = error
sem (Equal t u) with (sem t,sem u)
  | (N n,N m) = B (n == m)
  | (B b,B c) = B (b == c)
  | _         = error
sem (Cond t u v) with (sem t)
  | (B True)  = sem u
  | (B False) = sem v
  | _         = error

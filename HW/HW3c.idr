module DependentlyTypedInterpreter

%default total

data Ty = Nat | Bool

data Value : Ty -> Type where
  N : Nat  -> Value Nat
  B : Bool -> Value Bool

data Term : Ty -> Type where
  Num   : Nat -> Term Nat
  Plus  : Term Nat -> Term Nat -> Term Nat
  Equal : Term t -> Term t -> Term Bool
  Cond  : Term Bool -> Term t -> Term t -> Term t

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

-- The type is preserved: Term t -> Value t
-- "Type correctness" proved by implementation.
-- Therefore, we don't need an error case.

--
-- vn : Value Nat
-- vn = sem n
--
-- vb : Value Bool
-- vb = sem b
--
-- vc : Value Bool
-- vc = sem c

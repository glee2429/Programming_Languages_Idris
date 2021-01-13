module DependentlyTypedInterpreter

%default total

-- (a) Define the denotational semantics for the langauges by following the domain.

data Value = N Nat | B Bool
data Term = Num Nat
          | Plus Term Term
          | Equal Term Term
          | Cond Term Term Term

-- To meet the totality condition
error : Value
error = N 999
-- This is a lazy way of handling the edge case.
-- Let's improve sem. 

sem : Term -> Value
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

n : Term Nat
n = Num 3 'Plus' Num 5

b : Term Bool
b = Equal (Num 8) n

c : Term Bool
c = Equal b b

err : Term Nat
err = n `Plus` b

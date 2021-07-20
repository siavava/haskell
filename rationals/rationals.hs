{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE InstanceSigs #-}

module Main where

import Control.Exception.Base (Exception)

data RAT = RAT {
  num :: Int, -- ^ Numerator
  denom :: Int -- ^ Denominator
}

-- ! Instances of RAT

instance Show RAT where
  show RAT {num, denom} = show num ++ "/" ++ show denom

instance Eq RAT where
  (==) :: RAT -> RAT -> Bool
  (==) p q = num p * denom q == num q * denom p

instance Ord RAT where
  compare :: RAT -> RAT -> Ordering
  compare p q = compare (num p * denom q)  (num q * denom p)


-- ! HELPERS

-- |The `signum` function finds the sign of a number.
signum' ::  Integral a => a -> a
signum' x = x `div` abs' x

-- |The `abs` function finds the absolute value of a number.
abs' :: (Ord p, Num p) => p -> p
abs' x
  | x >= 0 = x
  | otherwise = -x

-- | The `gcd` function finds the greatest common divisor of two numbers.
gcd' :: Integral t => t -> t -> t
gcd' x y = gcd'' (abs' x) (abs' y)
  where
    gcd'' x 0 = x
    gcd'' x y = gcd'' y (x `rem` y)


-- ! RATIONAL NUMBER OPERATIONS

-- | the `normRAT` function normalizes a rational number.
normRAT :: RAT -> RAT
normRAT RAT {num, denom}
  | denom == 0 = error "Invalid denominator"
  | num == 0 = RAT 0 1
  | otherwise = RAT (a `div` d) (b `div` d)
  where
    a = signum' denom * num      -- Find sign of denominator, convert numerator
    b = abs' denom               -- Find absolute value of denominator
    d = gcd' a b                 -- Find greatest common divisor of numerator and denominator


-- | The `negRAT` function negates a rational number.
negRAT :: RAT -> RAT
negRAT RAT {num, denom} = normRAT (RAT (-num) denom)

-- | The `recRAT` function finds the reciprocal of a rational number.
recRAT :: RAT -> RAT
recRAT RAT {num, denom} = normRAT (RAT denom num)


-- ! PRIMITIVE OPERATIONS

(!+), (!-), (!*), (!/) :: RAT -> RAT -> RAT

-- | Add two rational numbers.
(!+) p q = normRAT (RAT (num p*denom q + num q*denom p) (denom p * denom q))

-- | Subtract two` rational numbers.
(!-) p q = normRAT (RAT (num p*denom q - num q * denom p) (denom p * denom q))

-- | Multiply two rational numbers.
(!*) p q = normRAT (RAT (num p*num q) (denom p * denom q))

-- | Divide two rational numbers.
(!/) p q = normRAT (RAT (num p*denom q) (num q * denom p))

-- ! Initializer

-- | Create and initialize a rational number.
initRAT :: Int -> Int -> RAT
initRAT num denom = normRAT (RAT num denom)


main :: IO ()
main = do

  let someRAT = initRAT 12 32
  let otherRAT = initRAT 24 32
  let thirdRAT = initRAT 16 32

  putStr "\n\n"
  print $ "someRAT = " ++ show someRAT
  print $ "otherRAT = " ++ show otherRAT
  print $ "thirdRAT = " ++ show thirdRAT
  putStr "\n\n"
  print $ "someRAT == otherRAT " ++ show (someRAT == otherRAT)
  print $ "someRAT == thirdRAT " ++ show (someRAT == thirdRAT)
  print $ "someRAT < otherRAT " ++ show (someRAT < otherRAT)
  print $ "someRAT < thirdRAT " ++ show (someRAT < thirdRAT)
  print $ "someRAT > thirdRAT " ++ show (someRAT > thirdRAT)
  putStr "\n\n"
  print $ show someRAT ++ " + " ++ show otherRAT ++ " = " ++ show (someRAT !+ otherRAT)
  print $ show someRAT ++ " - " ++ show otherRAT ++ " = " ++ show (someRAT !- otherRAT)
  print $ show someRAT ++ " x " ++ show otherRAT ++ " = " ++ show (someRAT !* otherRAT)
  print $ show someRAT ++ " / " ++ show otherRAT ++ " = " ++ show (someRAT !/ otherRAT)
  putStr "\n\n"
  print $ show someRAT ++ " + " ++ show thirdRAT ++ " = " ++ show (someRAT !+ thirdRAT)
  print $ show someRAT ++ " - " ++ show thirdRAT ++ " = " ++ show (someRAT !- thirdRAT)
  print $ show someRAT ++ " x " ++ show thirdRAT ++ " = " ++ show (someRAT !* thirdRAT)
  print $ show someRAT ++ " / " ++ show thirdRAT ++ " = " ++ show (someRAT !/ thirdRAT)
  putStr "\n\n"
  print $ show someRAT ++ " + " ++ show otherRAT ++ " + " ++ show thirdRAT ++ " = " ++ show (someRAT !+ otherRAT !+ thirdRAT)

  
  print (RAT 3 0)
  -- ! print (initRAT 3 0) 

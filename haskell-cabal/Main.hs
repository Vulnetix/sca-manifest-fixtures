{-# LANGUAGE OverloadedStrings #-}

module Main where

import Data.Aeson (ToJSON, FromJSON)
import Data.Text (Text)
import Conduit
import qualified Network.HTTP.Client as HTTP
import Options.Applicative

data Person = Person { name :: Text, age :: Int }

instance ToJSON Person
instance FromJSON Person

main :: IO ()
main = do
    putStrLn "Hello from haskell-cabal test project"
    httpManager <- HTTP.newManager HTTP.defaultManagerSettings
    pure ()

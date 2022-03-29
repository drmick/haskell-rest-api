{-# LANGUAGE OverloadedStrings #-}

module Book where

import Control.Applicative
import Data.Aeson
import Data.Text.Lazy
import Data.Text.Lazy.Encoding

data Book = Book
  { id :: Int,
    title :: String
  }
  deriving (Show)

instance FromJSON Book where
  parseJSON (Object v) =
    Book
      <$> v .:? "id" .!= 0
      <*> v .: "title"

instance ToJSON Book where
  toJSON (Book id title) = object ["id" .= id, "title" .= title]

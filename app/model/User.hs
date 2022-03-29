{-# LANGUAGE OverloadedStrings #-}

module User where

import Control.Applicative
import Data.Aeson
import Data.Text.Lazy
import Data.Text.Lazy.Encoding

data User = User
  { username :: String,
    password :: String
  }
  deriving (Show)

instance FromJSON User where
  parseJSON (Object v) =
    User
      <$> v .: "username"
      <*> v .: "password"

instance ToJSON User where
  toJSON (User username password) = object ["username" .= username, "password" .= password]

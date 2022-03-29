{-# LANGUAGE OverloadedStrings #-}

module UserService where
import Data.Pool(Pool, createPool)
import Database.PostgreSQL.Simple
import UserRepository
import Data.Hash.MD5
import User
import Control.Monad.IO.Class

authorization :: Pool Connection -> String -> String -> IO Bool
authorization pool clientUsername clientPassword = do
  storedUser <- liftIO $ getUser pool clientUsername
  return $ check storedUser clientPassword
  where check Nothing _ = False
        check (Just storedUser) clientPassword = password storedUser == (md5s $ Str clientPassword)

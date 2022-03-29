{-# LANGUAGE OverloadedStrings #-}

module UserRepository where
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Encoding as TL
import Data.Pool(Pool, createPool, withResource)
import User
import Data.Hash.MD5

buildUser :: Pool Connection -> Maybe User -> IO ()
buildUser pool Nothing = return ()
buildUser pool (Just (User username password)) = do
  response <- withResource pool build
  return ()
  where build conn = withTransaction conn $ execute conn "insert into users(username, password) values (?, ?)" (username, md5s $ Str password);

getUser :: Pool Connection -> String -> IO (Maybe User)
getUser pool username = do
  response <- withResource pool get
  return $ user response
  where get conn = query conn "select username, password from users where username = ?" (Only username);
        user ((username, password) : _) = Just $ User username password
        user _ = Nothing

{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.RequestLogger (logStdout)
import Network.Wai.Middleware.HttpAuth (basicAuth, authIsProtected)
import Network.Wai (Middleware, Response)
import System.Environment.MrEnv (envAsInt,  envAsString)
import Data.Text
import Data.ByteString (ByteString)
import Database.PostgreSQL.Simple
import Data.Pool(Pool, createPool)
import Control.Monad.IO.Class
import Network.Wai.Middleware.Cors
import Data.Aeson(decode)
import Data.Hash.MD5
import qualified Data.ByteString.Char8 as BC
import Data.Word
import Book
import User
import BookRepository
import UserRepository
import UserService


protectedResources ::  Request -> IO Bool
protectedResources request = do
    let path = pathInfo request
    return $ protect path
    where
      protect (p : _) = p /= "sign_up"

main :: IO ()
main = do
  db_host <- envAsString "DB_HOST" "localhost"
  db_port <- envAsInt "DB_PORT" 5432
  db_user <- envAsString "DB_USER" "postgres"
  db_pass <- envAsString "DB_PASS" "postgres"
  db_name <- envAsString "DB_NAME" "postgres"

  let connectionInfo =
        defaultConnectInfo
          { connectHost = db_host,
            -- problem with variable convert to Word16
            connectPort = 5432,
            connectUser = db_user,
            connectPassword = db_pass,
            connectDatabase = db_name
          }
  --  the pool can have several independent pools, in our case it's 1,
  --  the maximum idle time of a connection (in seconds) before it is closed (in our case it's 10),
  --  the maximum amount of connections in the pool (in our case max. 10 connections).
  connectionPool <- createPool (connect connectionInfo) close 1 10 10
  scotty 3000 $ do
    middleware logStdout
    middleware simpleCors
    middleware $ basicAuth (\u p -> authorization connectionPool (BC.unpack u) (BC.unpack p)) "Realm" { authIsProtected = protectedResources }
    post "/sign_up" $ do
      b <- body
      liftIO $ buildUser connectionPool (decode b :: Maybe User)
      json ()
    get "/books" $ do
      books <- liftIO $ indexBooks connectionPool
      json books
    get "/books/:id" $ do
      bookId <- param "id"
      book <- liftIO $ getBook connectionPool bookId
      json book
    put "/books/:id" $ do
      bookId <- param "id"
      b <- body
      liftIO $ updateBook connectionPool bookId (decode b :: Maybe Book)
      json ()
    post "/books" $ do
      b <- body
      liftIO $ buildBook connectionPool (decode b :: Maybe Book)
      json ()
    delete "/books/:id" $ do
      bookId <- param "id"
      liftIO $ deleteBook connectionPool bookId
      json ()

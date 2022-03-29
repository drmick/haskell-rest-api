{-# LANGUAGE OverloadedStrings #-}

module BookRepository where
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import qualified Data.Text.Lazy as TL
import qualified Data.Text.Lazy.Encoding as TL
import Data.Pool(Pool, createPool, withResource)
import Book

instance FromRow Book where
  fromRow = Book <$> field <*> field

indexBooks :: Pool Connection -> IO [Book]
indexBooks pool = withResource pool get
   where get conn = query_ conn "select id, title from books"

getBook :: Pool Connection -> Int -> IO (Maybe Book)
getBook pool id = do
  response <- withResource pool get
  return $ book response
  where get conn = query conn "select id, title from books b where id = ?" (Only id);
        book ((id, title) : _) = Just $ Book id title
        book _ = Nothing

updateBook :: Pool Connection -> Int -> Maybe Book -> IO ()
updateBook pool id Nothing = return ()
updateBook pool id (Just (Book _ title)) = do
  response <- withResource pool update
  return ()
  where update conn = withTransaction conn $ execute conn "update books set title = ? where id = ?" (title, id);

buildBook :: Pool Connection -> Maybe Book -> IO ()
buildBook pool Nothing = return ()
buildBook pool (Just (Book _ title)) = do
  response <- withResource pool update
  return ()
  where update conn = withTransaction conn $ execute conn "insert into books(title) values (?)" (Only title);

deleteBook :: Pool Connection -> Int -> IO ()
deleteBook pool id = do
  response <- withResource pool delete
  return ()
  where delete conn = withTransaction conn $ execute conn "delete from books where id = ?" (Only id);

# Haskell Rest API

#### Build
```
docker-compose build
```
#### Run
```
docker-compose up
```
#### Use

```
# Register new user
curl -X POST -H "Content-Type: application/json" -d '{"username": "scott", "password": "tiger"}' http://localhost:3000/sign_up

# Add Book
curl -u scott:tiger -X POST -H "Content-Type: application/json" -d '{"title": "Crime and punishment"}' http://localhost:3000/books/

# List Books
curl -u scott:tiger -X GET -H "Content-Type: application/json" http://localhost:3000/books/

# Get Book
curl -u scott:tiger -X GET -H "Content-Type: application/json" http://localhost:3000/books/1

# Update Book
curl -u scott:tiger -X PUT -H "Content-Type: application/json" -d '{"title": "War and Peace"}' http://localhost:3000/books/1

# Delete Book
curl -u scott:tiger -X DELETE -H "Content-Type: application/json" http://localhost:3000/books/1
```

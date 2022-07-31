# Sample_store

Sample_store is a demo of the online application for shopping with points.

# Initial setup

```
$ docker-compose build
```

# Running the Rails application

```
$ docker-compose up
```

# Migration

```
$ docker-compose exec app rails db:migrate
$ docker-compose exec app rails db:seed
```

# Usage

## Sign up

Request with email, password and password_confirmation for register.

```
curl --request POST \
  --url http://localhost:3000/api/v1/auth \
  --header 'Content-Type: application/json' \
  --data '{"email":"test@example.com", "password":"password", "password_confirmation": "password"}' -i
```

## Sign in

Note the generated codes of uid, client and access-token for later request with auth.

```
curl --request POST \
  --url http://localhost:3000/api/v1/auth/sign_in \
  --header 'Content-Type: application/json' \
  --data '{"email":"test@example.com", "password":"password"}' \
  -i | grep -e uid -e client -e access-token

=>
access-token: {access token generates here}
client: {client code generates here}
uid: {email as UID appears here}
```

## Create Item

Please use the latest credentials you have obtained to access the API.

```
curl --request POST \
  --url http://localhost:3000/api/v1/items \
  --header 'Content-Type: application/json' \
  --header 'access-token: {access token}' \
  --header 'client: {client code}' \
  --header 'uid: {UID}' \
  --data '{"name":"item", "price":300}'
```

## Update Item

```
curl --request PATCH \
  --url http://localhost:3000/api/v1/items/30 \
  --header 'Content-Type: application/json' \
  --header 'access-token: {access token}' \
  --header 'client: {client code}' \
  --header 'uid: {UID}' \
  --data '{"price":3020}'
```

## Delete Item

```
curl --request DELETE \
  --url http://localhost:3000/api/v1/items/25 \
  --header 'Content-Type: application/json' \
  --header 'access-token: {access token}' \
  --header 'client: {client code}' \
  --header 'uid: {UID}'
```

## Purchase Item

```
curl --request POST \
  --url http://localhost:3000/api/v1/purchase \
  --header 'Content-Type: application/json' \
  --header 'access-token: {access token}' \
  --header 'client: {client code}' \
  --header 'uid: {UID}' \
  --data '{"id":3}'
```

# Rspec

```
$ docker-compose exec app rspec spec/
```
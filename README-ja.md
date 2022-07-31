# Sample_store

ポイントで商品を売買できるAPIのサンプルです。

# 初期セットアップ

```
$ docker-compose build
```

# Railsサーバー起動

```
$ docker-compose up
```

# マイグレーション実行と初期データ投入

```
$ docker-compose exec app rails db:migrate
$ docker-compose exec app rails db:seed
```

# 使い方

## ユーザー登録

Eメール、パスワード、確認用パスワードを送信してください。

```
curl --request POST \
  --url http://localhost:3000/api/v1/auth \
  --header 'Content-Type: application/json' \
  --data '{"email":"test@example.com", "password":"password", "password_confirmation": "password"}' -i
```

## ログイン

ユーザー登録で送信したEメールとパスワードでログインしてください。  
レスポンスヘッダーに生成された uid、client、access-token が返却されますのでメモをしておいてください。

```
curl --request POST \
  --url http://localhost:3000/api/v1/auth/sign_in \
  --header 'Content-Type: application/json' \
  --data '{"email":"test@example.com", "password":"password"}' \
  -i | grep -e uid -e client -e access-token
```

## 商品登録

ログイン時にメモした認証情報を付与してAPIリクエストを行います。

```
curl --request POST \
  --url http://localhost:3000/api/v1/items \
  --header 'Content-Type: application/json' \
  --header 'access-token: mHi7lM1Hnyd_oKza6pN2Pw' \
  --header 'client: -ZVbw8R051_rjgwIg51y1A' \
  --header 'uid: test@example.com' \
  --data '{"name":"item", "price":300}'
```

## 商品編集

```
curl --request PATCH \
  --url http://localhost:3000/api/v1/items/30 \
  --header 'Content-Type: application/json' \
  --header 'access-token: mHi7lM1Hnyd_oKza6pN2Pw' \
  --header 'client: -ZVbw8R051_rjgwIg51y1A' \
  --header 'uid: test@example.com' \
  --data '{"price":3020}'
```

## 商品削除

```
curl --request DELETE \
  --url http://localhost:3000/api/v1/items/25 \
  --header 'Content-Type: application/json' \
  --header 'access-token: mHi7lM1Hnyd_oKza6pN2Pw' \
  --header 'client: -ZVbw8R051_rjgwIg51y1A' \
  --header 'uid: test@example.com'
```

## 商品購入

```
curl --request POST \
  --url http://localhost:3000/api/v1/purchase \
  --header 'Content-Type: application/json' \
  --header 'access-token: mHi7lM1Hnyd_oKza6pN2Pw' \
  --header 'client: -ZVbw8R051_rjgwIg51y1A' \
  --header 'uid: test@example.com' \
  --data '{"id":3}'
```

# Rspec

```
$ docker-compose exec app rspec spec/
```
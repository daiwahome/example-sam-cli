# sam-cli-test

AWS SAM + DynamoDB Local のサンプル

## 使用方法

```bash
$ make
build                          Build Lambda functions
clean                          Clean build directory
deploy                         Upload and deploy Lambda functions
help                           Show help
migrate                        Create table and put data to DynamoDB Local
start-api                      Run local Api Gateway and Lambda funcitons
```

### セットアップ

```bash
$ brew install go dep python3
$ pip install -r requirements.txt
```

### ビルド

```bash
$ dep ensure
$ make build
```

### テスト

```bash
$ docker-compose up -d
$ make migrate
$ make start-api
$ curl http://localhost:3000/users/1
```

### デプロイ

```bash
$ BUCKET_NAME=<s3_bucket_name> make deploy
```

## 注意
- ローカルでの実行にはダミーでも構わないので Credentials が必要です。
- DynamoDB Local は落とすたびにデータが消えます ( `InMemory: true` )。

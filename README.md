## 俺の DynamoDB チュートリアル

### 何が出来るのか？

環境省大気汚染物質広域監視システム（そらまめ君）で提供されているデータを解析して DynamoDB に格納、検索を体験出来る。

### 使い方

1. DynamoDB local を起動する（起動の方法は以下の「DynamoDB local の起動方法」）
2. crate-table.rb を実行する（`soramame` というテーブルが作成される）
3. put-record.rb を実行すると `soramame` テーブルにレコードが挿入される
4. scan-item.rb を実行して `soramame` テーブルから測定地が「福岡」のデータが出力される
5. delete-table.rb を実行して `soramame` テーブルを削除する

### DynamoDB local の起動方法

- Dockerfile

```sh
% cat Dockerfile
FROM java
RUN mkdir /dynamodb
RUN cd /dynamodb/ && wget http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest.tar.gz
RUN cd /dynamodb/ && tar zxf dynamodb_local_latest.tar.gz
ENTRYPOINT ["/usr/bin/java", "-Djava.library.path=/dynamodb/DynamoDBLocal_lib", "-jar", "/dynamodb/DynamoDBLocal.jar"]
CMD ["-help"]
```

- docker build

```sh
% docker build -t your_name/your_image_name .
```

- docker run

```sh
% docker run -p 7777:7777 -d your_name/your_image_name -inMemory -port 7777
```

- DynamoDB local のエンドポイントを環境変数に

```sh
% export DYNAMODB_ENDPOINT="http://127.0.0.1:7777"
```

### 注意点

- そらまめ君のアクセスは常識の範囲に留めましょう
- 本スクリプトで取得出来るデータは九州地区のみのデータとなります
- 実際に DynamoDB を利用する場合にはアクセスキー、シークレットアクセスキーが必要になります
- 本スクリプトを利用して発生した一切の問題に関して責任は負いかねますので自己責任の範囲でご利用下さい

## 俺の DynamoDB チュートリアル

### 何が出来るのか？

[環境省大気汚染物質広域監視システム（そらまめ君）](http://soramame.taiki.go.jp/)で提供されているデータを解析して DynamoDB に格納、検索を体験出来る。

***

### 使い方

1. DynamoDB local を起動する（起動の方法は以下の「DynamoDB local の起動方法」）
2. crate-table.rb を実行する（`soramame` というテーブルが作成される）
3. put-record.rb を実行すると `soramame` テーブルにレコードが挿入される
4. scan-item.rb を実行して `soramame` テーブルから測定地が「福岡」のデータが出力される
5. delete-table.rb を実行して `soramame` テーブルを削除する

***

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

***

### 実行サンプル

- テーブル作成

```sh
% ./create-table.rb
Table soramame created.
```

- データの取得と登録

```sh
% ./put-record.rb

...

{"CHECK_TIME"=>"2015-09-12 08:00:00", "mon_st_code"=>"46466010", "town_name"=>"志布志市", "mon_st_name"=>"志布志", "SO2"=>"0.002", "NO"=>"0.002", "NO2"=>"0.006", "NOX"=>"0.008", "CO"=>"NANA", "OX"=>"0.015", "NMHC"=>"0.10", "CH4"=>"2.06", "THC"=>"2.16", "SPM"=>"0.024", "PM2.5"=>"NANA", "SP"=>"NANA", "WD"=>"北西", "WS"=>"0.7", "TEMP"=>"NANA", "HUM"=>"NANA", "mon_st_kind"=>"一般局"}
{"CHECK_TIME"=>"2015-09-12 08:00:00", "mon_st_code"=>"46482010", "town_name"=>"肝属郡東串良町", "mon_st_name"=>"東串良", "SO2"=>"0", "NO"=>"0.001", "NO2"=>"0.003", "NOX"=>"0.004", "CO"=>"NANA", "OX"=>"0.014", "NMHC"=>"0.22", "CH4"=>"2.45", "THC"=>"2.67", "SPM"=>"0.044", "PM2.5"=>"NANA", "SP"=>"NANA", "WD"=>"西南西", "WS"=>"0.9", "TEMP"=>"NANA", "HUM"=>"NANA", "mon_st_kind"=>"一般局"}
```

- データの検索

```sh
% ./scan-item.rb

...

SP: NANA
NMHC: NANA
-------------
NO: 0.003
HUM: 82
CHECK_TIME: 2015-09-12 08:00:00
mon_st_kind: 一般局
OX: 0.013
mon_st_name: 祖原
CO: NANA
WD: 東南東
CH4: 2.02
THC: 2.36
mon_st_code: 40137010
NO2: 0.014
SPM: 0.022
TEMP: 22
town_name: 福岡市早良区
NOX: 0.017
SO2: 0.001
PM2.5: NANA
WS: 1.0
SP: NANA
NMHC: 0.34
```

- テーブルの削除

```sh
% ./del-table.rb
Table soramame deleted.
```

***

### 注意点

- そらまめ君のアクセスは常識の範囲に留めましょう
- 本スクリプトで取得出来るデータは九州地区のみのデータとなります
- 実際に DynamoDB を利用する場合にはアクセスキー、シークレットアクセスキーが必要になります
- 本スクリプトを利用して発生した一切の問題に関して責任は負いかねますので自己責任の範囲でご利用下さい

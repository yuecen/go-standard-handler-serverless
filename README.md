## go-standard-handler-serverless

這是一個範例 repo，主要是要示範利用 [davyzhang/agw] 在 go 語言中，使用 standard handler 來實作 AWS lambda，不需將 handler 改為 lambda function 的寫法。這樣的好處可以將多個 route path (/foo or /bar...) 全部都置放在一個 lambda function 下，且不用異動到原來的寫法。

例如：

Standard handler

```go
// 你原來 golang handler
func myHandler(w http.ResponseWriter, r *http.Request) {
    // ...
}
```

[Lambda handler] (我們希望沿用上面的寫法，而**不是**需要把它改為下方的方式)

```go
// AWS lambda 要你實作的 handler
func HandleRequest(ctx context.Context, name MyEvent) (string, error) {
    // ...
}
```

方便演示，製作了簡單的工具 `tools.sh` 包含了四種功能：

1. init: 製作所需的工具 docker image
2. build: 編譯 go 範例程式
3. deploy: 使用 [serverless] 部署編譯過後的 go binary file
4. remove: 使用 [serverless] 移除 aws 上的 lambda 包含 s3 內的檔案

### 必要的安裝與資訊

- Docker

您必須安裝 docker 環境，才能進行編譯與部署。

- Access Key ID and Secret Access Key

您必須產生或跟您的 AWS 管理員拿一組使用者 credentials (包含 access key ID 與 Secret Access Key)，為了後續使用 serverless 部署自動化。

拿到你的 credentials 後，請先置換 `tools.sh` 第四五行的 <AWS_ACCESS_KEY_ID>, <AWS_SECRET_ACCESS_KEY> 變數。

### 建立環境 Docker Image

```bash
$ ./tools.sh init
# ... init ...
```

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
go-serverless       1.x                 2b51d1f2f6b3        4 seconds ago       507MB
```

### 利用 Docker Image 去編譯 Go 程式碼

```bash
$ ./tools.sh build
```

### Serverless 部署

```bash
$ ./tools.sh deploy
```

### 使用 [vegeta] 進行壓力測試

第一次 ConcurrentExecutions: 86/500

```bash
# attack -rate=250 -duration=30s -timeout=10s | tee results.bin | vegeta report

Requests      [total, rate, throughput]  7500, 250.03, 150.13
Duration      [total, attack, wait]      35.249241776s, 29.995864107s, 5.253377669s
Latencies     [mean, 50, 95, 99, max]    6.14179192s, 6.00710603s, 10.003507574s, 10.00595233s, 10.010931736s
Bytes In      [total, mean]              14119062, 1882.54
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    70.56%
Status Codes  [code:count]               0:2208  200:5292
```

執行完第一次後馬上進行第二次測試 ConcurrentExecutions: 36/500

```bash
# attack -rate=250 -duration=30s -timeout=10s | tee results.bin | vegeta report

Requests      [total, rate, throughput]  7500, 250.04, 242.10
Duration      [total, attack, wait]      30.978660944s, 29.995366366s, 983.294578ms
Latencies     [mean, 50, 95, 99, max]    244.586671ms, 206.843599ms, 454.935527ms, 860.13199ms, 1.262971858s
Bytes In      [total, mean]              19995008, 2666.00
Bytes Out     [total, mean]              0, 0.00
Success       [ratio]                    100.00%
Status Codes  [code:count]               200:7500 
```

[davyzhang/agw]:https://github.com/davyzhang/agw
[serverless]:https://serverless.com/
[Lambda handler]:https://docs.aws.amazon.com/en_us/lambda/latest/dg/go-programming-model-handler-types.html
[vegeta]:https://github.com/tsenart/vegeta

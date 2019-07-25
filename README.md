### go-standard-handler-serverless

這是一個範例 repo，主要是要示範如何在 go 語言中，使用 standard handler 來實作 AWS lambda，不需將 handler 改為 lambda function 的寫法。這樣的好處可以將多個 route path (/foo or /bar...) 全部都置放在一個 lambda function 下，且不用異動到原來的寫法。

例如：

Standard handler

```go
func myHandler(w http.ResponseWriter, r *http.Request) {
    // ...
    // 你原來 handler 的邏輯
    // ...
}
```

Lambda handler (我們不希望將原來的寫法改為 lambda)

```go
func HandleRequest(ctx context.Context, name MyEvent) (string, error) {
    // ...
    // AWS lambda 要你實作的 handler
    // ...
}
```

本範例最後還演示了如何使用 [serverless] 部署編譯過後的 go binary file。

#### 開始之前

- Access Key ID and Secret Access Key

首先您必須先自行產生或跟您的管理員拿一組 AWS 使用者 access key ID 與 Secret Access Key，為了後續使用 serverless 部署自動化。

- 部署套件

為了使用 [serverless] 進行部署，您必須先安裝該套件 serverless-cli：

```bash
# Install the serverless cli
npm install -g serverless
```

[serverless]:https://serverless.com/

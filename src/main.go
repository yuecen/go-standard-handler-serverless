package main

import (
	"net/http"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/davyzhang/agw"
	"github.com/gorilla/mux"
)

func fooHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.(*agw.LPResponse).WriteBody(map[string]string{
		"msg":     "From foo handler",
		"funcArn": agw.LambdaContext.InvokedFunctionArn,
		"event":   string(agw.RawMessage),
	}, false)
}

func barHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.(*agw.LPResponse).WriteBody(map[string]string{
		"msg":     "From bar handler",
		"funcArn": agw.LambdaContext.InvokedFunctionArn,
		"event":   string(agw.RawMessage),
	}, false)
}

func main() {
	mux := mux.NewRouter()
	mux.HandleFunc("/foo", fooHandler)
	mux.HandleFunc("/bar", barHandler)
	lambda.Start(agw.Handler(mux))
}

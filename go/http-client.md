# Always set a sane value for timeouts when using http.Client

When initializing a HTTP Client generally people use

```go
client := &http.Client{}
```

However, this allows someone to hijack your goroutines.
Look at this simple example:

```go
svr := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
	time.Sleep(time.Hour)
}))
```

When you use

```go
http.Get(svr.URL)
```

Your client will hang for an hour and then terminate.
In order to remedy this _always specify a sane timeout_:

```go
client := &http.Client{ Timeout: time.second * 10 }
```

Reference: [Don't use Go's default HTTP client (in production)](https://medium.com/@nate510/don-t-use-go-s-default-http-client-4804cb19f779)

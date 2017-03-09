# Installing Go

## macOS

- `brew install go`
- create your Go workspace directory, for example `~/go`
- if your Go workspace is not in `~/go`, set the environment variables `GOPATH` to the Go workspace path
  - `~/go` is the default since Go 1.8, so if you use that path, you don't have to set it
  - the environment variable `GOROOT` seems not necessary when installing via HomeBrew

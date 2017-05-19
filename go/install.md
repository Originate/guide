# Installing Go

## macOS

- `brew install go`

## Configuration

- create your Go workspace directory, for example `~/go`
- if your Go workspace is not in `~/go`, set the environment variables `GOPATH` to the Go workspace path
  - `~/go` is the default since Go 1.8, so if you use that path, you don't have to set it
- the environment variable `GOROOT` seems not necessary when installing via HomeBrew

A possible solution to the problem of the Go workspace cluttering up with
dependencies is to have two Go workspaces:
one for code you are working on, and another one for dependencies.
If you pick `~/go-external` for the latter, your GOPATH should look like
`$HOME/go-external:$HOME/go`.
In this case, `go get` fetches into the first workspace.
To work on code, manually clone it into the second workspace.
Go uses both workspaces simultaneously.
A downside is that certain tools might not work fully in this setup.
More info [here](https://peter.bourgon.org/go-best-practices-2016/#development-environment)

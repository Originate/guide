# Making the zero value useful

Go tries hard to make the zero value of variables useful.
For example, an empty string is a better zero value for strings than `nil`,
because you can use empty strings like any other string
without having to litter your code base with `nil` checks.
When used, it behaves neutral.
That's all you need in most situations.
Go cannot do this for your own custom types,
so it has to use `nil` as their zero value.
This doesn't mean that `nil` is always the best zero value, though.
Use the [null object pattern](http://cs.oberlin.edu/~jwalker/nullObjPattern)
to save yourself and your users from having to litter their code with `nil` checks.
This can be done via [factory functions](http://www.golangpatterns.info/object-oriented/constructors).
The Go library provides null implementations for many of its elements, for example:
- [ioutil.Discard](https://golang.org/pkg/io/ioutil/#pkg-variables)
  for streams

__Example:__
Let's say cars have doors, but some toy cars don't.
We want to use doors in our code without having to check each time whether a car has doors.

```go
type Car struct {
  door Door
}

type Door interface {
  open() error
}

// NoDoor is a Door implementation that represents no door.
// You can use it like a normal door, it simply does nothing.
type NoDoor struct{}

func (d NoDoor) open() error {
  return nil
}

// NewCar creates a new car instance with the given door.
// If no door is given, it creates a car with a NoDoor.
func NewCar(d Door) Car {
  if d == nil {
  	d = NoDoor{}
  }
  return Car{door: d}
}
```

Let's create a car with no door,
for example in a test where we don't care about the door:

```go
c := NewCar(nil)
```

Now our code can simply use the door, whether it is there or not:

```go
c.door.open()
```

Instead of pervasive nil checks for every attribute each time we call it:

```go
if c.Door != nil {
  c.door.open()
}
```

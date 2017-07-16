# Originate Guides - Field Guide to Haskell Development

Don't panic.

## Environment

(see also the [Haskell Tool Stack](stack-tutorial.md)

* Haskell tooling is in a state of flux. There are lots of obvious warts, unfortunately, but the community is working on it. The below tools represent the current state of the art as of writing.

* Emacs, Vim, and Atom have well-maintained and generally excellent Haskell integration.

* [stack](https://github.com/commercialhaskell/stack): the package and build manager with [Stackage](https://www.stackage.org) integration.

* [hlint](https://github.com/ndmitchell/hlint): a tool that checks for common style issues. You will be shocked at how comprehensive it is.

* [hdevtools](https://github.com/hdevtools/hdevtools): uses a client-server architecture to speed up syntax and type-checking in supported editors. Check it out!

* [ghcid](https://github.com/ndmitchell/ghcid): ghcid runs a little watch daemon in your console and can be useful as a sort of radar display on your second monitor. Spits out type errors and, if you want, runs your tests.

* `-Wall -Werror`. Turn it on.

* Promotional consideration: see Hao Lian's [_The always-updated treasure map to Haskell_](http://hao.codes/haskell-treasure-map.html) for a guide on which libraries to use.

## MonadReader

`MonadReader` is our friend. It takes this:

```haskell
bakeCookies :: Flour -> Sugar -> Water -> Chips -> IO ()
bakeBrownies :: Flour -> Sugar -> Water -> Cocoa -> IO ()
bakeBread :: Flour -> Water -> Yeast -> IO ()
```

and turns it into this:

```haskell
data Pantry = Pantry {
    flour :: Flour
  , sugar :: Sugar
  , water :: Water
}

bakeCookies :: (MonadReader Pantry m, MonadIO m) => Chips -> m ()
bakeBrownies :: (MonadReader Pantry m, MonadIO m) => Cocoa -> m ()
bakeBread :: (MonadReader Pantry m, MonadIO m) => Yeast -> m ()
```

You can then choose how you want to discharge the `MonadReader`
constraint with either the `MonadReader r (-> r)` instance or the
`Monad m => MonadReader r (ReaderT r m)`. Here:

```haskell
main =
  let pantry = Pantry ... in
  bakeCookies pantry
```

```haskell
main =
  let pantry = Pantry ... in
  runReaderT bakeCookies pantry
```

We're also able to take advantage of the `view` combinator in `lens`, which lets us access the parts of the reader context without having to use the convoluted record syntax.

```haskell
bakeCookies :: (MonadReader Pantry m, MonadIO m) => Chips -> m ()
bakeCookies = do
  flour_ <- view flour
  sugar_ <- view sugar
  oxygenMolecule <- view (water . oxygenMolecule)
  ...
```

This works because the `view` type is parametrized on `MonadReader`. All along you've been doing this:

```haskell
view _1 (1, 2) -- => 1
```

thinking you're just using function application. But what you've actually been doing is telling the typechecker to use the `MonadReader r (-> r)` instance. For example:

```haskell
runReaderT (view _1) (1, 2) -- => 1
```

is true also.

But more about `lens` later.

## Prelude

The default Prelude has one big problem: You have to write out `import Control.Monad` or `import Data.List` every single time. Save yourself some typing. Medium Haskell projects almost always define their own prelude, and you should too. Turn on `{-# LANGUAGE NoImplicitPrelude #-}` either at the file level or as a default extension in `package.yaml`/`project.cabal`.

A custom prelude is a good place to:

* Import commonly used modules, like `Data.List`.

* Re-export someone else's prelude (`base-prelude` is a godsend).

* Re-export common monad transformers, since you'll be typing them
  every day.

* Implement short utility functions specific to your project. For example, a `lens` `Iso'` between `UTCTime` and `America/Vancouver` time-zone `LocalTime` for a project that has to frequently handle PST/PDT times.

## Strictness

In practice, you want strictness on the outer spine of your data type.

```haskell
data Record = Record { field1 :: !Int
                     , field2 :: !String
                     }
```

This is because

* You probably don't need laziness in your data type.

* Laziness comes at the price of accidentally building up big thunks that you have to hunt down when the deadline is nearing and everybody is mad at you.

* GHC memory profiling, while not horrible, is still mildly arcane and somewhat of an art.

* In the future (or possibly right now) you might compile with `-O -funbox-strict-fields`, which lays out your records without any indirection (pointers to thunks) at all and can improve performance.

In GHC 8, you can do this automatically with `{-# LANGUAGE StrictData #-}`.

## Strict monad transformers

Monad transformers are even trickier to reason about, memory-wise. You will create programs with more intuitive memory dynamics if you use the strict version of `StateT` and `WriterT`:

```haskell
import Control.Monad.Trans.State.Strict
import Control.Monad.Trans.Writer.Strict
import Control.Monad.Trans.RWS.Strict
```

## Miscellaneous

* Use `ExceptT` (in `mtl`) instead of `EitherT` (in its own package).

* `stack ghci` is your friend if you're working in one build target for a long period of time. Typing `:r` to reload your code is much faster than running an incremental build.

* `stack build --fast --ghc-options="+RTS -A256m -n2m -RTS"` is a good way of speeding up your builds. It tweaks values for the garbage collector so that the GHC processes running your code don't spend so much time in GC. It ... may or may not improve your performance. Builds are pretty slow in Haskell-land.

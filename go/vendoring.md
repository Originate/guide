# Originate Guides - Go - Vendoring

**Only vendor dependencies for binaries, not for libraries.**
This means code bases that can be included into other code bases
should not have a `vendor` folder.

If several libraries vendor the same dependency,
Go's type checker sees several copies of the source code of the dependency,
in different import paths,
possibly in different versions.
This forces it to treat them as different types
and causes all sorts of compiler errors.
More info [here](https://peter.bourgon.org/go-best-practices-2016/#dependency-management).

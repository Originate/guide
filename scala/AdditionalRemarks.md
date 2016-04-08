Originate's Scala Style Guide
=============================

Additional Remarks
------------------

0. Program in Scala. You are not writing Java, Haskell, or Python.

0. Leverage type safety. Let the compiler and the type system do the grunt work for you. Type early, type often. "When in doubt, create a type" - Martin Fowler

0. Favor immutability, avoid mutability whenever possible. Mutability encapsulated in small scopes internal to functions is acceptable.

0. Obey the principle of least astonishment.

0. Always favor readability. Be clear.

0. Brevity enhances clarity.

0. Favor generic code but not at the expensive of clarity.

0. Be always aware of the trade offs you make.

0. "Premature optimization is the root of all evil" is not an excuse to do stupid things on purpose!

0. Do not leave unreachable ("dead") code behind.

0. Do not comment out code, that is what version control is for.

0. Take advantage of simple language features that afford great power but avoid the esoteric ones, especially in the type system.

0. Learn and use the most advanced features of your favorite text editor. Make sure to configure it to perform as many formatting functions for you as possible, so that you do not have to think about it: remove whitespace at end of lines, add a newline at end of file, etc. If your editor does not support even those "basic" advanced features, find yourself a better one. :-)

0. Functions should communicate purpose and intent.

    Kent Beck tells the history of a piece of code, a single line method in a word processor, that astonished him the first time he saw it, something like `def highlight(x: X) = underline(x)`. Why write a straightforward alias for the `underline` function, he asked himself? Then he realized the power of this simple abstraction.

    It just so happened that highlights, at that particular point in time, were implemented with underlinings, but that does not mean that highlights and underlines are the same thing, serve the same purpose. Highlights are semantic, underlines are presentational.

    It could be that, in the future, it were decided a highlight should have, say, a yellow background. That would be a trivial change using the method above, taking only but a few seconds. Had they instead used `underline(x)` interchangeably everywhere across the code, one could spend hours looking at each usage site, trying to infer whether the intention of that particular `underline` call was to underline or to highlight.

    That is one of the reasons why simple methods like `def isEmpty = this.length == 0` are extremely valuable. No matter how short the equivalent code they capture may be, abstractions that better express intent and purpose are invaluable.

0. A word about _thin_ models. In object-oriented design, a object is an implementation of an [abstract data type (ADT)](http://en.wikipedia.org/wiki/Abstract_data_type). Objects must define both a set of values _and_ the operations on them. Objects are not Pascal records or C structs glorified with getters and setters. Classes are not just namespaces for methods.

    "Domain Model: An object model of the domain that incorporates both **behavior and data**. [...] there is hardly any behavior on [thin] objects, making them little more than bags of getters and setters. The fundamental horror of this anti-pattern is that it is so contrary to the basic idea of object-oriented design; which is to combine data and process together. The anemic domain model is really just a procedural style design."

    [Martin Fowler](http://www.martinfowler.com/bliki/AnemicDomainModel.html)

0. Always remember Tip 4: "[Do not Live with Broken Windows](http://www.artima.com/intv/fixit.html): Fix each as soon as it is discovered." - The Pragmatic Programmer, Andrew Hunt and David Thomas.

    Part II, [Orthogonality and the DRY Principle](http://www.artima.com/intv/dry.html), is also an interesting read. [Full interview](http://www.artima.com/intv/plain.html).

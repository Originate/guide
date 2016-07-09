# Originate Guides - CoffeeScript Style Guide
* follow the official CoffeeScript syntax on [coffeescript.org](http://coffeescript.org)
* also these more detailed guidelines: [github.com/polarmobile/coffeescript-style-guide](https://github.com/polarmobile/coffeescript-style-guide)
* consider setting up coffeelint
* use guard clauses to avoid code nesting
* methods shouldn't be longer than 10 lines of code.
* as a guideline, files shouldn't be longer than 100 lines of code. Exceptions are okay, but if your class gets too big it's likely it has more than one responsibility. Look if there is another class that wants to emerge.



## Spacing
* one line to separate code blocks
* one line to separate second-level code
  * "it" blocks in specs
* two lines to separate first-level code
  * methods in a class
  * "describe" blocks in specs
* two empty lines to separate top-level elements in the file
  * requires at the beginning of the file
  * module.exports at the end of a file



## Naming
* private elements should be prefixed with an underscore
* javascript-style camelCase for methods and variables, PascalCase for classes, snake_case for filenames.


### Parameter naming
Use named parameters unless the parameters are abundantly clear from the method name
```coffeescript
# This parameter is okay being unnamed
console.log 'hello'

# These parameters are unclear what they mean, they should be named
drawCircle 12, 20, 34, 0.5

# Here is the previous example with named parameters
drawCircle x: 12, y: 20, radius: 34, lineWidth: 0.5

# Arrange long parameters for readability
$.ajax
  url: '/users'
  method: 'POST'
  data: {}
  success: @onSuccess
  error: @onError
```



## Calling methods with unnamed parameters
Sometimes calling methods with unnamed parameters, or a mix of named and unnamed parameters is unavoidable.  For example, when interfacing with a third party library.
The following is a list of styles that can be used to make these calls more readable:

If there aren't too many parameters and they all fit on one line, put them on one line
```coffeescript
copyFile 'user_list', 'user_list_backup'
```

However, if the call is too long, keeping all parameters on the same line quickly becomes unreadable:
```coffeescript
# POOR READABILITY
copyFile 'user_list', 'user_list_backup', overwrite: yes, maxBandwidth: 200, chmod: 0o755
```

If this is the case, you can use one of the following multi-line forms to help readability
```coffeescript
# Indented
copyFile 'user_list',
         'user_list_backup',
         overwrite: yes,
         maxBandwidth: 200,
         chmod: 0o755

# Assign to temp variables for descriptive parameter names
from = 'user_list'
to = 'user_list_backup'
copyFile from, to,
  overwrite: yes
  maxBandwidth: 200
  chmod: 0o755

# Multi-line parentheses
copyFile(
  'user_list'
  'user_list_backup'
  overwrite: yes
  maxBandwidth: 200
  chmod: 0o755
)
```


### Avoid defining functions in class methods
Consider moving function definitions outside of other functions. This changes your thinking from closure-based to stack-based.
This small switch in logic can help eliminate many unintended memory leaks that closures can bring with them.




## Sorting
Alphabetical sorting is the default guideline that should be used in the absence of a better reason to do things differently.
In particular, it applies to
* sorting imports
* sorting methods in a class in the following order
  * static methods
  * constructor
  * public methods (alphabetically sorted)
  * private methods (alphabetically sorted).
* sorting dependencies in package.json



## Naming
### Class Names
* should represent what that object is

```coffeescript
# BAD: unclear what exactly is in this repository
class Repository

# GOOD: Aha, this repo stores users!
class UserRepository

# GOOD: Aha, this is not a real repo, but just a base class!
class BaseRepository
```


### Function names
* should imply what this method does or returns
* performance characteristics should be obvious from the name

```coffeescript
# Aha, this method performs an expensive calculation. Better cache the result!
calculateTotal: ->

# Aha, this method performs a network request. Better not call it hundreds of times in a loop, but find a better way like batch loading!
fetchUser: ->
```



## Documentation
### Self-describing code
The best way to document code bases for seasoned developers is to make them self-describing. Take the time to
* write specs that clearly document the API
* format everything properly
* take the time to think of meaningful names for variables/classes/functions/tests
* document everything properly, especially the public API of your classes and methods.
* clean up technical drift and debt


### Comments
The goal of comments is to round out an already self-describing code base, so that it is easier to understand for people who are new to it,
and [easier to think about on a high level for everybody](http://blog.codinghorror.com/code-tells-you-how-comments-tell-you-why).

Since external documentation expires quickly, the goal is to embed the majority of the documentation into the code base, so that it can live
and evolve together with the code, in each PR.

We don't want to reinvent a static type system in the comments, nor obfuscate the code base with unnecessary and obvious comments just because.

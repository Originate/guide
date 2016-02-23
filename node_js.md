# Node.JS Best Practices

Node.JS provides one of the easiest to learn and use
and at the same time productive programming environments:
A small but flexible programming language,
that allows to create
[universal](https://medium.com/@mjackson/universal-javascript-4761051b7ae9)
applications,
built-in streaming and non-blocking IO,
backed by a rich and very actively developed ecosystem of sophisticated open-source tools and libraries,
on top of one of the fastest runtimes that is always getting even faster.

This article gives an overview of Originate's best practices around [Node.JS](https://nodejs.org).
If you don't know what Node.JS is, please read a few tutorials about it,
for example [this one](http://nodeguide.com/beginner.html).


## Installation

Install Node.js using a package manager,
for example on OS X via [Homebrew](http://brew.sh):

```
$ brew install node
```

Use [n](https://github.com/tj/n)
if you have to deal with different Node.JS versions.


## Languages

The evolution of JavaScript is committee-driven and thereby slow and conservative,
and limited by many of JavaScripts historical warts.
Most of the innovation happens in transpiled languages,
hence they are a natural part of the Node.JS ecosystem.
Use them to your advantage.

For partner-facing projects, pick a widely known language with broad and long-term community and tool support
(including linters, source maps, code coverage measurements, published books, and an active developer community)
like [CoffeeScript](http://coffeescript.org) or [ES6](https://babeljs.io).

For internal projects you can use more experimental languages
like [LiveScript](http://livescript.net).


## Creating new repositories

* Initialize a valid [package.json](https://npmjs.org/doc/json.html) file
  by running `npm init` in your application's directory.

* The package folder structure should follow these conventions:

  <table>
    <tr>
      <th>bin</th>
      <td>any command-line tools that your NPM module provides go here</td>
    </tr>
    <tr>
      <th>dist</th>
      <td>
        the compiled JavaScript goes here.
        This folder should not be added to source control.
      </td>
    </tr>
    <tr>
      <th>src</th>
      <td>
        your source code goes here.
        This folder should not be shipped via NPM.
      </td>
    </tr>
  </table>

  Your main directory should contain these files:

  <table>
    <tr>
      <th>CONTRIBUTING.md</th>
      <td>developer documentation, targeted at maintainers of the library</td>
    </tr>
    <tr>
      <th>LICENSE</th>
      <td>a permissive license that allows usage in commercial projects (e.g. ISC, MIT)</td>
    </tr>
    <tr>
      <th>README.md</th>
      <td>main documentation, targeted at users of the library</td>
    </tr>
    <tr>
      <th>package.json</th>
      <td>the NPM config file</td>
    </tr>
  </table>

* Make copious use of badges to indicate build status, dependency currentness,
  code coverage, code quality, and other metrics in your documentation.

* Don't commit the compiled JavaScript and the `node_modules` directory into Git
  by adding these directories to your `.gitignore` file
  ([example](https://github.com/Originate/observable-process/blob/master/.gitignore)).

* Specify the files to be shipped in an NPM module via the
  [files](https://docs.npmjs.com/files/package.json#files)
  section in your `package.json`.
  Don't ship development-only files like tests, source code etc.


## Dependencies

* If you create a library that is used by other code bases,
  use semantic versioning for your dependencies
  to maintain a certain amount of flexibility for your users
  to use more recent bug fixed versions of dependencies.

* If you create a final product that is to be run somewhere,
  lock down the exact versions of all dependencies using `npm shrinkwrap`
  to be safe from any surprises in production.

* Separate development and production dependencies from each other
  by putting them into the `dependencies` vs `devDependencies` section
  in `package.json`.

* Use [david](https://github.com/alanshaw/david)
  for tracking whether your dependencies are up to date.
  If you work on an open-source project,
  please add a badge that indicates whether your
  dependencies and dev-dependencies are up-to-date.

* Use @charlierudolph`s
  [dependency-lint](https://github.com/charlierudolph/dependency-lint)
  tool to prune out unused dependencies.


## Versioning

The Node.JS ecosystem follows [semantic versioning](http://semver.org/),
so your NPM module must follow it as well


## Testing

* Try to use [Cucumber-JS](https://github.com/cucumber/cucumber-js) for end-to-end testing,
  otherwise [Mocha](https://mochajs.org) or [Mycha](https://github.com/Originate/mycha)
  are good choices as well.
* Use [Mocha](https://mochajs.org) or [Mycha](https://github.com/Originate/mycha)
  for unit testing.


## Releasing to NPM

Simplify your release process
by defining version and publish lifecycle
[scripts](https://docs.npmjs.com/misc/scripts)
in your package.json:

```javascript
 "scripts": {
  "postpublish": "git push && git push --tags",
  "prepublish": "<call your build script here>",
  "preversion": "npm test && npm run update"
},
```

Then, to release a new version of your NPM module, call:

```
$ npm version <patch|minor|major>
$ npm publish
```

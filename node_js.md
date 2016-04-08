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
if you want to run different Node.JS versions on your machine.


## Languages

The evolution of JavaScript is committee-driven and thereby slow and conservative,
and limited by many of JavaScripts historical warts.
Most of the innovation happens in transpiled languages,
hence they are a natural part of the Node.JS ecosystem.
Use them to your advantage.

For partner-facing projects, pick a widely known language with broad and long-term community and tool support
(including linters, source maps, code coverage measurements, published books, and an active developer community)
like [CoffeeScript](http://coffeescript.org) or [ES6](https://babeljs.io).

For internal projects you can use more experimental languages,
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
  code coverage, code quality, and other metrics in your readme.

* Don't commit the compiled JavaScript and the `node_modules` directory into Git
  by adding these directories to your `.gitignore` file
  ([example](https://github.com/Originate/observable-process/blob/master/.gitignore)).

* Specify the files to be shipped in an NPM module via the
  [files](https://docs.npmjs.com/files/package.json#files)
  section in your `package.json`.
  Don't ship development-only files like tests, source code etc.


## Dependencies

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


### Versioning

For your own code, try to follow [semantic versioning](http://semver.org/),
like the rest of the Node ecosystem.

NPM provides a wide range of ways
to specify the versions of your dependencies
in more or less flexible ways.
Unfortunately,
there is no easy to use single best solution for more serious (enterprise-grade)
use cases, so let's discuss the various options in more detail to give you some guidance:

1. __specify no version for your direct dependencies__
  * _example:_ `"fsextra": "*"` or `"fsextra": "latest"`
  * _motivation:_ automatically use the latest state of the art on each deploy
  * _conclusion:_ this is highly unsafe, and should never be used.
    Any breaking change in any of your dependencies will be picked up automatically
    and affect your application.

2. __specify semantically safe versions for your direct dependencies__
  * _example:_ `"fsextra": "^1.2.3"`
  * _motivation:_ your dependencies get automatically updated to the latest semantically "safe" versions
    on each deploy
  * _advantages:_
    - You don't have to constantly update the version of the dependencies your code talks to,
      and your users can take advantages of the latest bug fixes.
  * _disadvantages:_
    - True semantic versioning is an abstract, un-attainable ideal.
      In real life it is an illusion.
      Every bug fix per definition changes existing behavior,
      and even just adding functionality often changes existing behavior in subtle ways.
      Therefore, each version change must be treated as potentially breaking,
      and be tested thoroughly before being used in production.
      The version number change merely provides a hint about
      how impactful the expected change should be,
      which allows you to defer more substantial version upgrades to an appropriate time.
    - Each deploy can use a slightly different set of direct and indirect dependency versions.
      This problem gets worse the more outdated your `package.json` file becomes.
    - You don't know which exact API versions you actually run against.
      If your package.json specifies version `^1.2.3` of a dependency,
      your could actually be using `1.7.9` and wouldn't know it.
      The problem here is that such vast version changes are very likely to
      introduce subtle changes in APIs and functionality that you are not aware of.
      And the only time you will notice this is when a new production deploy suddenly
      stops working.
    - Currently there are no tools that can automatically update
      your `package.json` file with this setup.
  * _conclusion:_
    If you want to make any sort of guarantee that your code uses
    its direct APIs correctly (this applies to almost all of Originate's projects)
    this option isn't reliable enough.
    The only advantage of this approach is
    better availability of certain dependency updates.
    Manual updating of dependencies can (and should) be made efficient
    by dependency tracking services
    ([david-dm.org](https://david-dm.org)),
    tools to automatically bump dependency versions ([david](https://github.com/alanshaw/david)),
    automated releases via CI systems,
    and possibly [tooling](https://github.com/Originate/extra-miles/issues/8)
    that runs all this automatically at regular intervals.

3. __specify the exact versions of your direct dependencies__
  * _example:_ `"fsextra": "1.2.3"`
  * _motivation:_ lock down the APIs that _your_ code talks to,
    but leave management of your dependencies' stability and updates up to them.
  * _advantages:_
    - Can make guarantees that _your code_ interacts with the external world correctly.
    - The exact APIs that your code talks to are clearly documented in package.json
    - Your dependencies can still use newer versions of their dependencies
  * _disadvantages:_
    - Your dependencies can still use newer versions of their dependencies
    - Cannot make guarantees that _your overall application_ works correctly,
      because dependencies of dependencies can still update at any time.
  * _tips:_
    - Run `npm config set save-exact true` to configure your NPM client
      to always store exact version numbers from now on.
  * _conclusion:_ This can make better guarantees than (2),
    but still includes the possibility of sudden and unpredictable breakages.
    It could be okay for prototyping and early-stage development,
    but cannot provide the level of reliabilty required for
    production-quality projects.

4. __specify the exact version of all your dependencies__
  * _example:_ by using a [shrinkwrap](https://docs.npmjs.com/cli/shrinkwrap)
  * _motivation:_ lock down the exact versions of all external APIs
  * _advantages:_
    - Together with NPM's policy that existing versions can never be changed,
      this can make guarantees that your code will always work exactly the same.
  * _disadvantages:_
    - you have to maintain the `npm-shrinkwrap.json` file now
  * _conclusion:_ given that correct semantic versioning is impossible,
    this is the recommended approach for all
    actively developed production-grade projects at Originate.

5. __store the source code of your dependencies together with your code__
  * _example:_

    ```
    # remove `node_modules` from `.gitignore`
    rm -rf node_modules
    npm install --ignore-scripts
    git add . && git commit -a
    npm rebuild
    git status
    # add all new files to .gitignore
    # when deploying on production, you just have to run "npm rebuild"
    ```

  * _motivation:_ store all of the source code that your application needs to run
    in one place, so that it is deployable as-is.
  * _advantages:_
    - You can deploy even when NPM is currently unavailable
    - Your application remains deployable and works exactly the same,
      for years to come,
      even if particular NPM package versions get modified,
      sources of NPM packages go away (GitHub or NPM repos), or
      npmjs.org as a whole gets discontinued.
  * _disadvantages:_
    - a lot of extra code in your repo
    - a lot of noise in PRs when changing dependencies
    - you have to customize the deployment process to run `npm rebuild`
      on the target machine
  * _more info:_ [here](http://www.letscodejavascript.com/v3/blog/2014/03/the_npm_debacle)
  * tips: To avoid cluttering PRs with dependency source code,
    submit them on your own before the PR.
    The code review can assume the correct dependencies are in place.
  * _conclusion:_ This approach should be used for applications in maintenance mode.
    Ideally it is combined with a virtual machine image that prevents bit rot by
    providing a stable run-time environment (same OS, Node, and NPM version etc)


__Guidelines:__

* _actively developed projects_ should do __(3)__ and __(4)__ together:
  use exact versioning in package.json
  to document what exact API versions your code is designed against,
  plus a shrinkwrap to lock down all versions of all dependencies
  for stability.

* _projects in maintenance mode_ should do __(3)__, __(4)__, and __(5)__ together

* this applies equally to _libraries_ (code that is used by other Node.JS code)
  as well as _servers_ (code that runs by itself).
  This distinction is artificial and doesn't hold up in real life.
  Almost all "servers" should (and do) provide JS APIs to call them from other code Node code
  in addition to running them by themselves from the command line.
  Examples: NPM itelf, Mocha, Cucumber-JS, etc.

* dependencies of all NPM modules should be updated at least once a month,
  ideally using [o-tools](https://github.com/Originate/o-tools-node).


## Testing

* Try to use [Cucumber-JS](https://github.com/cucumber/cucumber-js) for end-to-end testing,
  otherwise [Mycha](https://github.com/Originate/mycha) or [Mocha](https://mochajs.org)
  are good choices as well.
* Use [Mycha](https://github.com/Originate/mycha) or [Mocha](https://mochajs.org)
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

Set up CI to `npm publish` your package when pushing to the `release` branch.
This can be accomplished on CircleCI by adding the following to your `circle.yml`:
```yaml
deployment:
  publish:
    branch: release
    commands:
      - npm set //registry.npmjs.org/:_authToken $AUTH_TOKEN
      - npm publish
```
Then set the `AUTH_TOKEN` environment variable in the project settings in CircleCI. Ping Alex David, or Kevin Goslar for Originate's `AUTH_TOKEN`.

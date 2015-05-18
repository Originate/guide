Environment Set Up
-----

You will want to install Node.JS and its package manager, NPM.

Newer versions of Node.JS come with NPM bundled with it. If you have Node installed but not NPM, please update your version of Node. Using the standalone NPM install is not recommended as it will break when attempting to update Node.

Mac OS X via Homebrew
-----
```
$ brew install nodejs
```

Package.json Overview
-----

Every Node app should have a package.json file. This file makes it easy to install and keep track of dependencies, define your test scripts, and start your server. It is also required to publish NPM packages and deploy to production.

You can generate a new package.json file for the current working directory by running  $ npm init. Running npm init will also find any packages you have installed and add them to your dependency list automatically.

More documentation on package.json can be found here: [https://npmjs.org/doc/json.html](https://npmjs.org/doc/json.html)

Getting started on your first Node.JS app
-----

Node.JS uses the V8 Javascript engine so any valid ES5 syntax should be supported.

Create a new file called hello_world.js with the following contents:
```
console.log('Hello World');
```
Now you can run this file with:

```
$ node hello_world.js
```

NPM
---

Install packages with NPM. To install a package from the [NPM package database](https://www.npmjs.com/) run

```
$ npm install PACKAGE_NAME
```

This installs the package into `./node_modules/PACKAGE_NAME` in the current working directory.

Some tools that are not project-specific, for example coffee-script, should be installed globally. To install a package globally run

```
$ npm install -g PACKAGE_NAME
```

This installs the package into /usr/local/share/npm in the current working directory.

If you are using NPM packages as dependencies for your project, you should add the package to the dependencies block in package.json.

Testing and building libraries should be added to the devDependencies block in package.json. These will only be installed when installing the package directly and not as a dependency for another package.

If you already have installed packages in the current working directory and you don't have a package.json file yet, running $ npm init  will automatically add the installed packages to the dependencies block.

Running `$ npm install` (with no package names as arguments) in a directory with a package.json file, it will automatically install the packages found in the dependencies block in the file.

If you are tracking your project in git, it is a good idea to add the node_modules directory to your .gitignore file and keep all dependencies listed in your package.json file.

Require
-----

Node.JS uses require statements to include other files and packages. There are three types of modules you can require:

* Node.JS's core modules, such as the [HTTP Module](https://nodejs.org/api/http.html)
  * You can require one of [Node.JS's core modules](https://nodejs.org/api/)
  * Example: `require('http');`
* Other javascript files and packages
  * Requiring a path will include the js file or package at that path
  * Example:  `require('./my-file.js');`
* Packages installed via NPM
  * When requiring packages that aren't core packages and aren't file paths node will automatically walk up the directory tree looking for the package in `./node_modules/PACKAGE_NAME`
  * If the package isn't found it will look in the Node.JS global package directory  `/usr/local/share/npm`
  * Example: The project is in `/foo/bar/baz`. Using `require('my-package');` looks for the package in the following locations in order:
    1. `/foo/bar/baz/node_modules/my-package`
    2. `/foo/bar/node_modules/my-package`
    3. `/foo/node_modules/my-package`
    4. `/node_modules/my-package`
    5. `/usr/local/share/npm/my-package`


Testing
-----

Originate has developed its own Node.js testing library Mycha [https://github.com/Originate/mycha](https://github.com/Originate/mycha).

Continuous integration
-----

Mycha can be used for CI as well through [Travis-CI](http://docs.travis-ci.com/user/languages/javascript-with-nodejs/) or [Circle CI](https://circleci.com/docs/language-nodejs)

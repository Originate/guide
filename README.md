# Originate Guides

This guide is the starting point for Originate engineers, product managers, and testers.
It gives an overview of our tech stack and best practices around engineering related topics.

### Engineering Process Practices

* [Git](practices/git.md)
* [Code Reviews and Pull Requests](practices/pull_requests.md)
* [Security](security/README.md)
* [Open Sourcing](practices/open_sourcing.md)
* [VIM](editors/vim.md)


### Technology Stack Guides

__Mobile:__
* [Android](android/README.md) and [iOS](ios/README.md) for fully native experiences with top performance
* _React Native_ for cost-effective hybrid cross-platform solutions that aren't performance sensitive

__Backend:__
* [Golang](go/README.md) for Ops and CLI tools, as well as network services and APIs
* [Node.JS](javascript/node_js.md)
  using established languages like
  [CoffeeScript](javascript/coffeescript.md), _ES6_, or _TypeScript_
  for small IO-heavy services with little compute requirements
  and when using only one language for both frontend and backend has advantages.
* [Scala](scala/README.md)
  for big code bases, complex business logic, large-scale data processing,
  or anything on top of the JVM/Apache ecosystem

__Frontend:__
* _React_ for rich web UIs
* _WebPack_ for compiling front-end assets

__Devops:__
* _Ansible_ for configuration management
* _Docker_ for packaging software into containers
* _Packer_ for creating machine and container images
* _Terraform_ for infrastructure-as-code

__Others:__
* [Haskell](haskell/README.md)
* _LiveScript_ for internal projects based on Node.JS
* _Python_ for machine learning
* [Ruby on Rails](ruby/rails.md)
  for rapid prototyping and small to mid-sized monolithic projects without much traffic


### Software Practices

* [Story Writing](product/story.md)
* [Product Management Toolkit](product/product_toolkit.md)
* [Feature Specs with Cucumber](cucumber.md)

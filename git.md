# The Originate Guide to Git

These are recommendations. They should be followed in the absence of good, justifiable reasons to do things differently.


## Branches

We follow the [Nvie branching model](http://nvie.com/posts/a-successful-git-branching-model/).

* One (or more) feature branches per user story.
* Refactorings and bug fixes should be in their own feature branches, and be reviewed separately.
* Feature branches are named like "[developer initials]-[feature-name]", e.g. __kg-new-settings-page__
* feature branches are cut from the __development__ branch, and get merged into it
* the __development__ branch matches the _development_ server
* the __master__ branch matches what is in production
* other servers have long-lived branches that match them by name: the __staging__ branch matches the _staging_ server etc


## Commits

* Each commit should contain only one particular change. Its okay (and encouraged) to have many small commits during development.
* Commit frequently during your work, each time a dedicated change is done and the tests pass. Don't accumulate dozens of changes before committing. Rather, get into the habit of doing one thing at a time, committing it, then do the next.
* Always review your work before committing it. 
* Commit messages should have a 50 characters summary written in imperative ("fix signup") if possible, or as a short summary for features ("logout button"), followed by an empty line, followed by an optional longer description.


## Pull Requests

Pull requests are how we ensure quality and share knowledge. The goal is for everyone to hold one another to a high standard, for everyone to learn from each other, and to catch architectural and other mistakes before they make it into the main branch. The tone should be constructive and positive.

* everyone can (and should) review everyone else's pull requests
* refactorings should be reviewed by the tech lead or architect
* every feedback given in a PR must be at least addressed, i.e. if you don't want to do it, say why and come to an agreement with your reviewer about this issue. Getting a third opinion is a good option.
* finding and pointing out issues in PRs is a good thing. Bonus points if you find issues in the code of senior people!
* you need to tag the reviewers in the description of your pull request (`@username`).
* every piece of code (backend, database changes, HTML, CSS) must be reviewed. You can use multiple reviewers for different types of code.
* mark pull request that should not be merged as "WIP" in the PR title ("WIP: new settings page")
* No comments on a PR means the review was not throurough enough. Getting comments on your PR is good, it means you are alive and learning. The learning never ends!
* Well written code bases get reviewed in one iteration (one set of comments, one round of fixes, good to go). If your reviews usually take several rounds, try to be more thorough before sending off PRs.
* When a PR gets LGTMed ("looks good to me"), it will be merged by the author, and the feature branch deleted from both the local machine as well as from Github.

Here is a check list for reviewers:

* Is every piece of code in the right place, i.e. model code in a model, controller logic in a controller, app-specific helper code in a helper, generic helper code in a library?
* Do all classes have only one responsibility?
* Do all methods do only one thing?
* Are all classes/methods/variables named properly so that the code is self-describing?
* Is everything as private as possible, i.e. no things public that don't need to be public?
* Are not too many things private?
* Are all files within a reasonable size (less than 100 loc)?
* Are all methods less than 10 loc?
* No law of demeter violations (providing whole objects to methods when all that's needed is the value of one attribute of them)?
* Is everything tested? Is each thing tested enough? Is it not over-tested?
* Every class should have a small comment describing what it represents/does. * Public methods should have comments describing what they are for, or when to call them, if this isn't obvious from the code. Comments shouldn't describe what the method does (this is visible from looking at the code).
* Are there any obvious performance-stupidities, like making a database query for each loop iteration, rather than using a more optimized query that loads all data at once? 
* Spacing errors like no empty line between methods, or too many empty lines
* There shouldn't be any commented-out code.
* There should be no debug statements like "console.log" or the likes.


### Breaking Up Large Branches

See our blog post about [Refactoring Git Branches](http://blog.originate.com/blog/2014/04/19/refactoring_git_branches).


## Tools

The best Git tool is the command line. It is easy to learn and use, and makes the full power of Git available. An exception to this are highly interactive things like reviewing and staging changes for commits, looking at git history, or similar things.

### OS X
* __[GitX](http://gitx.frim.nl):__ free, very lean, provides the things that are better done in a visual tool than on the command line: staging, committing, looking at history.
* __[Github for Mac]__
* __[Tower]()__
* __[SourceTree]()__

### Conflict Resolution
- Araxis Merge
- vimdiff
- FileMerge

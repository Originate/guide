# Originate Guides - Git

These are recommendations. They should be followed in the absence of good, justifiable reasons to do things differently.

## GitHub user account

Please make sure you have [2 factor authentication](https://github.com/settings/security) enabled.
Your GitHub account is used to access a lot of things,
and it is important to know that changes really come from you,
even if you work on open-source code.


## Git Best Practices

- [Git flight rules](https://github.com/k88hudson/git-flight-rules/blob/master/README.md)

### Branches

* One (or more) feature branches per user story.
* Refactorings and bug fixes should be in their own feature branches, and be reviewed separately.
* Feature branches are named like "[developer initials]-[feature-name]", e.g. __kg-new-settings-page__
* feature branches are cut from the __development__ branch, and get merged into it
* the __development__ branch matches the _development_ server
* the __master__ branch matches what is in production
* other servers have long-lived branches that match them by name: the __staging__ branch matches the _staging_ server etc
* if the project integrates with a ticket-tracking system, feature branches should be named using the
following convention: "[developer initials]-[ticket key]-[feature-name]", e.g. `kg-OR-16-new-settings-page`. *Note that
JIRA expects the ticket key to be capitalized.*

### Commits

* Each commit into the main branch should contain only one particular change.
* Commit frequently during your work,
  each time a dedicated change is done and the tests pass.
  Don't accumulate dozens of changes before committing.
  Rather, get into the habit of doing one thing at a time,
  reviewing and committing it when done,
  then doing the next.
* Always review your work before committing it.
* Squash the commits on your feature branch,
  or do a squash commit when merging into the main branch,
  so that it appears there as a single atomic commit.
* Write [good commit messages](http://chris.beams.io/posts/git-commit):
  A 50 character summary written in imperative ("fix signup")
  or as a short summary for features ("logout button"),
  followed by an empty line,
  followed by an optional longer description.


### Resolving conflicts

Conflicts happen when two developers change the same line in the same file at the same time.
To resolve them
* use `git status` to see which files have conflicts
* open the conflicting files in your editor and resolve the conflicts. Make sure you consider that both sides of the conflict contain changes that happened at the same time, so both changes should be present in your resolved code.

```shell
# resolve conflicts in your text editor
$ git add [path of resolved file]
$ git rebase --continue
```


### Pull Requests

When you are done with a feature, submit a pull request so that it can be reviewed and merged into the development branch.

Pull requests are how we ensure quality and share knowledge. The goal is for everyone to hold one another to a high standard, for everyone to learn from each other, and to catch architectural and other mistakes before they make it into the main branch. The tone should be constructive and positive.

* Everyone can (and should) review everyone else's pull requests.
* Refactorings should be reviewed by the tech lead or architect.
* All feedback given in a PR must be at least addressed, i.e. if you don't want to do it, say why and come to an agreement with your reviewer about this issue. Getting a third opinion is a good option.
* Finding and pointing out issues in PRs is a good thing. Bonus points if you find issues in the code of senior people!
* You need to tag the reviewers in the description of your pull request (`@username`). This is especially important on larger projects because it helps people know what PRs need their attention.
* Every piece of code (backend, database changes, HTML, CSS) must be reviewed. You can use multiple reviewers for different types of code.
* Mark pull requests that should not be merged as "WIP" in the PR title ("WIP: new settings page").
* No comments on a PR means the review was not thorough enough. Getting comments on your PR is good, it means you are alive and learning. The learning never ends!
* Well written codebases get reviewed in one iteration (one set of comments, one round of fixes, good to go). If your reviews usually take several rounds, try to be more thorough before sending off your PRs.
* When a PR gets LGTMed ("looks good to me"), it will be merged by the author, and the feature branch should be deleted from both the local machine as well as from Github.

Here is a check list for reviewers:

* Is every piece of code in the right place, i.e. model code in a model, controller logic in a controller, app-specific helper code in a helper, generic helper code in a library?
* Do all classes have only one responsibility?
* Do all methods do only one thing?
* Are all classes/methods/variables named properly so that the code is self-describing?
* Is everything as private as possible, i.e. no fields/methods made public that aren't used externally?
* Are all files within a reasonable size (less than 100 loc)?
* Are all methods less than 10 loc?
* No law of demeter violations (providing whole objects to methods when all that's needed is the value of one attribute of them)?
* Is everything tested? Is each thing tested enough? Are things over-tested?
* Are there any obvious inefficiencies, like making a database query for each loop iteration, rather than using a more optimized query that loads all data at once?
* Spacing errors like no empty line between methods, or too many empty lines.
* There should not be any commented-out code. Commented code should be removed.
* There should not be any debug statements like "console.log" or the like.


### Breaking Up Large Branches

See our blog post about [Refactoring Git Branches](http://blog.originate.com/blog/2014/04/19/refactoring_git_branches).


### Merging

If possible, do a squash merge. Advantages of squash merges:
* The Git history contains only one clean commit per feature / bug fix
* The Git history is one straight line of linear commits, instead of the typical Git spaghetti branch madness
* `git bisect` becomes a possibility again
* A `git blame` not only tells you who wrote a line of code, but also why (i.e. the bigger context of a change)
* Confusing detours during development are no longer visible in the final commit
* Each change provides the whole context of the change ("the user is set to null because of this feature")
* Easier cherry-picking of features/bug fixes as part of the release process: when a release is broken, we can leave broken features out and release anyway
* Easier naming of commits: name your development commits any way you want, and for the final commit copy-and-paste the ticket title and description


## Tools

The best Git tool is the command line.
It is easy to learn and use,
and makes the full power of Git available.
In addition to the command line,
it is often helpful to have a visual representation of your Git tree
and an interactive tool for staging changes/making commits.
Here are some tools used by Originate developers:

### Command Line

* __[Git Town](http://www.git-town.com):__ high-level command-line interface for Git


### OS X
* __[GitX](http://gitx.frim.nl):__ free, very lean, provides the things that are better done in a visual tool than on the command line: staging, committing, looking at history.
* __[Github Desktop for Mac](https://desktop.github.com/)__
* __[Tower](https://www.git-tower.com/)__
* __[SourceTree](https://www.atlassian.com/software/sourcetree)__


### Conflict Resolution
- [Araxis Merge](http://www.araxis.com/merge/)
- [vimdiff](http://vimdoc.sourceforge.net/htmldoc/diff.html)
- [FileMerge](https://developer.apple.com/xcode/features/) (part of Xcode by Apple)

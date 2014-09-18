# Code Reviews

At Originate, we strive to be humble engineers that are always ready to learn from each other and improve our skills. Code reviews are one of the best
tools we have to ensure this. Since we use GitHub to host all of our projects, code reviews come in the form of pull requests.

## What is a Pull Request

When we work on adding a feature to a codebase, we do it in a separate Git branch. Before the branch is ready to be merged into master, we create a Pull
Request (PR for short) that visualizes the changes that the developer wants to make. Other team members can make sure the changes are good, or suggest
improvements.

## Why Pull Requests

As humans, we are not perfect machines. To make matters worse, we all have egos that want us to be right all the time, even when we are not. Realizing that you
do not always have the right answers and learning to accept helpful criticism improves your projects and more importantly your own development. Once you come to
terms with this, you’ll find that the pull request allows you to learn extremely fast and constantly raise the bar on your team’s code quality.

We use TDD to catch bugs during our own development cycles, but code reviews catch a different subset of bugs, things like: bad variable names, wrong assumptions,
bad code structure/architecture, performance issues, security issues, repeated code, etc. The average bug count is 4.5 errors per 100 lines of code, with code reviews,
the bug rate drops down to 0.8 (from: [Code Complete: A Practical Handbook of Software Construction](http://www.amazon.com/Code-Complete-Practical-Handbook-Construction/dp/0735619670)).
Additionally, code reviews provide a tight feedback loop that improves learning and knowledge transfer between developers on a project. Using TDD and code reviews
together provides us with the fastest feedback mechanism for ensuring application behavior, sharing knowledge, holding each other to high standards, producing readable
and maintainable code, and allowing new people on a project to ramp up quickly.

Another benefit you get from doing code reviews is that you end up reading a lot of code, and as such, you hone that skill. Getting good at reading code is
its own reward. It will make you faster at solving your own problems, and if you agree with this:
[Learn To Read The Source Luke](http://blog.codinghorror.com/learn-to-read-the-source-luke/),
you’ll find that bad documentation will never stand in your way again (ironically, stackoverflow will become less useful for languages where you have access to
all of the source).

## Readability and Maintainability

Originate is successful when we build projects that are readable and maintainable. Our partners eventually take over the codebases that we work on, and we
strive to show them a clean and efficient development process and leave them with a codebase they are proud of and happy to work on.

One of the fastest ways to create convoluted and unreadable code is to let someone code alone. Having your team read your code will allow them to point out
things that are hard to understand, with the ultimate goal of striving towards a codebase that is a pleasure to read through. The knowledge
that someone will be reading your code forces you to not be lazy, to think about proper naming of variables, and to consider that style consistency is important.
This should result in less comments in the code that look like: `//TODO: make this work`.

## Giving Effective Feedback

Since the goal of pull requests is to help people improve and learn from each other, there are some simple rules we can follow to make this more efficient.
The most important thing is that you have to realize that nobody is perfect, neither reviewer nor reviewee. When a reviewer sees something that is questionable,
it’s arrogant to assume that it is wrong. Always better to ask “is this supposed to do X?” or point out “i’m confused, it seems like this is supposed to do X”.
Additionally, it would be arrogant for a reviewee to assume that the reviewer is stupid because they are confused about the code. It’s actually good when
you recognize that your reviewer is confused, because that cues you to improve the understandability of your code.

One thing to keep in mind is that it’s extremely easy to write code that a computer understands (we all do it, all day, it’s our job). Martin Fowler put it
best in __Refactoring: Improving the Design of Existing Code__:

> “Any fool can write code that a computer can understand. Good programmers write code that humans can understand.“


## Who Does Code Reviews

We all review each other. Junior developers should review senior developers’ code as much as senior developers review junior developers’ code. This has two
extra benefits:

* It evens the playing field, and helps everyone feel like they are on the same page.
* Senior developers will be challenged to reaffirm their assumptions when junior developers question things they assume and take for granted.


## What If We Can’t Agree

Every now and then, two engineers will come to a standstill. At this point it’s important to take a step back and realize that the real goal is not to be
right, but to find the best solution. If one person believes the other person to be getting out of hand, it’s useful to ping them outside of the PR and ask
“Did i offend you?”. More often than not, this will lead to both parties realizing that there is a miscommunication.

If the argument is over something arbitrary, you can ask your tech lead for help. If the reviewer insists, sometimes it’s helpful to continue the conversation in person or over the phone. Text-based conversation loses much of the subtleties of communication, and as such sometimes you need
to hear someones voice to come to an agreement. In this case, you will often find out that while you thought the reviewer was being harsh, it was actually a
miscommunication. These things happen.

In order to avoid situations like this, always remember that we review the code, not the other person. Criticism should be taken professionally and not personally.

## Workflow

* submit PR
* tag relevant parties (using GitHub’s `@username`)
* describe changes
* add comments about parts you need help with/are unsure about/etc
* people review
* discuss/make changes per review
* if people sign off/you get LGTM, then you can merge and delete the branch

## Code Review Cheat Sheet

If you are new to code reviews, you can use this cheat sheet to help give you a list of things to look for when reviewing someone's code.

* Is every piece of code in the right place, i.e. model code in a model, controller logic in a controller, app-specific helper code in a helper,
generic helper code in a library?
* Do all classes have only one responsibility?
* Do all methods do only one thing?
* Are all classes/methods/variables named properly so that the code is self-describing?
* Is everything as private as possible, i.e. no things public that don't need to be public?
* Are too many things private?
* No law of demeter violations (providing whole objects to methods when all that's needed is the value of one attribute of them)?
* Is everything tested? Is each thing tested enough? Is it not over-tested?
* Comments shouldn't describe what the method does (this is visible from looking at the code).
* Are there any obvious performance-stupidities, like making a database query for each loop iteration, rather than using a more optimized query
that loads all data at once?
* Spacing/style issues like no empty line between methods, or too many empty lines
* There shouldn't be any commented-out code.
* There should be no debug statements like `console.log("here")` etc.
* There should be no TODO's, this is often a crutch for being lazy.

## Tips

* Try to avoid tagging too many people in pull requests (in most cases 2 is the max)
* If your pull request contains changes to both frontend and backend code, tag someone from each team and tell them what to review
* Try to keep pull requests small. bigger pull requests are harder to review effectively, and often sit for longer. if you need help figuring out how to
break up a pull request that became massive, see: [Refactoring Git Branches](http://blog.originate.com/blog/2014/04/19/refactoring_git_branches/)
* Expect to get affirmations that the PR is ready to merge by your reviewers. something like “LGTM” (looks good to me), “ship it”, a thumbsup GIF, or sheep
icon (or any permutation of these).
* The creator of the pull request merges! this is to maintain accountability. If reviewers are neglecting you, you can bump the PR or send them a message.
* A good trick for making sure you’ve addressed most of the comments is to look at the pull request for a bunch of “username commented on an outdated diff”
messages. These appear when changes are made to lines that a reviewer commented on.

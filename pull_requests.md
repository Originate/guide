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
bad code structure/architecture, performance issues, security issues, repeated code, etc. The average bug count is 4.5 errors per 100 lines of code. With code reviews,
the bug rate drops down to 0.8 (from: [Code Complete: A Practical Handbook of Software Construction](http://www.amazon.com/Code-Complete-Practical-Handbook-Construction/dp/0735619670)).
Additionally, code reviews provide a tight feedback loop that improves learning and knowledge transfer between developers on a project. Using TDD and code reviews
together provides us with the fastest feedback mechanism for ensuring application behavior, sharing knowledge, holding each other to high standards, producing readable
and maintainable code, and allowing new people on a project to ramp up quickly.

Another benefit you get from doing code reviews is that you end up reading a lot of code, and as such, you hone that skill. Getting good at reading code is
its own reward. It will make you faster at solving your own problems, and if you agree with this:
[Learn To Read The Source Luke](http://blog.codinghorror.com/learn-to-read-the-source-luke/),
you’ll find that bad documentation will never stand in your way again (ironically, stackoverflow will become less useful for languages where you have access to
all of the source).

In summary, the code review process serves the following purposes:
* __knowledge transfer__
  * team members learn tricks and best practices from each other
  * better use of experts: 5-10% of their time spent reviewing code can make a meaningful contribution to a team
  * within a few months of serious code reviews, every team member writes code on the level of the best developer
* __better team work__
  * ensuring agreed upon coding practices are followed
  * team develops common code style while reviewing each others code
  * better collaboration of remote teams
  * more people stay up to date with whats going on in other parts of the code base → they can fix bugs there
* __better code quality__
  * team develops culture of high code quality (people are less sloppy if somebody else is looking)
  * Identify issues in code that are not found through automated testing: poor code structure/architecture, performance bottlenecks, bad variable naming, etc
  * Find and eliminate defects in the code early (when they are cheap to fix)
* __feedback for developers__
  * how good good/bad/average is my code?
  * where am I in comparison to my peers?
  * what is possible?
  * how do others solve interesting problems?


## Guidelines submitting a code review

* Limit the total amount of code for a review to a single logical change.
  Submit several pull requests for independent changes.
  [Split up your feature branch](http://blog.originate.com/blog/2015/02/13/refactoring-git-branches-part-ii/) if necessary.
* No more than 200–400 lines of code per PR
* Review your code yourself before sending off the pull request, and clean it up as much as possible.
* Add missing documentation/tests
* Tag at least one person to do the review. Significant changes need approval from at least two reviewers before they can get merged.
  You can tag more people, but be mindful of people's time and productivity.
  If you tag them, they will have to spend time looking at your PR.
* You must address all comments, by either
  * implementing them (and acknowledge that through a comment)
  * complex changes coming out of a comment can be implemented separately, but that must be tracked through a separate JIRA ticket (and you gave your word to do it)
  * convincing the reviewer why your version is better
  * deferring to a face-to-face conversation in case there is a lot of back and forth
  * if you and your reviewer both have valid opinions and can't agree which one to choose here,
    even after musing about it over lunch or a beer, seek a third party to resolve this and avoid lengthy debates.
    The tech lead is a good default person for this, and has the last word in code reviews anyways.
* when you get the LGTM ("looks good to me"), merge your branch and delete it from both your local machine and from Github


## Guidelines for reviewing a code review

Since the goal of pull requests is to help people improve and learn from each other, there are some simple rules we can follow to make this more efficient.
The most important thing is that you have to realize that nobody is perfect, neither reviewer nor reviewee. When a reviewer sees something that is questionable,
it’s arrogant to assume that it is wrong. Always better to ask “Is this supposed to do X?” or point out “I’m confused, it seems like this is supposed to do X.”
Additionally, it would be arrogant for a reviewee to assume that the reviewer is stupid because they are confused about the code. It’s actually good when
you recognize that your reviewer is confused, because that cues you to improve the understandability of your code.

One thing to keep in mind is that it’s extremely easy to write code that a computer understands (we all do it, all day, it’s our job). Martin Fowler put it
best in __Refactoring: Improving the Design of Existing Code__:

> “Any fool can write code that a computer can understand. Good programmers write code that humans can understand.“

* be polite and constructive, make concrete suggestions.
  Remember that written language lacks emotional context and body language, and is easily misunderstood.
* If you are tagged, you have to look at the code. You can still look at other pull requests if you want to
* Do the code review within half a day of when you are tagged. The other person cannot ship their feature without your feedback!
* Keep discussions short, if the conversation goes back and forth more than 2 times, its probably better to talk in person
* the tech lead has the last word in disagreements
* things to look out for in a code review
  * Is every piece of code in the right place, i.e. model code in a model, controller logic in a controller, app-specific helper code in a helper, generic helper code in a library?
  * Do all classes have only one responsibility?
  * Do all methods do only one thing?
  * If a method has a side-effect, is that clear from the name, and otherwise documented?
  * Are all classes/methods/variables named properly so that the code is self-describing?
  * Is everything as private as possible, i.e. only the intended public interface is public?
  * Are too many things private? This could be an indication that you should extract a class.
  * Are all files within a reasonable size (e.g., less than 100 lines of code)?
  * Are all methods less than 10 lines of code?
  * No law of demeter violations (providing whole objects to methods when all that’s needed is the value of one attribute of them)?
  * Is everything tested? Is each thing tested enough? Is it not over-tested?
  * Are there tests for private methods? This shouldn't happen, it is a code smell.
  * Every class should have a small comment describing what it represents/does. Public methods should have comments describing what they are for, or when to call them, if this isn’t obvious from the code. Comments shouldn’t describe what the method does (this is visible from looking at the code).
  * Are there any obvious performance-problems, like making a database query for each loop iteration, rather than using a more optimized query that loads all data at once?
  * Spacing errors like no empty line between methods, or too many empty lines
  * There shouldn’t be any commented-out code.
  * There should be no debug statements like `console.log` or the likes.
  * There should be no TODO's, as this is often a crutch for being lazy.


## Who Does Code Reviews

We all review each other. Junior developers should review senior developers’ code as much as senior developers review junior developers’ code. This has two
extra benefits:

* It evens the playing field, and helps everyone feel like they are on the same page.
* Senior developers will be challenged to reaffirm their assumptions when junior developers question things they assume and take for granted.


## What If We Can’t Agree

Every now and then, two engineers will come to a standstill. At this point it’s important to take a step back and realize that the real goal is not to be
right, but to find the best solution. If one person believes the other person to be getting out of hand, it’s useful to ping them outside of the PR and ask
“Did I offend you?”. More often than not, this will lead to both parties realizing that there is a miscommunication.

If the argument is over something arbitrary, you can ask your tech lead for help. If the reviewer insists, sometimes it’s helpful to continue the conversation in person or over the phone. Text-based conversation loses much of the subtleties of communication, and as such sometimes you need
to hear someone's voice to come to an agreement. In this case, you will often find out that while you thought the reviewer was being harsh, it was actually a
miscommunication. These things happen.

In order to avoid situations like this, always remember that we review the code, not the other person. Criticism should be taken professionally and not personally.


## Workflow

* Submit PR
* Tag relevant parties (using GitHub’s `@username`)
  * If your pull request contains changes to both frontend and backend code, tag someone from each team and tell them what to review.
* Describe changes
* Add comments about parts you need help with/are unsure about/etc.
* Its your responsibility to get your code reviewed and submitted. If reviewers neglect you, bump the PR or send them a (friendly) reminder.
* People review
* Discuss/make changes per review
* If people sign off/you get LGTM, then you can merge and delete the branch

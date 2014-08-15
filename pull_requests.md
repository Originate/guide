# Code Reviews

At Originate, we strive to be humble engineers that are always ready to learn from each other and improve our skills. Code reviews are one of the best
tools we have to ensure this. Since we use GitHub to host all of our projects, code reviews come in the form of pull requests.

## What is a Pull Request

When we work on any logical change to a codebase, it is done in its own git branch. Before the branch is ready to be merged into master, we create a Pull
Request (PR for short) that presents an interactive context around the diff of that branch so that other members of the team can vet that the changes are good.

## Why Pull Requests

As humans, we are extremely prone to error and bad habits. To make matters worse, we all have egos that want us to be right all the time. In order to be
the best you can be, you have to realize that you do not always know the answer, and you are not perfect. Once you come to terms with this, you’ll find
that the pull request allows you to learn extremely fast and constantly raise the bar on your team’s code quality.

While there are other tools one can employ for code quality (TDD, pair programming, etc…), the goal is to have a tight feedback loop to improve learning.
TDD provides us with the fastest feedback loop for ensuring application behavior, and we pair it along with code reviews to share knowledge, hold each other
to high standards, produce readable and maintainable code, identify bugs early, and allow new people on a project to ramp up quickly.

Another benefit you get from doing code reviews is that you end up reading a lot of code, and as such, you hone that skill. Getting good at reading code is
its own reward. It will make you faster at solving your own problems, and if you agree with this:
[Learn To Read The Source Luke](http://blog.codinghorror.com/learn-to-read-the-source-luke/),
you’ll find that bad documentation will never stand in your way again (ironically, stackoverflow will become less useful for languages where you have access to
all of the source).

## Readability and Maintainability

Originate is successful when we build projects that are readable and maintainable. Our partners eventually take over the codebases that we work on, and we
strive to show them a clean and efficient development process and leave them with a codebase they are proud of and happy to work on.

One of the fastest ways to create convoluted and unreadable code is to let someone code alone. Having your team read your code will allow them to point out
things that are hard to understand, with the ultimate goal of striving towards a codebase that is a pleasure to read through. Additionally, the knowledge
that someone will be reading your code forces you to not be lazy, to think about proper naming of variables, to consider that style consistency is important,
and fix things that would otherwise become a “TODO: make this work”.

## Giving Effective Feedback

Since the goal of pull requests is to help people improve and learn from each other, there are some simple rules we can follow to make this more efficient.
The most important thing is that you have to realize that nobody is perfect, neither reviewer nor reviewee. When a reviewer sees something that is questionable,
it’s arrogant to assume that it is wrong. Always better to ask “is this supposed to do X?” or point out “i’m confused, it seems like this is supposed to do X”.
On the contrary, it would be arrogant for a reviewee to assume that the reviewer is stupid because they are confused about the code. It’s actually good when
you recognize that your reviewer is confused, because that cues you to improve the understandability of your code.

One thing to keep in mind is that it’s extremely easy to write code that a computer understands (we all do it, all day, it’s our job). Martin Fowler put it
best in __Refactoring: Improving the Design of Existing Code__:

> “Any fool can write code that a computer can understand. Good programmers write code that humans can understand.“


## Who Does Code Reviews

We all review each other. Junior developers should review senior developers’ code as much as senior developers review junior developers’ code. This has two
extra benefits:

* It evens the playing field, and helps everyone feel like they are on the same page, rather than getting defensive because their boss is being harsh on them.
Junior developers can quickly absorb knowledge from senior ones.
* Senior developers will be challenged to reaffirm their assumptions when junior developers question things they assume and take for granted. This helps senior
developers avoid “stubborn old fool” syndrome.


## What If We Can’t Agree

Every now and then, two engineers will come to a standstill. At this point it’s important to take a step back and realize that the real goal is not to be
right, but to find the best solution. If one person believes the other person to be getting out of hand, it’s useful to ping them outside of the PR and ask
“Did i offend you?”. More often than not, this will lead to both parties realizing that there is a miscommunication.

If the argument is over something arbitrary, you can ask your tech lead for help. If the reviewer insists, sometimes it’s helpful to take the conversation
to a richer medium. Text-based conversation loses much of the subtleties of communication, and as such sometimes you need to hear someones voice to come to
an agreement. In this case, you will often find out that while you thought the reviewer was being harsh, it was actually a miscommunication. These things happen.


## Workflow

* submit PR
* tag relevant parties (using GitHub’s `@username`)
* describe changes
* add comments about parts you need help with/are unsure about/etc
* people review
* discuss/make changes per review
* if people sign off/you get LGTM, then you can merge and delete the branch

## Tips

* For a moderately sized pull request, tag 2 members of your team
* If your pull request contains changes to both frontend and backend code, tag someone from each team
* Try to keep pull requests small. bigger pull requests are harder to review effectively, and often sit for longer. if you need help figuring out how to
break up a pull request that became massive, see: [Refactoring Git Branches](http://blog.originate.com/blog/2014/04/19/refactoring_git_branches/)
* Expect to get affirmations that the PR is ready to merge by your reviewers. something like “LGTM” (looks good to me), “ship it”, a thumbsup GIF, or sheep
icon (or any permutation of these).
* The creator of the pull request merges! this is to maintain accountability. If reviewers are neglecting you, you can bump the PR or send them a message.
* Reviewers will often comment on minor things and then say LGTM, it’s up to you if you want to address the comments in this case.
* A good trick for making sure you’ve addressed most of the comments is to look at the pull request for a bunch of “username commented on an outdated diff”
messages. these appear when changes are made to lines that a reviewer commented on

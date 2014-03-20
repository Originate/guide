# The Originate Guide to Git

As an engineer at Originate, you should be familiar with this guide and follow its recommendations to make working with your team flow smoother.
These are not hard rules, rather it is a way to help us be more efficient and move between projects easier.

## Branching

Part of the beauty of git lies in it's ability to branch projects intuitively. On an Originate project, you should expect to see, at the very least,
1 feature branch created per story in Pivotal. You can go further though, and sometimes it is necessary. Any logical grouping of related changes to a
codebase can be turned into a branch, and it becomes especially necessary to break things up when you have a large amount of changes. Determining what
is a "large amount" is mostly project dependent, and if you have trouble with it you should seek advice from your tech lead.

### Naming

In order to homogenize our projects, you should use [spinal case](http://en.wikipedia.org/wiki/Letter_case#Special_case_styles) to name your branches
(this-is-spinal-case). For small projects, with less than 5 people, a simple naming strategy is suggested:

```ruby
my-feature-branch
```

For projects with more than 5 people, it becomes necessary to relay a bit more information in your branch names, and the following is suggested:

```ruby
feature/my-feature-branch-mh # initials at the end
bug/fixes-broken-thing-mh
```

### Breaking Up Large Branches

The easiest place to start is in Pivotal. If your stories are too big, your branches are going to be too big. Request smaller stories from your project manager.

Regardless, you will still find yourself with branches that are too big, and pull requests that are hard to manage, so here are some suggestions to help you break
them up further:

- Try to break it into a smaller feature first—any change that doesn’t depend on something else to function (even if it’s ugly) could be a different
story/chore/bug
- if that didn’t work, create a ‘merge’ branch that your changes will be merged into (i.e., not `develop`/`master`); then, for each piece of your large change,
create a new branch off of your merge branch, and do a PR into the merge branch, following the standard review/merge process.  When all changes are
done, do another review of the merge branch, and merge it into `develop`/`master`.

## Commit Granularity

Your commits should be granular. When it comes time to commit your changes, using ([interactive staging](http://git-scm.com/book/en/Git-Tools-Interactive-Staging))
is often a big help for creating small sensible commits. Using a GUI is also very helpful for this (see below).


## Pull Requests

Pull requests are how we ensure quality and share knowledge. The goal is for everyone to hold one another to a high standard, and for everyone to learn from each
other. The tone should be conducive to learning, and direct.

An important part of making the PR process constructive is to have **everyone review everyone else**, meaning, no one person is above everyone in the context of
PR's. This is important because everyone makes mistakes, nobody's code is ever perfect, and everyone can always become a better developer.

### Descriptions

When creating a pull request, you should tag relevant people in the description with `@username`. On larger projects (more than 5 people), you should
try to only tag 2 relevant people in a PR. Having everyone review everything does not scale well.

On some projects, you will be required to reference the Pivotal story that this PR is based on. This will help reviewers and project managers keep track of features
and ensure that the project's progress has visibility from a high level.

### WIP

When you have a branch that needs a second set of eyes, but it is not done yet, you should clearly mark in the description that it is a WIP (work in progress).
This should ensure that nobody accidentally merges your unfinished work.

## Who Merges

The creator of the pull request is responsible for merging. This is because people need to be accountable for their own work. Merges should occur after at least 1 person
has signed off on the PR (some projects will require more than 1). For big pull requests, you should aim to have 2 people sign off before merging. After you merge a branch,
you should click **delete branch** in Github, so that old branches do not pile up needlessly.

## Tracking Branches

need to write this

## Rebasing Rules

need to write this

## Tools

### Suggested Git GUI’s

- SourceTree
- gitx
- tower
- gitk
- tig

### Conflict Resolution

- vi
- Araxis Merge
- vimdiff
- FileMerge
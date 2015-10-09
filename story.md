# Storywriting Best Practices

At Originate, we strive to be enable engineers and solutions through our product management, especially including our Storywriting practices.

**It is a Product Manager’s job to determine what to build, it’s an engineer’s job to determine how to build it.**

-----

### PM Toolkit - Epics and Stories

**Product Management is often less about feature design and more about ensuring the whole is greater than the sum of it’s parts.**

**Epics contextualize and group requests:**
* PMs are problem-solvers of Epics, developers are problem-solvers of stories
* 80% of prioritization should be done at the Epic level
* More than just a collection of stories, Epics should holistically solve a problem YOU identify

**Storywriting is your best friend:**
* Forces you to think through and document every detail of every feature as the story matures
* Uncover edge cases not immediately obvious
* Developers should only bother you if they have questions or are confused
* AC can be negotiable

**Stories are a developer’s best friend, too!**

-----

### What is a user story?

**Definition:  An empirical unit of development work that delivers tangible value to the end user or consuming system.**

The “user” in user story:  Refers specifically to the user or system CONSUMING the functionality being built

Recommended size: *Smallest amount that delivers value (but use your judgement)*

-----

### PM Toolkit - Story tracking system (JIRA, Pivotal, etc.)

**Reasons for Story tracking system:**
* JIRA/Pivotal stories > post-it notes
* Easy to maintain, super flexible, accessible from anywhere
* Easily map dependencies, move stories around, add, delete, split up
* Comment history & conversations

-----

### Storywriting Criteria & Best Practices

Stories are made more complete by following these guidelines:
* Epics are clearly defined and represent holistic problems that need solving
* Epics and stories are appropriately sized
* Stories are written in an appropriate format to convey the desired user behavior
  * A consuming user or system is specified
  * An action is specified
  * A motivation is specified
* Acceptance Criteria details a list of expectations and demonstrates thinking through the story
* Stories tracking system (JIRA, Pivotal, etc.) is used effectively by all team members
  * Kept up-to-date
  * Is the source of truth (not whiteboards)
  * Used frequently to discuss the details of stories and acceptance criteria
  * Link-Dependencies and Flag-Blocks are used between stories and teams
* Product Priorities are accurately reflected in Story tracking system (both for Epics and stories)
* Non-developer QA optimally tests the feature against the AC to determine completeness

-----

### Order of PM Events

Product Managers work to follow a flow such as:
1. Identify Epics
2. Estimate Epics
3. Prioritize Epics
4. Pick Epic(s) for Sprint #1
5. UI Design (optional)
6. Write stories
7. Estimate stories
8. Finalize scope of sprint #1 with stories
9. Development begins
10. Pick Epic(s) for Sprint #2*

***Rinse and repeat!***

**Doesn’t mean you can’t plan ahead*

-----

### Story Estimation

*Epic Estimations are rough estimates designed to help PMs prioritize.*

**Epic Estimations:**
* # of weeks: 0.5, 1, 2, 4
* Estimated by Tech Lead/Architect
* Completed before stories are written
* Estimated before each release

*Story Estimations are more correct estimated designed to manage for sprint work.*

**Story Estimations:**
* # of points: 1 - 10 (but stories > 5 are a red flag)
* Estimated by Tech Lead/Architect/QA
* Tech lead is accountable for delivering stories on time
* Estimated before each sprint

-----

### Recommended formats for user story

#### Persona User Story
*Most often used format for describing features.*
Link: [persona user story](http://www.boost.co.nz/blog/2010/09/acceptance-criteria/)

| As a [END USER], | I want to [TAKE AN ACTION], | so that I can [MOTIVATION] |
| ---------------- |:---------------------------:|:--------------------------:|
| role             | What is the “thing” the     | Why does the user want     |
| user             | user wants to do?           | to do this “thing”?        |
| admin            | The function?               | What’s the benefit?        |
| developer        | The feature?                |                            |
| system           |                             |                            |
| etc.             |                             |                            |

**Example:**
*As a Model Researcher, I want to log into the platform, so that I can test the new model(s).*

#### Feature Injection Story
*Good format for describing features especially ones more technical in nature.*
Link: [feature injection syntax](http://lizkeogh.com/2008/09/10/feature-injection-and-handling-technical-stories/)

| In order to [DELIVER BUSINESS BENEFIT/VALUE], | As a [ROLE], | I want [FEATURE]          |
| --------------------------------------------- |:------------:|:-------------------------:|
| Why does the user want                        | user         | What is the “thing” the   |
| to do this “thing”?                           | admin        | user wants to do?         |
| What’s the benefit?                           | developer    | The function?             |
| What's the business value?                    | system       |                           |
|                                               | etc.         |                           |

**Example:**
*In order to test the new model(s), as a Model Researcher, I want to log into the platform.*

-----

### Acceptance Criteria / Conditions

A detailed list of expectations this feature requires to be considered “complete” for demo or during assessment; product acceptance testing.

This list can (and should) evolve! It’s never set in stone.

Acceptance Criteria (AC):
* Display form fields for: username, password
* Display a “log in” button underneath the form fields
* On click of the “log in” button, user authentication is attempted
* If success, direct user to Home Page
* If failure, display error message “please try again”
* Validate form fields such that only alphanumeric characters are accepted
* If form does not validate, highlight red the field in violation
* “password” form field should display only **** characters

-----

### QA Review

Every story needs to be fully tested. This is generally done by a dedicated QA team member, and in the absence of that, the Product Manager.

QA may review and then signal to Product Manager to review and close.

* Ensure process is defined and followed through workflows
* Test that all acceptance criteria is true
* Test that the feature is what the Product Manager intended
* Accept/reject stories regularly and often
* Review feature tests created/updated to support automated testing
* Augment feature tests created/updated to support further automated testing

-----

### Recommendations

* **It all starts with the Epic.** Epics are full-stack “problem themes” that teams should work 
together to solve, and move on once it’s complete.

* **Focus on the benefits of storywriting and AC**, why it’s important to follow and the results it produces. 
Team can both understand the format and follow through on the development/testing methodologies that 
support the format.

* **Storywriting and Acceptance Criteria should be a core piece of a Product Manager’s job.** 
It’s his/her responsibility to make sure they are accurate, complete, and move the product forward.

* **Story tracking system (JIRA, Pivotal, etc.) must be accepted and used as the source of truth 
organization-wide.** You cannot be an effectively operating (and distributed) team without tracking stories 
and conversations.

* **All stories should be reviewed and accepted by a Product Manager (or equivalent)** alongside
support of QA review.
This has the additional effect of forcing the team to rely on Acceptance Criteria to accept/reject stories.

# Originate Guides - Storywriting Best Practices

Good user stories create efficient development processes.

At Originate, we strive to be enable engineers and solutions through our product management, especially including our Storywriting practices.

-----

**Storywriting is your best friend:**
* Storywriting fleshes out the details as the story matures
* Uncover edge cases not immediately obvious
* Developers should only bother you if they have questions or are confused
* AC can be negotiable

**Stories are a developer’s best friend, too!**

-----

### What is a user story?

*Definition:  An empirical unit of development work that delivers tangible value to the end user or consuming system.*

The “user” in user story refers specifically to the user or system CONSUMING the functionality in the feature being built.

Recommended size: *Smallest amount that delivers value*

There should be some room for PMs to "use their judgement" in terms of sizing a story properly. Sometimes its easier for all parties just to lump a couple of really really small things into one story, or break out a big story into two even if each one independently doesn't really deliver value. It should be the exception, not the rule though.

-----

### Storywriting Criteria & Best Practices

Stories are made more complete by following these guidelines:
* Epics are clearly defined and represent a complete problem that need solving
* *Twitter example: "Logged Out User Experience" is a better Epic than "Redesign Homepage". The latter might be the solution for the former problem, but keeping it broader/holistic allows the team to come up with different solutions that might not include a redesigned home page.*
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
*Good format for describing features especially requests that are more technical in nature.*
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

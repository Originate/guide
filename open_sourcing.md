# Open-sourcing code from projects

While Originate excels at building high-quality intellectual property for our partners,
we also have very generous policies that allow and encourage open-sourcing code,
including parts of internal and commercial projects.

If all involved parties agree to it,
then generally useful and non business-critical proprietary work
can be extracted from an existing project and open-sourced.
If the release happens under the Originate brand,
the respective work is not billed by Originate.
Good candidates for open sourcing are excellent
and non-proprietary (peripheral) infrastructure and tools.


## Benefits

> If you have an apple and I have an apple
> and we exchange apples
> then you and I will still each have one apple.
> But if you have an idea and I have an idea
> and we exchange these ideas,
> then each of us will have two ideas.
>
> -- George Bernard Shaw

Unlike physical goods, which once given away cannot be used by the donor anymore,
software can be given away and still continue to be used,
because it can be copied.
These specific economics of software favor open-sourcing code
over keeping it proprietary in many situations.
Depending on the particular situation,
an open-source release can achieve the following business benefits for our partners:
* __cost savings__: All work that is open-sourced under
  the Originate brand is not billed by Originate, but still available to partners.
  It is also maintained by Originate for free well beyond the typical engagement
  duration with Originate.
* __free contributions__: in the form of bug fixes and enhancements
  from third parties in the community.
  Besides cost and time savings, this often leads to more functional, secure,
  and better performing products.
* __free publicity:__
  The reputation of the partner, Originate, the product,
  everybody's technical abilities, thought leadership,
  and insight into modern software business
  increases through association with high-quality open-source releases.
* __better recruiting:__ Many talented developers enjoy working on open-source code
  and products built using open-source code.
* __ecosystem building__: It is much easier for third parties to invest into the
  platform of the partner if it, or parts of it, are available as open-source.
* __security__: The fastest way to achieve truly secure systems is
  to have lots of people review an implementation,
  and keep only the access keys secret.


## Process

* Create a release proposal including:
  * what is and what isn't open-sourced
  * the license
  * the associated impacts, benefits, and risks for the project, the partner,
    and Originate.
* Work with your supervisor to get approval from
  Originate management for the release,
  as well as a rough estimate of the cost savings for the partner.
* Work with your product manager to achieve an agreement with the partner about
  what exactly is open sourced, how it is open sourced,
  and excluding the work from the contractually agreed upon deliverable.
* Work with your supervisor to make sure the release
  satisfies our quality criteria for open-source releases
  * high code quality that is representative of Originate's code standards
  * full integration and unit test coverage
  * full adherence to code style guidelines and quality metrics,
    enforced by linters
  * CI setup
  * sufficient documentation, both within the code base as well as in readme files
  * double-check that no proprietary information is leaked through the release
  * an appropriate release model, permissive license,
    and government structure for the open-source project
* Announce the open-source project through a blog post on Originate's
  [developer blog](http://blog.originate.com).
* You must be willing to be the maintainer for this project in the long term.
  We don't want abandoned projects under our name.
  If there is no maintainer who is willing to drive the project forward
  involving his/her own time,
  it is better to not release software at all.

As always, use your intelligence and common sense to make sure
everything makes sense in your particular situation.


## Maintaining open-source

* Try to reach a stable API (version 1.0) quickly,
  especially if projects use your code.
  Nobody wants to be dependent on a library whose author cannot commit to
  stability of their API and proper semantic versioning.
* You are responsible for addressing all issues and
  growing the community around the project.
  You can use your 20% time for this.
* You are encouraged to use GitHub's issue tracker to maintain a list of
  bugs and upcoming features.
  All tickets should be addressed within normal timeframes, in a friendly and
  inviting tone.
* Encourage other projects to use your code,
  and be the point of contact for questions.

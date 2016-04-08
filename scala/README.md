Originate's Scala Style Guide
=============================

Introduction
------------

Welcome to Originate's Scala Style Guide.
This guide contains recommendations for formatting conventions, coding style,
and best practices based on person-decades of experience gathered across
innumerous Scala projects.

### Organization

The guide is organized as follows:

0. The first section, "[Code Formatting](CodeFormatting.md)", covers code layout
conventions, i.e., guidelines that do not alter the meaning of a program:
    1. The section itself highlights the main points of the official
    [Scala Style Guide].
    Reading the official guide completely is required.
    1. The subsection
    "[Additions and Deviations](CodeFormatting.md#additions-and-deviations)"
    contains the points where we differ from the official guide, plus some
    topics that are not covered by it.
    To ease on-boarding and favor consistency, we try to deviate as little as
    possible from the official guide.
0. The second section, "[Best Practices](BestPractices.md)" covers rules that
may change the meaning of your code:
    1. "[Additional recommendations](BestPractices.md#additional-recommendations)",
    for the most part, are required rules that must be followed unless there is
    a very good reason not to.
    Failure to fully obey these conventions may **introduce errors**, degrade
    performance, or create maintenance headaches.
    1. "[Tips & Tricks](TipsTricks.md)" are mostly friendly reminders that may
    not apply in all situations.
    Always keep them in mind and use your best judgement.
    1. "[Additional Remarks](AdditionalRemarks.md)" are general hints that are
    always helpful to remember.
0. Finally, the "[Reference](Reference.md)" contains recommended further reading.

### Static Analysis Tools & Configuration

A [skeleton](skeleton) project accompanies the guide.
It encodes and enforces as many best practices as currently available tools
allow us.
Try to use as much of its default configuration as you can on your Scala projects.

[Scala Style Guide]: http://docs.scala-lang.org/style/

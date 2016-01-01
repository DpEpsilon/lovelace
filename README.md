# Lovelace

Lovelace is a training website for the Australian Informatics Olympiad
programme, backwards-compatible with `judge` and the old database layer.

## Running locally

You will need:

- Git (tutorials: [1](https://git-scm.com/book/en/v2), [2](https://try.github.io/levels/1/challenges/1))
- The [Scala build
  tool](http://www.scala-sbt.org/0.13/tutorial/Installing-sbt-on-Linux.html)
- Java (in theory, either [Oracle
  Java](http://www.java.com/en/download/manual.jsp) or
  [OpenJDK](http://openjdk.java.net/) will work).

To compile, from the root of your project, type:

    sbt compile

You may see messages like this the first time you compile:

    Getting org.scala-sbt sbt 0.13.9 ...
    [info] Resolving org.scala-lang#scala-compiler;2.11.7 ...

This is `sbt` fetching a specific version of itself and the Scala compiler
(read: reproducible builds). It may look like it's hanging, but actually be
downloading at the impressive bandwidth of 3Kb/s. This should only need to
happen once. Grab a coffee; make a Java pun.

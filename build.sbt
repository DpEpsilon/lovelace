lazy val root = (project in file("."))
  .settings(
    name := "lovelace",
    scalaVersion := "2.11.7",
    version := "0.0",
    scalacOptions ++= Seq("-unchecked", "-feature", "-deprecation", "-Xlint", "-Ywarn-adapted-args"),
    resolvers += DefaultMavenRepository,
    libraryDependencies ++= Seq(
      "org.http4s" %% "http4s-dsl"           % "0.11.2",
      "org.http4s" %% "http4s-blaze-server"  % "0.11.2", 
      "org.scalaz" %% "scalaz-core"          % "7.1.2",
      "org.scalaz" %% "scalaz-concurrent"    % "7.1.2"
    )
  )

lazy val gen = (project in file("doobie-codegen"))
  .settings(
    scalaVersion := "2.11.7",
    resolvers += "Jitpack" at "https://jitpack.io",
    libraryDependencies += "com.github.mdmoss" %% "doobie-codegen" % "v0.1.5"
  )

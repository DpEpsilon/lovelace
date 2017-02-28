val commonSettings = Seq(
  scalaVersion := "2.11.7",
  version := "0.0",
  scalacOptions ++= Seq("-unchecked", "-feature", "-deprecation", "-Xlint", "-Ywarn-adapted-args"),
  resolvers += DefaultMavenRepository,
  libraryDependencies ++= Seq(
    "org.http4s"   %% "http4s-dsl"                 % "0.11.2",
    "org.http4s"   %% "http4s-blaze-server"        % "0.11.2",
    "org.scalaz"   %% "scalaz-core"                % "7.1.2",
    "org.scalaz"   %% "scalaz-concurrent"          % "7.1.2",
    "org.tpolecat" %% "doobie-core"                % "0.2.3",
    "org.tpolecat" %% "doobie-contrib-postgresql"  % "0.2.3",
    "org.tpolecat" %% "doobie-contrib-specs2"      % "0.2.3",
    "org.tpolecat" %% "doobie-contrib-hikari"      % "0.2.3"
  )
)

lazy val root = (project in file(""))
  .settings(commonSettings:_*)
  .dependsOn(db)

lazy val gen = (project in file("doobie-codegen"))
  .settings(
    scalaVersion := "2.11.7",
    resolvers += "Jitpack" at "https://jitpack.io",
    libraryDependencies += "com.github.mdmoss" %% "doobie-codegen" % "v0.1.5"
  )

lazy val db = (project in file("db"))
  .settings(commonSettings:_*)

lazy val root = (project in file("."))
  .settings(
    name := "lovelace",
    version := "0.0",
    resolvers += DefaultMavenRepository,
    libraryDependencies ++= Seq(
      "org.http4s" %% "http4s-dsl"           % "0.11.2",
      "org.http4s" %% "http4s-blaze-server"  % "0.11.2" 
    )
  )

ThisBuild / scalaVersion := "3.5.2"
ThisBuild / version := "0.1.0-SNAPSHOT"
ThisBuild / organization := "com.test"
ThisBuild / organizationName := "test"

lazy val root = (project in file("."))
  .settings(
    name := "scala-sbt-lock",
    libraryDependencies ++= Seq(
      "com.typesafe.akka" %% "akka-actor-typed" % "2.9.3",
      "io.circe" %% "circe-core" % "0.14.10",
      "io.circe" %% "circe-generic" % "0.14.10",
      "org.tpolecat" %% "doobie-core" % "1.0.0-RC5",
      "org.http4s" %% "http4s-dsl" % "1.0.0-M41",
      "ch.qos.logback" % "logback-classic" % "1.5.8"
    )
  )

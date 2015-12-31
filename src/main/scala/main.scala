import org.http4s.server.blaze.BlazeBuilder
import org.http4s.server.HttpService
import org.http4s.dsl._
import org.slf4j.{Logger,LoggerFactory}

import scalaz.concurrent.Task

import train.data._
import train.db.DatabaseInterface
import train.db.MockDatabase

object LovelaceTrainingSite extends App {
  implicit val db: DatabaseInterface = MockDatabase
  import db._

  val service = HttpService {
    case req @ GET -> Root / "hub" => for {
      currentStudent <- verifyStudent(StudentID(3), "foo")
      result <- currentStudent match {
        case Some(_: LoggedInStudent) => Ok("Hi!")
        case None => Ok("Not logged in!")
      }
    } yield result
    case req => Ok("Hello world.")
  }
  BlazeBuilder.bindHttp(8080)
    .mountService(service, "/")
    .run
    .awaitShutdown()
}

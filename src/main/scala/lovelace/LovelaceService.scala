package lovelace

import org.http4s.server.HttpService
import org.http4s.dsl._

import train.data._
import train.db.DatabaseInterface
import train.db.MockDatabase

object LovelaceService {
  def apply(db: DatabaseInterface): HttpService = {
    import db._

    HttpService {
      case req @ GET -> Root / "hub" => for {
        currentStudent <- verifyStudent(StudentID(3), "foo")
        result <- currentStudent match {
          case true => Ok("Hi!")
          case false => Ok("Not logged in!")
        }
      } yield result
          case req => Ok("Hello world.")
    }
  }
}

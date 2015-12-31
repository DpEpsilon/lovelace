package lovelace

import org.http4s.server.HttpService
import org.http4s.dsl._
import org.http4s.Request

import scalaz.concurrent.Task

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

  def getLoggedInState(req: Request): Task[LoginState] = ??? // TODO: grab the session cookie here

  def withLoggedInUser[X](req: Request, onSuccess: LoggedInStudent => Task[X]) = for {
    loginState <- getLoggedInState(req)
    result <- loginState match {
      case s : LoggedInStudent => onSuccess(s)
      case NotLoggedIn => Forbidden("Not logged in!")
    }
  } yield result
}

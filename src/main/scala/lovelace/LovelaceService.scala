package lovelace

import org.http4s.server.HttpService
import org.http4s.dsl._
import org.http4s.Request

import scalaz.concurrent.Task

import train.data._
import train.db.DatabaseInterface
import train.db.MockDatabase

class LovelaceService(db: DatabaseInterface) {
  import db._

  def asHttpService: HttpService = {
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

  def getLoggedInState(req: Request): Task[LoginState] = for {
    // TODO: grab the session cookie here
    studentId <- Task.delay(StudentID(3))
    isVerified <- verifyStudent(studentId, "foo")
  } yield isVerified match {
    case true => LoggedInStudent(studentId)
    case false => NotLoggedIn
  }

  def withLoggedInUser[X](req: Request, onSuccess: LoggedInStudent => Task[X]) = for {
    loginState <- getLoggedInState(req)
    result <- loginState match {
      case s : LoggedInStudent => onSuccess(s)
      case NotLoggedIn => Forbidden("Not logged in!")
    }
  } yield result
}

object LovelaceService {
  def apply(db: DatabaseInterface): HttpService = new LovelaceService(db).asHttpService
}

package lovelace

import org.http4s.server.HttpService
import org.http4s.dsl._
import org.http4s.Request
import org.http4s.Response

import scalaz.concurrent.Task

import train.data._
import train.db.DatabaseInterface
import train.db.MockDatabase

class LovelaceService(db: DatabaseInterface) {
  import db._

  def asHttpService: HttpService = HttpService {
    case req @ GET -> Root / "hub" => withLoggedInUser(req, _ => Ok("Hi!"))
    case req => Ok("Hello world.")
  }

  def getLoggedInState(req: Request): Task[LoginState] = for {
    // TODO: grab the session cookie here, if it exists
    // Save the verifyStudent call for the login POST method
    studentId <- Task.delay(StudentID(3))
    password <- Task.delay("foo")
    isVerified <- verifyStudent(studentId, password)
  } yield isVerified match {
    case true => LoggedInStudent(studentId)
    case false => NotLoggedIn
  }

  def withLoggedInUser(req: Request, onSuccess: LoggedInStudent => Task[Response]): Task[Response] = for {
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

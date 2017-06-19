package train.http.student

import doobie.imports._
import org.http4s._
import org.http4s.dsl._

import scalaz.concurrent.Task

class Auth(req: Request) {
  def login: Task[Response] = {
    Ok("")
  }
}

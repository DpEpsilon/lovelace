package train.http

import org.http4s.dsl._
import org.http4s.server.HttpService

object Routes {
  def apply(): HttpService = HttpService.lift{
    case GET -> Root => Ok("Hello World!")
    case _ => NotFound()
  }
}

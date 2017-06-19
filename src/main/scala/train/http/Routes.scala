package train.http

import org.http4s.dsl._
import org.http4s.server.HttpService
import train.ServerEnv

object Routes {
  def apply(env: ServerEnv): HttpService = HttpService.lift{
    case GET -> Root => Ok("Hello World!")
    case _ => NotFound()
  }
}

package train

import org.http4s.dsl._
import org.http4s.server.HttpService
import org.http4s.server.blaze.BlazeBuilder

object Server extends App {
  val service = HttpService {
    case r @ POST -> Root / "auth" / "login" => ???
    case r @ POST -> Root / "auth" / "register" => ???
    case r @ POST -> Root / "auth" / "resetPassword" => ???
    case r @ PATCH -> Root / "auth" / "update" => ???

    case r @ GET -> Root / "problems" => ???
    case r @ GET -> Root / "problems" / "set" / LongVar(id) => ???
    case r @ GET -> Root / "problems" / LongVar(id) => ???
    case r @ GET -> Root / "problems" / LongVar(id) / "hallOfFame" => ???
    case r @ GET -> Root / "problems" / LongVar(id) / "hallOfFame" / username => ???
    case r @ POST -> Root / "problems" / LongVar(id) / "judge" => ???
    case r @ GET -> Root / "problems" / LongVar(id) / "submissions" => ???
    case r @ GET -> Root / "problems" / LongVar(id) / "submissions" / LongVar(submissionId) => ???
    case r @ PUT -> Root / "problems" => ???

    case r @ GET -> Root / "progression" => ???

    case r @ GET -> Root / "hallOfFame" => ???

    case req @ GET -> Root => Ok("AIOC Train API (Lovelace)")
    case req => NotFound()
  }
  BlazeBuilder.bindHttp(8080)
    .mountService(service, "/")
    .run
    .awaitShutdown()
}

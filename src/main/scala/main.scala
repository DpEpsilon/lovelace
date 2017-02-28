import org.http4s.server.blaze.BlazeBuilder
import org.http4s.server.HttpService
import org.http4s.dsl._
import org.slf4j.{Logger,LoggerFactory}

import scalaz.concurrent.Task

object LovelaceTrainingSite extends App {
  val service = HttpService {
    case req @ GET -> Root / "hub" => for {
      result <- true match {
        case true => Ok("Hi!")
        case false => Ok("Not logged in!")
      }
    } yield result
    case req => Ok("Hello world.")
  }
  BlazeBuilder.bindHttp(8080)
    .mountService(service, "/")
    .run
    .awaitShutdown()
}

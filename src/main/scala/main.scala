import org.http4s.server.blaze.BlazeBuilder
import org.http4s.server.HttpService
import org.http4s.dsl._
import org.slf4j.{Logger,LoggerFactory}

object BlazeExample extends App {
  val service = HttpService {
    case req @ GET -> Root / "hello" => Ok("Hi!")
    case req => Ok("Hello world.")
  }
  BlazeBuilder.bindHttp(8080)
    .mountService(service, "/http4s")
    .run
    .awaitShutdown()
}

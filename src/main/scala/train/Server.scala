package train

import org.http4s.server.HttpService
import org.http4s.server.blaze.BlazeBuilder
import org.http4s.dsl._

import scalaz.concurrent.Task

object Server {
  def main(args: Array[String]) {
    run(args).run
  }

  def run(args: Array[String]): Task[Unit] = for {
    server <- BlazeBuilder
      .bindHttp(8080, "0.0.0.0")
      .mountService(HttpService.lift(_ => Ok("Hello World!")), "/")
      .start

    _ <- Task.delay { server.awaitShutdown() }
  } yield ()
}

package train

import org.log4s.getLogger
import util.CommandLineInteraction.waitForInput

import scalaz.concurrent.Task

object Server {
  private[this] val log = getLogger

  def main(args: Array[String]) {
    run(args).run
  }

  def run(args: Array[String]): Task[Unit] = for {
    _ <- Task.delay { log.info("lovelace server starting")}

    server <- http.Server.apply()

    input <- waitForInput
    _     <- input match {
      case Some(_) => server.shutdown
      case None    => Task.delay { server.awaitShutdown() }
    }

    _ <- Task.delay { log.info("lovelace server stopped")}

  } yield ()
}

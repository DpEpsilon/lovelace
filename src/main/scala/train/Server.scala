package train

import java.io.File

import com.typesafe.config._
import org.log4s.getLogger
import util.CommandLineInteraction.waitForInput

import scalaz.concurrent.Task

object Server {
  private[this] val log = getLogger

  def main(args: Array[String]) {
    run(args).run
  }

  def run(args: Array[String]): Task[Unit] = for {
    config <- loadConfig(args(0))
    env    <- ServerEnv.load(config)

    _ <- Task.delay { log.info("lovelace server starting")}

    server <- http.Server(env)

    input <- waitForInput
    _     <- input match {
      case Some(_) => server.shutdown
      case None    => Task.delay { server.awaitShutdown() }
    }

    _ <- Task.delay { log.info("lovelace server stopped")}

  } yield ()

  def loadConfig(fileName: String): Task[Config] = Task.delay {
    ConfigFactory.load(ConfigFactory.parseFile(new File(fileName)))
  }
}

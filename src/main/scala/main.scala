import org.http4s.server.blaze.BlazeBuilder
import org.http4s.server.HttpService
import org.http4s.dsl._
import org.slf4j.{Logger,LoggerFactory}

import scalaz.concurrent.Task

import lovelace.LovelaceService
import train.data._
import train.db.DatabaseInterface
import train.db.MockDatabase

object LovelaceTrainingSite extends App {
  implicit val db: DatabaseInterface = MockDatabase

  val service = LovelaceService(db)
  BlazeBuilder.bindHttp(8080)
    .mountService(service, "/")
    .run
    .awaitShutdown()
}

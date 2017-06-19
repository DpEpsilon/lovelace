package train

import com.typesafe.config.Config
import doobie.contrib.hikari.hikaritransactor.HikariTransactor
import doobie.imports._

import scalaz.concurrent.Task

case class ServerEnv(
  port: Int,
  db: Transactor[Task],
  shutdown: Task[Unit]
)

object ServerEnv {
  def load(config: Config): Task[ServerEnv] = for {

    dbConnectionPool <- {
      val driver = config.getString("internal-db.driver")
      val url = config.getString("internal-db.url")
      val user = config.getString("internal-db.user")
      val pass = config.getString("internal-db.pass")

      HikariTransactor[Task](driver, url, user, pass)
    }
  } yield ServerEnv(
    config.getInt("port"),
    db = dbConnectionPool,
    shutdown = for {
      _ <- dbConnectionPool.shutdown
    } yield ()
  )
}

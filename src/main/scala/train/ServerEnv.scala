package train

import doobie.imports._
import scalaz.concurrent.Task

case class ServerEnv(
  port: Int,
  studentJwtSecret: String,
  studentJwtAud: String,
  studentJwtIss: String,
  db: Transactor[Task]
)

object ServerEnv {
  def loadEnv(filename: String): Task[ServerEnv] = {
    ServerEnv(

    )
  }
}
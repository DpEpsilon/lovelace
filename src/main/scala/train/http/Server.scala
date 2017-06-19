package train.http

import org.http4s.server.blaze.BlazeBuilder
import org.http4s.server.middleware.{CORS, CORSConfig}
import train.ServerEnv

import scalaz.concurrent.Task

object Server {

  def corsConfig = CORSConfig(
    anyOrigin = true,
    allowCredentials = true,
    10000,
    anyMethod = true,
    None,
    Some(Set("DELETE", "HEAD", "GET", "OPTIONS", "POST", "PUT", "PATCH")),
    Some(Set("Authorization", "Content-Type", "Accept", "Cache-Control", "X-Requested-With"))
  )

  def apply(env: ServerEnv): Task[org.http4s.server.Server] =
    BlazeBuilder.bindHttp(env.port, "0.0.0.0")
      .mountService(CORS(Routes(env), corsConfig))
      .start
}

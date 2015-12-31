package lovelace

import scalaz.concurrent.Task

trait SessionManager {
  final type SessionId = String

  def decodeSessionId(id: SessionId): Task[Option[LoggedInStudent]]
  def registerSession(student: LoggedInStudent): Task[SessionId]
}

// Stores a map of sessions in RAM.
class MemorySessionManager extends SessionManager {
  var sessions: Map[SessionId, LoggedInStudent] = Map.empty

  def decodeSessionId(id: SessionId) = Task.delay(sessions.get(id))
  def registerSession(student: LoggedInStudent) = Task.delay({
    val newId = java.util.UUID.randomUUID.toString()
    sessions = sessions + (newId -> student)
    newId
  })
}

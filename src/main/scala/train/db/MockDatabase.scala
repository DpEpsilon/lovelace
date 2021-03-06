package train.db

import scala.language.higherKinds
import scalaz.concurrent.Task

import train.data._

/**
 * A trivial read-only database containing no data and failing all operations.
 * Intended for smoke tests on the server.
 */
object MockDatabase extends DatabaseInterface {
  def verifyStudent = (id: StudentID, password: String) => Task.delay(false)
  def getProblemsForStudent = (id: StudentID) => Task.delay(Seq.empty)
  def getProblemSetsForStudent = (id: StudentID) => Task.delay(Seq.empty)
  def getSubmissionCode = (id: StudentID, problemId: ProblemID, n: Int) => Task.delay(None)
  def getSubmissionResult = (id: StudentID, problemId: ProblemID, n: Int) => Task.delay(None)
  def addSubmission = (id: StudentID, problemId: ProblemID, code: Code) => Task.fail(new RuntimeException("Could not access database"))
}

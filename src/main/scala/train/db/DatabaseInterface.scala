package train.db

import scala.language.higherKinds
import scalaz.concurrent.Task

import train.data._

trait DatabaseInterface {
  // verifyStudent(id, password) returns true iff the username/password pair is valid
  def verifyStudent : (StudentID, String) => Task[Boolean]

  def getProblemsForStudent : StudentID => Task[Seq[Problem]]
  def getProblemSetsForStudent : StudentID => Task[Seq[ProblemSet]]
  def getSubmissionCode : (StudentID, ProblemID, Int) => Task[Option[Code]]
  def getSubmissionResult : (StudentID, ProblemID, Int) => Task[Option[SubmissionResult]]

  // returns submission id
  def addSubmission: (StudentID, ProblemID, Code) => Task[Int]
}

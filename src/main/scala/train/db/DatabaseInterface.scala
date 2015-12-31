package train.db

import scala.language.higherKinds
import scalaz.concurrent.Task

import train.data._

trait DatabaseInterface[DB[_]] {
  type DBQuery[A] <: DB[A]
  type DBWrite[A] <: DB[A]

  implicit def asTask[A]: DB[A] => Task[A]

  def verifyStudent : StudentID => String => DBQuery[Option[LoggedInStudent]]
  def getProblemsForStudent : StudentID => DBQuery[Seq[Problem]]
  def getProblemSetsForStudent : StudentID => DBQuery[Seq[ProblemSet]]
  def getSubmissionCode : StudentID => ProblemID => Int => DBQuery[Code]
  def getSubmissionResult : StudentID => ProblemID => Int => DBQuery[SubmissionResult]

  // returns submission id
  def addSubmission: StudentID => ProblemID => Code => DBWrite[Int]
}

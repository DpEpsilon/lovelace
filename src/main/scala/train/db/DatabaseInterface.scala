package train.db
import train.data._

trait DatabaseInterface {
  type DB[A]
  type DBQuery[A] <: DB[A]
  type DBWrite[A] <: DB[A]


  def verifyStudent : StudentID => DBQuery[LoggedInStudent]
  def getProblemsForStudent : StudentID => DBQuery[Seq[Problem]]
  def getProblemSetsForStudent : StudentID => DBQuery[Seq[ProblemSet]]
  def getSubmissionCode : StudentID => ProblemID => Int => DBQuery[Code]
  def getSubmissionResult : StudentID => ProblemID => Int => DBQuery[SubmissionResult]

  // returns submission id
  def addSubmission: StudentID => ProblemID => Code => DBWrite[Int]
}


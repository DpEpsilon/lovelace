package train.db
import train.data._

trait DatabaseInterface {
  type DB[A]
  type DBQuery[A] <: DB[A]
  type DBWrite[A] <: DB[A]


  def verifyStudent : Int => DBQuery[LoggedInStudent]
  def getProblemsForStudent : Student => DBQuery[Seq[Problem]]
  def getProblemSetsForStudent : Student => DBQuery[Seq[ProblemSet]]

  // returns submission id
  def addSubmission: Student => Problem => Code => DBWrite[Int]

}


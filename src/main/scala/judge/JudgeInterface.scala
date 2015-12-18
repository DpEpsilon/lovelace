import scalaz.concurrent.Task
import train.data.SubmissionResult
import train.data.Code

trait JudgeInterface {
	type SpecFile
	def judge : Code => SpecFile => Task[SubmissionResult]


//  def verifyStudent : Int => DBQuery[LoggedInStudent]
}
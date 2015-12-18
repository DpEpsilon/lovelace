package train


object data {
  case class StudentID()
  case class Problem(val id: Int)
  case class LoggedInStudent(val id: StudentID)
  case class Submission(val code: Code, val result: SubmissionResult)
  case class ProblemSet()
  case class Code()
  case class SubmissionResult()
}

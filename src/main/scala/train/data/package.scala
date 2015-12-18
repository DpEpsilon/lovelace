package train


object data {
  case class StudentID(val id: Int)
  case class ProblemID(val id: Int)
  case class Problem(val id: ProblemID)
  case class LoggedInStudent(val id: StudentID)
  case class Submission(val code: Code, val result: SubmissionResult)
  case class ProblemSet()
  case class Code()
  case class SubmissionResult()
}

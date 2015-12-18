package train


object data {
  trait Student {
    val id: Int
  }

  case class Problem(val id: Int)
  case class LoggedInStudent(val id: Int) extends Student
  case class Submission()
  case class ProblemSet()
}

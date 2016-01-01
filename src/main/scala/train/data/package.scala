package train

/**
 * Data types for training site "business logic".
 *
 * Does *not* include: data types specific to a web frontend / JSON API / etc.
 */
object data {
  // IDs and unique identifiers
  case class StudentID(val id: Int)
  case class ProblemID(val id: Int)
  case class Problem(val id: ProblemID)
  case class ProblemSet()

  case class Submission(val code: Code, val result: SubmissionResult)
  case class Code()
  case class SubmissionResult()
}

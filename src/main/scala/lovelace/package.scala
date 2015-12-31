import train.data._

package object lovelace {
  sealed trait LoginState
  case class LoggedInStudent(val asStudent: StudentID) extends LoginState
  case object NotLoggedIn extends LoginState
}

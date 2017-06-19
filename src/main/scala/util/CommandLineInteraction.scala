package util

import scalaz.concurrent.Task

object CommandLineInteraction {
  def waitForInput: Task[Option[Int]] = Task.delay {
    System.in.read() match {
      case -1 => None
      case x => Some(x)
    }
  }
}

package gen

import mdmoss.doobiegen.Runner.{Target, TestDatabase}
import mdmoss.doobiegen.StatementTypes._

object Generator {
  def main(args: Array[String]) {

    val target = Target(
      "schema/",
      TestDatabase(
        "org.postgresql.Driver",
        "jdbc:postgresql:train",
        "train",
        "train"
      ),
      "db/src",
      "train.db",
      None,
      Map()
    )

    mdmoss.doobiegen.Runner.run(target)
  }
}

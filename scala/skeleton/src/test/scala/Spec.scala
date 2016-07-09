package test

import org.scalatest.{DiagrammedAssertions, FreeSpec}
import org.scalatest.mock.MockitoSugar

abstract class Spec extends FreeSpec with DiagrammedAssertions with MockitoSugar

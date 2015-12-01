package test

import org.mockito.Mockito.when

class Test extends Spec {
  "Test:" - {
    "Simple test" in {
      val obj = mock[AnyRef]
      val expected = "obj"

      when(obj.toString) thenReturn expected

      assert(obj.toString === expected)
    }
  }
}

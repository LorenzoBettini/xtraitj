package xtraitj.tests.utils

import static extension org.junit.Assert.assertEquals

class XtraitjTestsUtils {
	
	protected new() {
		
	}

	def static assertEqualsStrings(CharSequence expected, CharSequence actual) {
		assertEquals(expected.toString().replaceAll("\r", ""), actual.toString());
	}
}
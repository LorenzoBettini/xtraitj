package xtraitj.tests.utils

import static extension org.junit.Assert.assertEquals

class XtraitjTestsUtils {
	
	protected new() {
		
	}

	def static assertEqualsStrings(CharSequence expected, CharSequence actual) {
		assertEquals(removeCR(expected), actual.toString());
	}
	
	def static removeCR(CharSequence s) {
		s.toString().replaceAll("\r", "")
	}
}
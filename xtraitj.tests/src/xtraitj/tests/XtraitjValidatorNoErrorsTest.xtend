package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjValidatorNoErrorsTest extends XtraitjAbstractTest {

	@Test def void testDuplicateTraitReferenceWithOperationsOK() {
		'''
		trait T {
			String m();
		}
		
		trait T1 uses T, T[rename m to n] {}
		'''.parseAndAssertNoErrors
	}

}

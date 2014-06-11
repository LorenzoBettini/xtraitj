package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.input.tests.MyGenericTestInterface
import xtraitj.jvmmodel.XtraitjJvmModelHelper

import static extension xtraitj.tests.utils.XtraitjTestsUtils.*
import xtraitj.input.tests.MyGenericTestInterfaceWithTwoTypeParameters

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjJvmModelHelperTest extends XtraitjAbstractTest {
	
	@Inject extension XtraitjJvmModelHelper
	
	@Test def void testResolvedOperationsWithoutTypeArgument() {
		MyGenericTestInterface.assertResolvedOperations("m(List<Object>) : int")
	}
	
	@Test def void testResolvedOperationsWithTypeArgument() {
		MyGenericTestInterface.assertResolvedOperations("m(List<String>) : int",
			String
		)
	}

	@Test def void testResolvedOperationsWithTwoTypeArguments() {
		MyGenericTestInterfaceWithTwoTypeParameters.assertResolvedOperations(
			"m1(List<Integer>) : String; m2(List<String>, String) : Integer",
			String, Integer
		)
	}

	def private assertResolvedOperations(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		expected.assertEqualsStrings(clazz.toResourceTypeRef(typeArguments).getOperations.map[
			simpleSignature + " : " + resolvedReturnType
		].join("; "))
	}
}
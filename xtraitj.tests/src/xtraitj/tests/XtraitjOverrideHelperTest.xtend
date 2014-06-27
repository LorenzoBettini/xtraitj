package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.input.tests.^override.MyAnnotatedJavaInterfaceWithDefined
import xtraitj.typesystem.^override.XtraitjOverrideHelper
import xtraitj.typing.XtraitjTypingUtil

import static extension xtraitj.tests.utils.XtraitjTestsUtils.*
import xtraitj.input.tests.^override.MyAnnotatedJavaInterfaceWithRenamed

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjOverrideHelperTest extends XtraitjAbstractTest {
	
	@Inject extension XtraitjOverrideHelper
	@Inject extension XtraitjTypingUtil
	
	@Test def void testResolvedOperationsWithDefinedOverRequired() {
		MyAnnotatedJavaInterfaceWithDefined.assertAllOperations(
'''
getRequired() : String - [XtraitjDefinedMethod]
getDefined() : String - [XtraitjDefinedMethod]
getField() : String - [XtraitjRequiredField]'''
		)
	}

	@Test def void testResolvedOperationsWithRenamed() {
		MyAnnotatedJavaInterfaceWithRenamed.assertAllOperations(
'''
getRequired() : String - [XtraitjDefinedMethod]
getDefined() : String - [XtraitjDefinedMethod]
getField() : String - [XtraitjRequiredField]'''
		)
	}
	
	def private assertAllOperations(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		val typeRef = clazz.toResourceTypeRef(typeArguments)
		val lightweightTypeRef = typeRef.toLightweightTypeReference(typeRef)
		expected.assertEqualsStrings(
			lightweightTypeRef.resolvedOperations.allOperations.filter[
				declaration.declaringType.notJavaLangObject
			].map[
				simpleSignature + " : " + resolvedReturnType + " - " +
				declaration.annotations.map[annotation.simpleName]
			].join("\n"))
	}

}
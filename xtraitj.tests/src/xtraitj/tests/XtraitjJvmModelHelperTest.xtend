package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.input.tests.MyGenericAnnotatedJavaInterface
import xtraitj.input.tests.MyGenericTestInterface
import xtraitj.input.tests.MyGenericTestInterfaceWithTwoTypeParameters
import xtraitj.jvmmodel.XtraitjJvmModelHelper

import static extension xtraitj.tests.utils.XtraitjTestsUtils.*
import xtraitj.input.tests.MyGenericAnnotatedJavaInterfaceDerived

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

	@Test def void testXtraitjResolvedOperations() {
		MyGenericAnnotatedJavaInterface.assertXtraitjResolvedOperations(
'''
requiredFields: getField() : Object
requiredMethods: getRequired(List<Object>) : Object
definedMethods: getDefined(List<Object>) : Object
'''
		)
	}

	@Test def void testXtraitjResolvedOperationsWithTypeArgument() {
		MyGenericAnnotatedJavaInterface.assertXtraitjResolvedOperations(
'''
requiredFields: getField() : String
requiredMethods: getRequired(List<String>) : String
definedMethods: getDefined(List<String>) : String
'''
		,
		String
		)
	}

	@Test def void testXtraitjResolvedOperationsWithTypeArgumentDerived() {
		MyGenericAnnotatedJavaInterfaceDerived.assertXtraitjResolvedOperations(
'''
requiredFields: getField2() : String; getField() : String
requiredMethods: getRequired2(List<String>) : String; getRequired(List<String>) : String
definedMethods: getDefined2(List<String>) : String; getDefined(List<String>) : String
'''
		,
		String
		)
	}

	@Test def void testDeclaredMethods() {
		// included both required and defined methods
		MyGenericAnnotatedJavaInterfaceDerived.assertDeclaredMethods(
'''
getRequired2(List<String>) : String
getRequired(List<String>) : String
getDefined2(List<String>) : String
getDefined(List<String>) : String'''
		,
		String
		)
	}

	@Test def void testAllDeclarations() {
		// included both required and defined methods
		MyGenericAnnotatedJavaInterfaceDerived.assertAllDeclarations(
'''
getField2() : String
getField() : String
getRequired2(List<String>) : String
getRequired(List<String>) : String
getDefined2(List<String>) : String
getDefined(List<String>) : String'''
		,
		String
		)
	}

	def private assertResolvedOperations(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		expected.assertEqualsStrings(clazz.toResourceTypeRef(typeArguments).getOperations.map[
			simpleSignature + " : " + resolvedReturnType
		].join("; "))
	}

	def private assertXtraitjResolvedOperations(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		var repr = ""
		val resolved = clazz.toResourceTypeRef(typeArguments).xtraitjResolvedOperations
		repr += "requiredFields: " +
			resolved.requiredFields.map[simpleSignature + " : " + resolvedReturnType].join("; ") + "\n"
		repr += "requiredMethods: " +
			resolved.requiredMethods.map[simpleSignature + " : " + resolvedReturnType].join("; ") + "\n"
		repr += "definedMethods: " +
			resolved.definedMethods.map[simpleSignature + " : " + resolvedReturnType].join("; ") + "\n"
		expected.assertEqualsStrings(repr)
	}

	def private assertDeclaredMethods(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		val resolved = clazz.toResourceTypeRef(typeArguments).xtraitjResolvedOperations
		expected.assertEqualsStrings(
			resolved.declaredMethods.map[simpleSignature + " : " + resolvedReturnType].join("\n")
		)
	}

	def private assertAllDeclarations(Class<?> clazz, CharSequence expected, Class<?>... typeArguments) {
		val resolved = clazz.toResourceTypeRef(typeArguments).xtraitjResolvedOperations
		expected.assertEqualsStrings(
			resolved.allDeclarations.map[simpleSignature + " : " + resolvedReturnType].join("\n")
		)
	}
}
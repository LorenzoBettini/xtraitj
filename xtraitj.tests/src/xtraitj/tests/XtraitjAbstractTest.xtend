package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.util.TypeReferences
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import xtraitj.input.tests.XtraitjInputs
import xtraitj.util.XtraitjModelUtil
import xtraitj.xtraitj.TJProgram

import static extension xtraitj.util.XtraitjModelUtil.*

abstract class XtraitjAbstractTest {
	
	@Inject protected extension TypeReferences
	@Inject protected extension ParseHelper<TJProgram>
	@Inject protected extension XtraitjInputs
	@Inject protected extension ValidationTestHelper
	
	new() {
		// to avoid missing coverage from Jacoco
		new XtraitjModelUtil() {
			
		}
	}
	
	def protected toTypeRef(Class<?> clazz) {
		// the parsed element is used only as the context for
		// TypeReferences.getTypeForName
		getTypeForName(clazz,
			'''
			trait T {}
			'''.
			parse)
	}

	def protected getJavaMethod(Class<?> clazz, String methodName) {
		clazz.toTypeRef.getJavaMethod(methodName)
	}

	def protected getJavaMethod(JvmTypeReference typeRef, String methodName) {
		(typeRef.type as JvmDeclaredType).allFeatures.filter(JvmOperation).findFirst[simpleName == methodName]
	}

	def protected toResourceTypeRef(Class<?> clazz, Class<?>... typeArgs) {
		var typeArguments = ""
		if (typeArgs.length > 0) {
			typeArguments = "<" +
				typeArgs.map[name].join(", ") +
				">"
		}
		
		'''
		trait T {
			«clazz.name»«typeArguments» testField;
		}
		'''.
		parse.traits.head.fields.head.type
	}

	def protected parseAndAssertNoErrors(CharSequence input) {
		input.parse.assertNoErrors
	}
	
}
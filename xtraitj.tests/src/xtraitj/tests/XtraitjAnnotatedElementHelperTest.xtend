package xtraitj.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import com.google.inject.Inject
import xtraitj.util.XtraitjAnnotatedElementHelper
import org.junit.Test
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import static extension org.junit.Assert.*
import org.eclipse.xtext.junit4.util.ParseHelper
import xtraitj.xtraitj.TJProgram
import xtraitj.input.tests.MyAnnotatedJavaInterface
import xtraitj.input.tests.MyAnnotatedJavaClass
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmMember

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjAnnotatedElementHelperTest {
	
	@Inject extension XtraitjAnnotatedElementHelper
	@Inject extension JvmTypesBuilder
	@Inject extension ParseHelper<TJProgram>
	
	@Test def void testAnnotatedTraitInterface() {
		Object.toTypeRef.annotatedTraitInterface.assertFalse
		MyAnnotatedJavaInterface.toTypeRef.annotatedTraitInterface.assertTrue
		MyAnnotatedJavaInterface.toTypeRef.addArrayTypeDimension.
			annotatedTraitInterface.assertFalse
	}

	@Test def void testAnnotatedTraitClass() {
		Object.toTypeRef.annotatedTraitInterface.assertFalse
		MyAnnotatedJavaClass.toTypeRef.annotatedTraitClass.assertTrue
		MyAnnotatedJavaClass.toTypeRef.addArrayTypeDimension.
			annotatedTraitClass.assertFalse
	}

	@Test def void testAnnotatedRequiredField() {
		Object.getJavaMethod("toString").annotatedRequiredField.assertFalse
		MyAnnotatedJavaClass.getJavaMethod("getField").annotatedRequiredField.assertTrue
		MyAnnotatedJavaInterface.getJavaMethod("getField").annotatedRequiredField.assertTrue
		MyAnnotatedJavaClass.getJavaMethod("notAnnotatedMethod").annotatedRequiredField.assertFalse
		MyAnnotatedJavaInterface.getJavaMethod("notAnnotatedMethod").annotatedRequiredField.assertFalse
	}

	@Test def void testAnnotatedRequiredMethod() {
		Object.getJavaMethod("toString").annotatedRequiredMethod.assertFalse
		MyAnnotatedJavaClass.getJavaMethod("getRequired").annotatedRequiredMethod.assertTrue
		MyAnnotatedJavaInterface.getJavaMethod("getRequired").annotatedRequiredMethod.assertTrue
		MyAnnotatedJavaClass.getJavaMethod("notAnnotatedMethod").annotatedRequiredMethod.assertFalse
		MyAnnotatedJavaInterface.getJavaMethod("notAnnotatedMethod").annotatedRequiredMethod.assertFalse
	}

	@Test def void testAnnotatedDefinedMethod() {
		Object.getJavaMethod("toString").annotatedDefinedMethod.assertFalse
		MyAnnotatedJavaClass.getJavaMethod("getDefined").annotatedDefinedMethod.assertTrue
		MyAnnotatedJavaInterface.getJavaMethod("getDefined").annotatedDefinedMethod.assertTrue
		MyAnnotatedJavaClass.getJavaMethod("notAnnotatedMethod").annotatedDefinedMethod.assertFalse
		MyAnnotatedJavaInterface.getJavaMethod("notAnnotatedMethod").annotatedDefinedMethod.assertFalse
	}

	def private toTypeRef(Class<?> clazz) {
		'''
		trait T {}
		'''.
		parse.newTypeRef(clazz)
	}

	def private getJavaMethod(Class<?> clazz, String methodName) {
		(clazz.toTypeRef.type as JvmDeclaredType).
			allFeatures.filter(JvmMember).findFirst[simpleName == methodName]
	}
}
package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.input.tests.MyAnnotatedJavaClass
import xtraitj.input.tests.MyAnnotatedJavaInterface
import xtraitj.util.XtraitjAnnotatedElementHelper

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjAnnotatedElementHelperTest extends XtraitjAbstractTest {
	
	@Inject extension XtraitjAnnotatedElementHelper
	@Inject extension JvmTypesBuilder
	
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

}
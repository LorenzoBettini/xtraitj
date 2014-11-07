package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJTrait

import static org.junit.Assert.*
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjTypeParametersBindingTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper
	@Inject extension IJvmModelAssociations

	@Test def void testTraitDefinedMethodTypeParameterReference() {
		'''
		trait T1<T> {
			T m(T t) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType
		]
	}

	@Test def void testTraitRequiredMethodTypeParameterReference() {
		'''
		trait T1<T> {
			T m(T t);
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType
		]
	}

	@Test def void testTraitGenericDefinedMethodTypeParameterReference() {
		'''
		trait T1 {
			<T> T m(T t) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingMethod
		]
	}

	@Test def void testTraitShadowedGenericDefinedMethodTypeParameterReference() {
		'''
		trait T1<T> {
			<T> T m(T t) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingMethod
		]
	}
	
	private def assertTypeParameterBoundToContainingType(TJProgram it) {
		it.assertJvmOperationTypeParameterBindings[declaringType as JvmGenericType]
	}

	private def assertTypeParameterBoundToContainingMethod(TJProgram it) {
		it.assertJvmOperationTypeParameterBindings[it]
	}

	private def assertJvmOperationTypeParameterBindings(TJProgram it, (JvmOperation)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator) {
		assertNoErrors
		val associatedElements = associatedJvmOperations(it)
//		println(associatedElements)
		for (op : associatedElements) {
			op.assertJvmOperationTypeParameterBindings(expectedTypeParameterDeclarator)
		}
	}
	
	private def associatedJvmOperations(TJProgram it) {
		elements.filter(TJTrait).head.members.filter(TJMethodDeclaration).
			head.jvmElements.filter(JvmOperation).toList
	}

	def private assertJvmOperationTypeParameterBindings(JvmOperation op, (JvmOperation)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator) {
		op.assertJvmOperationTypeParameterBinding(op.returnType, expectedTypeParameterDeclarator)
		for (p : op.parameters) {
			op.assertJvmOperationTypeParameterBinding(p.parameterType, expectedTypeParameterDeclarator)
		}
	}

	def private assertJvmOperationTypeParameterBinding(JvmOperation op, JvmTypeReference typeRef, (JvmOperation)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator) {
		val jvmTypeRef = typeRef as JvmParameterizedTypeReference
		// can be either a JvmGenericType or a JvmOperation in case of
		// a method with a generic type
		val typeParDeclarator = expectedTypeParameterDeclarator.apply(op)
		val expectedTypePar = typeParDeclarator.typeParameters.head
		assertSame(
			"\nop: " + op.identifier + ",\n"
			+ jvmTypeRef.type + "\nbound to\n" +
			expectedTypePar + "\n",
			expectedTypePar,
			jvmTypeRef.type
		)
	}

}
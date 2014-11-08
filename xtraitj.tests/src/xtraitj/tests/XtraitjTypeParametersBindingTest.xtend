package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJTrait

import static org.junit.Assert.*
import static extension xtraitj.util.XtraitjModelUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjTypeParametersBindingTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper
	@Inject extension IJvmModelAssociations
	
	/** 1 in the interface, 2 in the class */
	val static EXPECTED_OPS_FOR_DEFINED_METHOD = 3

	/** 1 in the interface, 1 in the class */
	val static EXPECTED_OPS_FOR_REQUIRED_METHOD = 2

	/** 2 in the interface, 2 in the class */
	val static EXPECTED_OPS_FOR_REQUIRED_FIELD = 4

	/** 2 in the class */
	val static EXPECTED_OPS_FOR_USED_DEFINED_METHOD = 2

	/** 1 in the class */
	val static EXPECTED_OPS_FOR_USED_REQUIRED_METHOD = 1

	/** 2 in the class */
	val static EXPECTED_OPS_FOR_USED_REQUIRED_FIELD = 2

	/** 1 in the interface, 2 in the class, the same for adapters */
	val static EXPECTED_OPS_FOR_RENAME_DEFINED_METHOD = 6

	/** 1 in the interface, 1 in the class, the same for adapters */
	val static EXPECTED_OPS_FOR_RENAME_REQUIRED_METHOD = 4

	/** 2 in the interface, 2 in the class, the same for adapters */
	val static EXPECTED_OPS_FOR_RENAME_REQUIRED_FIELD = 8

	@Test def void testTraitDefinedMethodTypeParameterReference() {
		'''
		trait T1<T> {
			T m(T t) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitRequiredMethodTypeParameterReference() {
		'''
		trait T1<T> {
			T m(T t);
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_METHOD)
		]
	}

	@Test def void testTraitRequiredFieldTypeParameterReference() {
		'''
		trait T1<T> {
			T f;
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}

	@Test def void testTraitGenericDefinedMethodTypeParameterReference() {
		'''
		trait T1 {
			<T> T m(T t) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitShadowedGenericDefinedMethodTypeParameterReference() {
		'''
		trait T1<T> {
			<T> T m(T t) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitShadowedGenericRequiredMethodTypeParameterReference() {
		'''
		trait T1<T> {
			<T> T m(T t);
		}
		'''.parse => [
			assertTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_REQUIRED_METHOD)
		]
	}

	@Test def void testTraitUsedDefinedMethodTypeParameterReference() {
		'''
		trait T1<T> uses T2<T> {
			
		}
		
		trait T2<U> {
			U m(U u) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_USED_DEFINED_METHOD)
		]
	}

	@Test def void testTraitUsedRequiredMethodTypeParameterReference() {
		'''
		trait T1<T> uses T2<T> {
			
		}
		
		trait T2<U> {
			U m(U u);
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_USED_REQUIRED_METHOD)
		]
	}

	@Test def void testTraitUsedRequiredFieldTypeParameterReference() {
		'''
		trait T1<T> uses T2<T> {
			
		}
		
		trait T2<U> {
			U f;
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_USED_REQUIRED_FIELD)
		]
	}

	@Test def void testTraitRenamesRequiredFieldTypeParameterReference() {
		'''
		trait T1<T> uses T2<T>[rename field f to g] {
			
		}
		
		trait T2<U> {
			U f;
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_REQUIRED_FIELD)
		]
	}

	@Test def void testTraitRenamesRequiredMethodTypeParameterReference() {
		'''
		trait T1<T> uses T2<T>[rename m to n] {
			
		}
		
		trait T2<U> {
			U m(U u);
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_REQUIRED_METHOD)
		]
	}

	@Test def void testTraitRenamesDefinedMethodTypeParameterReference() {
		'''
		trait T1<T> uses T2<T>[rename m to n] {
			
		}
		
		trait T2<U> {
			U m(U u) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_DEFINED_METHOD)
		]
	}
	
	private def assertTypeParameterBoundToContainingType(TJProgram it,
			int expectedAssociatedElements) {
		it.assertJvmOperationTypeParameterBindings(expectedAssociatedElements)[declaringType as JvmGenericType]
	}

	private def assertTypeParameterBoundToContainingMethod(TJProgram it,
			int expectedAssociatedElements) {
		it.assertJvmOperationTypeParameterBindings(expectedAssociatedElements)[it]
	}

	private def assertJvmOperationTypeParameterBindings(TJProgram it,
		int expectedAssociatedElements,
		(JvmOperation)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator
	) {
		assertNoErrors
		val associatedElements = associatedJvmOperations(it)
		//println(associatedElements)
		assertFalse("No associated elements", associatedElements.empty)
		assertEquals(expectedAssociatedElements, associatedElements.size)
		for (op : associatedElements) {
			op.assertJvmOperationTypeParameterBindings(expectedTypeParameterDeclarator)
		}
	}
	
	/**
	 * Retrieves all the JvmOperations associated to the first trait in the program,
	 * including the ones generated for used traits with alteration operations
	 */
	private def associatedJvmOperations(TJProgram it) {
		val trait = elements.filter(TJTrait).head
		trait.jvmElements.filter(JvmGenericType).
				map[declaredOperations].flatten +
		trait.traitReferences.map[jvmElements.filter(JvmGenericType).
				map[declaredOperations].flatten].flatten
	}

	def private assertJvmOperationTypeParameterBindings(JvmOperation op, (JvmOperation)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator) {
		if (!op.simpleName.startsWith("set")) {
			// the setter method is void
			op.assertJvmOperationTypeParameterBinding(op.returnType, expectedTypeParameterDeclarator)
		}
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
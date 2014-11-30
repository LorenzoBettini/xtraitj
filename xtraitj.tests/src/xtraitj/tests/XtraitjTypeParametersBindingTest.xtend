package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.common.types.JvmTypeParameter
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
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJTrait

import static org.junit.Assert.*

import static extension xtraitj.util.XtraitjModelUtil.*
import org.eclipse.xtext.xtype.XFunctionTypeRef

/**
 * Tests that type parameter references in the inferred Java interfaces and
 * classes are correct: they refer to the containing type parameter declarator.
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjTypeParametersBindingTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper
	@Inject extension IJvmModelAssociations
	
	/** 1 in the interface, 2 in the class */
	val static EXPECTED_OPS_FOR_DEFINED_METHOD = 3

	/** 1 in the class */
	val static CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD = 1

	/** 1 in the interface, 1 in the class */
	val static EXPECTED_OPS_FOR_REQUIRED_METHOD = 2

	/** 2 in the interface, 2 in the class */
	val static EXPECTED_OPS_FOR_REQUIRED_FIELD = 4

	/** 2 in the class */
	val static CLASS_EXPECTED_OPS_FOR_REQUIRED_FIELD = 2

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

	@Test def void testTraitDefinedMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> m(List<T> t) { return null; }
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

	@Test def void testTraitRequiredMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> m(List<T> t);
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

	@Test def void testTraitRequiredFieldTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> f;
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}

	@Test def void testTraitRequiredFieldTypeParameterFunctionalType() {
		'''
		trait T1<T> {
			(T)=>T f;
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}

	@Test def void testTraitRequiredFieldTypeParameterFunctionalType2() {
		'''
		import java.util.List
		
		trait T1<T> {
			(List<T>)=>List<T> f;
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

	@Test def void testTraitGenericDefinedMethodTypeParameterReference2() {
		'''
		import java.util.List		
		
		trait T1 {
			<T> List<T> m(List<T> t) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassGenericDefinedMethodTypeParameterReference() {
		'''
		trait T1 {
			<T> T m(T t) { return null; }
		}
		
		class C uses T1 {
			
		}
		'''.parse => [
			assertTypeParameterBoundToContainingMethod(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassGenericDefinedMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1 {
			<T> List<T> m(List<T> t) { return null; }
		}
		
		class C uses T1 {
			
		}
		'''.parse => [
			assertTypeParameterBoundToContainingMethod(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
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

	@Test def void testTraitUsedDefinedMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> uses T2<T> {
			
		}
		
		trait T2<U> {
			List<U> m(List<U> u) { return null; }
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

	@Test def void testTraitUsedRequiredMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> uses T2<T> {
			
		}
		
		trait T2<U> {
			List<U> m(List<U> u);
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

	@Test def void testTraitUsedRequiredFieldTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> uses T2<T> {
			
		}
		
		trait T2<U> {
			List<U> f;
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

	@Test def void testTraitRenamesRequiredFieldTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> uses T2<T>[rename field f to g] {
			
		}
		
		trait T2<U> {
			List<U> f;
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

	@Test def void testTraitRenamesRequiredMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> uses T2<T>[rename m to n] {
			
		}
		
		trait T2<U> {
			List<U> m(List<U> u);
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

	@Test def void testTraitRenamesDefinedMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> uses T2<T>[rename m to n] {
			
		}
		
		trait T2<U> {
			List<U> m(List<U> u) { return null; }
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_DEFINED_METHOD)
		]
	}

	@Test def void testClassDefinedMethodTypeParameterReference() {
		'''
		trait T1<T> {
			T m(T t) { return null; }
		}
		
		class C<U> uses T1<U> {
			
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassDefinedMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> m(List<T> t) { return null; }
		}
		
		class C<U> uses T1<U> {
			
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassRequiredMethodTypeParameterReference() {
		'''
		trait T1<T> {
			T m(T t);
		}
		
		trait T2<V> {
			V m(V t) { return null; }
		}
		
		class C<U> uses T1<U>, T2<U> {
			
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassRequiredMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> m(List<T> t);
		}
		
		trait T2<V> {
			List<V> m(List<V> t) { return null; }
		}
		
		class C<U> uses T1<U>, T2<U> {
			
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassFieldTypeParameterReference() {
		'''
		class C<U> {
			U f;
		}
		'''.parse => [
			assertTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_REQUIRED_FIELD)
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
		// println(associatedElements)
		assertFalse("No associated elements", associatedElements.empty)
		assertEquals(expectedAssociatedElements, associatedElements.size)
		for (op : associatedElements) {
			op.assertJvmOperationTypeParameterBindings(expectedTypeParameterDeclarator)
		}
	}
	
	/**
	 * Retrieves all the JvmOperations associated to the first class or 
	 * trait in the program, (if there's a class, then uses that class, otherwise,
	 * it uses the first trait)
	 * including the ones generated for used traits with alteration operations
	 */
	private def associatedJvmOperations(TJProgram it) {
		val TJDeclaration programElement = 
			elements.filter(TJClass).head ?: elements.filter(TJTrait).head
		programElement.jvmElements.filter(JvmGenericType).
				map[declaredOperations].flatten +
		programElement.traitReferences.map[jvmElements.filter(JvmGenericType).
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
		// can be either a JvmGenericType or a JvmOperation in case of
		// a method with a generic type
		val typeParDeclarator = expectedTypeParameterDeclarator.apply(op)
		
		if (typeRef instanceof JvmParameterizedTypeReference) {
			assertJvmOperationTypeParameterBindingAgainstTypeParDeclarator(
				op, typeRef, typeParDeclarator, "JvmParameterizedTypeReference"
			)
		} else if (typeRef instanceof XFunctionTypeRef) {
			assertJvmOperationTypeParameterBindingAgainstTypeParDeclarator(
				op, typeRef.returnType, typeParDeclarator,
				"XFunctionTypeRef.returnType"
			)
			for (p : typeRef.paramTypes) {
				assertJvmOperationTypeParameterBindingAgainstTypeParDeclarator(
					op, p, typeParDeclarator,
					"XFunctionTypeRef.paramType"
				)
			}
		} else {
			fail("Unknown JvmTypeReference: " + typeRef)
		}
	}
	
	private def assertJvmOperationTypeParameterBindingAgainstTypeParDeclarator(JvmOperation op, JvmTypeReference jvmTypeRef, JvmTypeParameterDeclarator typeParDeclarator, String desc) {
		val expectedTypePar = typeParDeclarator.typeParameters.head
		
		val type = jvmTypeRef.type
		
		if (type instanceof JvmTypeParameter) {
			assertTypeParameterBinding(op, jvmTypeRef, expectedTypePar, type, desc)
		} else if (type instanceof JvmGenericType) {
			// assume it is a parameterized type and we take the first type argument
			// e.g., List<T> 
			assertTypeParameterBinding(op, jvmTypeRef, expectedTypePar, 
				(jvmTypeRef as JvmParameterizedTypeReference).arguments.head.type,
				desc
			)
		} else {
			fail("Unknown JvmType: " + type)
		}
	}
	
	private def assertTypeParameterBinding(JvmOperation op, JvmTypeReference jvmTypeRef, JvmTypeParameter expectedTypePar, JvmType actualType, String desc) {
		assertSame(
			desc +
			"\nop: " + op.identifier + ",\n"
			+ jvmTypeRef.type + "\nbound to\n" +
			expectedTypePar + "\n",
			expectedTypePar,
			actualType
		)
	}

}
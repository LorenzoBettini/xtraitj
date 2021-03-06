package xtraitj.tests

import com.google.inject.Inject
import java.util.List
import org.apache.log4j.Logger
import org.eclipse.xtext.common.types.JvmConstraintOwner
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmWildcardTypeReference
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.jvmmodel.JvmModelAssociator
import org.eclipse.xtext.xtype.XFunctionTypeRef
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.tests.utils.XtraitjLogListener
import xtraitj.xtraitj.TJClass
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJTrait

import static org.junit.Assert.*

import static extension xtraitj.util.XtraitjModelUtil.*

/**
 * Tests that type parameter references in the inferred Java interfaces and
 * classes are correct: they refer to the containing type parameter declarator.
 */
@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjTypeParametersBindingTest extends XtraitjAbstractTest {
	@Inject extension IJvmModelAssociations

	/** 1 interface, 1 class */
	val static EXPECTED_JVM_TYPES_FOR_TRAIT = 2

	/** 1 class */
	val static EXPECTED_JVM_TYPES_FOR_CLASS = 1
	
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
	
	private final static Logger LOG = Logger.getLogger(JvmModelAssociator);

	var XtraitjLogListener logListener

	@Before
	def void createAppender() {
		logListener = new XtraitjLogListener => [
			LOG.addAppender(it)
		]
	}

	@After
	def void removeAppender() {
		LOG.removeAppender(logListener)
	}
	

	@Test def void testTraitBoundsTypeParameterReference() {
		'''
		trait T1<T extends Comparable<T>> {
		}
		'''.parse => [
			assertJvmGenericTypeTypeParameterBindings(EXPECTED_JVM_TYPES_FOR_TRAIT)
		]
	}

	@Test def void testTraitWildcardUpperBoundTypeParameterReference() {
		'''
		trait T1<T extends Comparable<? extends T>> {
		}
		'''.parse => [
			assertJvmGenericTypeTypeParameterBindings(EXPECTED_JVM_TYPES_FOR_TRAIT)
		]
	}

	@Test def void testTraitWildcardLowerBoundTypeParameterReference() {
		'''
		trait T1<T extends Comparable<? super T>> {
		}
		'''.parse => [
			assertJvmGenericTypeTypeParameterBindings(EXPECTED_JVM_TYPES_FOR_TRAIT)
		]
	}

	@Test def void testClassBoundsTypeParameterReference() {
		'''
		class C<T extends Comparable<T>> {
		}
		'''.parse => [
			assertJvmGenericTypeTypeParameterBindings(EXPECTED_JVM_TYPES_FOR_CLASS)
		]
	}

	@Test def void testClassWildcardUpperBoundTypeParameterReference() {
		'''
		class C<T extends Comparable<? extends T>> {
		}
		'''.parse => [
			assertJvmGenericTypeTypeParameterBindings(EXPECTED_JVM_TYPES_FOR_CLASS)
		]
	}

	@Test def void testClassWildcardLowerBoundTypeParameterReference() {
		'''
		class C<T extends Comparable<? super T>> {
		}
		'''.parse => [
			assertJvmGenericTypeTypeParameterBindings(EXPECTED_JVM_TYPES_FOR_CLASS)
		]
	}

	@Test def void testTraitDefinedMethodTypeParameterReference() {
		'''
		trait T1<T> {
			T m(T t) { return null; }
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitDefinedMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> m(List<T> t) { return null; }
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitRequiredMethodTypeParameterReference() {
		'''
		trait T1<T> {
			T m(T t);
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_METHOD)
		]
	}

	@Test def void testTraitRequiredMethodTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> m(List<T> t);
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_METHOD)
		]
	}

	@Test def void testTraitRequiredFieldTypeParameterReference() {
		'''
		trait T1<T> {
			T f;
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}

	@Test def void testTraitRequiredFieldTypeParameterReference2() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> f;
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}

	@Test def void testTraitRequiredFieldTypeParameterFunctionalType() {
		'''
		trait T1<T> {
			(T)=>T f;
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}

	@Test def void testTraitRequiredFieldTypeParameterFunctionalType2() {
		'''
		import java.util.List
		
		trait T1<T> {
			(List<T>)=>List<T> f;
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}

	@Test def void testClassRequiredFieldTypeParameterFunctionalType() {
		'''
		trait T1<T> {
			(T)=>T f;
		}
		
		class C<U> uses T1<U> {
			(U)=>U f;
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}

	@Test def void testClassRequiredFieldTypeParameterFunctionalType2() {
		'''
		import java.util.List
		
		trait T1<T> {
			(List<T>)=>List<T> f;
		}
		
		class C<U> uses T1<U> {
			(List<U>)=>List<U> f;
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}

	@Test def void testTraitGenericDefinedMethodTypeParameterReference() {
		'''
		trait T1 {
			<T> T m(T t) { return null; }
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitGenericDefinedMethodTypeParameterReference2() {
		'''
		import java.util.List		
		
		trait T1 {
			<T> List<T> m(List<T> t) { return null; }
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitGenericDefinedMethodTypeParameterWithUpperBound() {
		'''
		trait T1 {
			<T extends Comparable<T>> T m(T t) { return null; }
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitGenericDefinedMethodTypeParameterWithWildcardUpperBound() {
		'''
		trait T1 {
			<T extends Comparable<? extends T>> T m(T t) { return null; }
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitGenericDefinedMethodTypeParameterWithWildcardLowerBound() {
		'''
		trait T1 {
			<T extends Comparable<? super T>> T m(T t) { return null; }
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitGenericRequiredMethodTypeParameterWithUpperBound() {
		'''
		trait T1 {
			<T extends Comparable<T>> T m(T t);
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_REQUIRED_METHOD)
		]
	}

	@Test def void testTraitGenericRequiredMethodTypeParameterWithWildcardUpperBound() {
		'''
		trait T1 {
			<T extends Comparable<? extends T>> T m(T t);
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_REQUIRED_METHOD)
		]
	}

	@Test def void testTraitGenericRequiredMethodTypeParameterWithWildcardLowerBound() {
		'''
		trait T1 {
			<T extends Comparable<? super T>> T m(T t);
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_REQUIRED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingMethod(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingMethod(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassGenericDefinedMethodTypeParameterWithUpperBound() {
		'''
		import java.util.List
		
		trait T1 {
			<T extends Comparable<T>> List<T> m(List<T> t) { return null; }
		}
		
		class C uses T1 {
			
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassGenericDefinedMethodTypeParameterWithWildcardUpperBound() {
		'''
		import java.util.List
		
		trait T1 {
			<T extends Comparable<? extends T>> List<T> m(List<T> t) { return null; }
		}
		
		class C uses T1 {
			
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassGenericDefinedMethodTypeParameterWithWildcardLowerBound() {
		'''
		import java.util.List
		
		trait T1 {
			<T extends Comparable<? extends T>> List<T> m(List<T> t) { return null; }
		}
		
		class C uses T1 {
			
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitShadowedGenericDefinedMethodTypeParameterReference() {
		'''
		trait T1<T> {
			<T> T m(T t) { return null; }
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testTraitShadowedGenericRequiredMethodTypeParameterReference() {
		'''
		trait T1<T> {
			<T> T m(T t);
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingMethod(EXPECTED_OPS_FOR_REQUIRED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_USED_DEFINED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_USED_DEFINED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_USED_REQUIRED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_USED_REQUIRED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_USED_REQUIRED_FIELD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_USED_REQUIRED_FIELD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_REQUIRED_FIELD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_REQUIRED_FIELD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_REQUIRED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_REQUIRED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_DEFINED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(EXPECTED_OPS_FOR_RENAME_DEFINED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
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
			assertJvmOperationTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_DEFINED_METHOD)
		]
	}

	@Test def void testClassFieldTypeParameterReference() {
		'''
		class C<U> {
			U f;
		}
		'''.parse => [
			assertJvmOperationTypeParameterBoundToContainingType(CLASS_EXPECTED_OPS_FOR_REQUIRED_FIELD)
		]
	}
	
	private def assertJvmOperationTypeParameterBoundToContainingType(TJProgram it,
			int expectedAssociatedElements) {
		it.assertJvmOperationTypeParameterBindings(expectedAssociatedElements)
			[(it as JvmOperation).declaringType as JvmGenericType]
	}

	private def assertJvmOperationTypeParameterBoundToContainingMethod(TJProgram it,
			int expectedAssociatedElements) {
		it.assertJvmOperationTypeParameterBindings(expectedAssociatedElements)[it]
	}

	private def assertJvmOperationTypeParameterBindings(TJProgram it,
		int expectedAssociatedElements,
		(JvmTypeParameterDeclarator)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator
	) {
		assertNoErrors
		// there must be no error in the log either
		assertTrue("Some error was reported in the LOG", logListener.events.empty)
		
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

	private def assertJvmGenericTypeTypeParameterBindings(TJProgram it,
		int expectedAssociatedElements
	) {
		assertNoErrors
		// there must be no error in the log either
		assertTrue("Some error was reported in the LOG", logListener.events.empty)
		
		val associatedElements = associatedJvmGenericTypes(it)
		// println(associatedElements)
		assertFalse("No associated elements", associatedElements.empty)
		assertEquals(expectedAssociatedElements, associatedElements.size)
		for (t : associatedElements) {
			t.assertJvmGenericTypeTypeParameterBindings[it]
		}
	}

	/**
	 * Retrieves all the JvmGenericTypes associated to the first class or 
	 * trait in the program, (if there's a class, then uses that class, otherwise,
	 * it uses the first trait)
	 * including the ones generated for used traits with alteration operations
	 */
	private def Iterable<JvmGenericType> associatedJvmGenericTypes(TJProgram it) {
		val TJDeclaration programElement = 
			elements.filter(TJClass).head ?: elements.filter(TJTrait).head
		programElement.jvmElements.filter(JvmGenericType) +
		programElement.traitReferences.map[jvmElements.filter(JvmGenericType)].flatten
	}

	def private assertJvmOperationTypeParameterBindings(JvmOperation op, (JvmTypeParameterDeclarator)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator) {
		if (!op.simpleName.startsWith("set")) {
			// the setter method is void
			op.assertJvmTypeParameterBinding(op.returnType, expectedTypeParameterDeclarator)
		}
		for (p : op.parameters) {
			op.assertJvmTypeParameterBinding(p.parameterType, expectedTypeParameterDeclarator)
		}
		assertJvmTypeParameterDeclaratorTypeParameterBindings(op, expectedTypeParameterDeclarator)
	}

	def private assertJvmGenericTypeTypeParameterBindings(JvmGenericType t, (JvmTypeParameterDeclarator)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator) {
		assertJvmTypeParameterDeclaratorTypeParameterBindings(t, expectedTypeParameterDeclarator)
	}
	
	private def assertJvmTypeParameterDeclaratorTypeParameterBindings(JvmTypeParameterDeclarator t, (JvmTypeParameterDeclarator)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator) {
		for (typePar : t.typeParameters) {
			assertJvmConstraintsTypeParameterBindings(t, typePar, expectedTypeParameterDeclarator)
		}
	}
	
	private def assertJvmConstraintsTypeParameterBindings(JvmTypeParameterDeclarator t, JvmConstraintOwner constraintOwner, (JvmTypeParameterDeclarator)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator) {
		for (c : constraintOwner.constraints) {
			t.assertJvmTypeParameterBinding(c.typeReference, expectedTypeParameterDeclarator)
		}
	}

	def private assertJvmTypeParameterBinding(JvmTypeParameterDeclarator op, JvmTypeReference typeRef, (JvmTypeParameterDeclarator)=>JvmTypeParameterDeclarator expectedTypeParameterDeclarator) {
		// can be either a JvmGenericType or a JvmOperation in case of
		// a method with a generic type
		val typeParDeclarator = expectedTypeParameterDeclarator.apply(op)
		
		if (typeRef instanceof JvmParameterizedTypeReference) {
			assertJvmTypeParameterBindingAgainstTypeParDeclarator(
				op, typeRef, typeParDeclarator, "JvmParameterizedTypeReference"
			)
		} else if (typeRef instanceof XFunctionTypeRef) {
			assertJvmTypeParameterBindingAgainstTypeParDeclarator(
				op, typeRef.returnType, typeParDeclarator,
				"XFunctionTypeRef.returnType"
			)
			for (p : typeRef.paramTypes) {
				assertJvmTypeParameterBindingAgainstTypeParDeclarator(
					op, p, typeParDeclarator,
					"XFunctionTypeRef.paramType"
				)
			}
		} else {
			fail("Unknown JvmTypeReference: " + typeRef)
		}
	}
	
	private def void assertJvmTypeParameterBindingAgainstTypeParDeclarator(
		JvmTypeParameterDeclarator op, JvmTypeReference jvmTypeRef,
		JvmTypeParameterDeclarator typeParDeclarator, String desc
	) {
		val typeParams = typeParDeclarator.typeParameters
		
		for (typeParam : typeParams) {
			val type = jvmTypeRef.type
		
			if (type instanceof JvmTypeParameter) {
				assertTypeParameterBinding(
					op, jvmTypeRef,
					typeParams.typeParamByName(jvmTypeRef), type, desc
				)
			} else if (type instanceof JvmGenericType) {
				val typeArgs = (jvmTypeRef as JvmParameterizedTypeReference).arguments
				for (typeArg : typeArgs) {
					if (typeArg instanceof JvmWildcardTypeReference) {
						for (c : typeArg.constraints) {
							op.assertJvmTypeParameterBindingAgainstTypeParDeclarator(
								c.typeReference, typeParDeclarator, "Wildcard." + desc
							)
						}
					} else {
						if (typeArg != null) {
							assertTypeParameterBinding(
								op, jvmTypeRef,
								typeParams.typeParamByName(typeArg), 
								typeArg.type, desc
							)
						}
					}
				}
			} else {
				fail("Unknown JvmType: " + type)
			}	
		}
	}

	private def typeParamByName(List<JvmTypeParameter> typeParams, JvmTypeReference typeRef) {
		val typePar = typeParams.findFirst[ tp | tp.simpleName == typeRef.type.simpleName ]
		assertNotNull("could not find " + typeRef.type.simpleName, typePar)
		return typePar
	}
	
	private def assertTypeParameterBinding(JvmTypeParameterDeclarator e, JvmTypeReference jvmTypeRef, JvmTypeParameter expectedTypePar, JvmType actualType, String desc) {
		val id = switch (e) {
			JvmOperation: "\nop: " + e.identifier
			JvmGenericType: "\njava type: " + e.identifier
		}
		
		assertSame(
			desc +
			id + ",\n"
			+ jvmTypeRef.type + "\nbound to\n" +
			expectedTypePar + "\n",
			expectedTypePar,
			actualType
		)
	}

}
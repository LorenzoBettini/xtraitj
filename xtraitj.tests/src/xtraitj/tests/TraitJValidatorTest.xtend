package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.TypesPackage
import org.eclipse.xtext.diagnostics.Diagnostic
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.validation.XtraitjValidator
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.XtraitjPackage

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class TraitJValidatorTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper

	@Test def void testCycle() {
		'''
		trait T1 uses T2, T1 {}
		
		trait T2 {}
		'''.parse.assertError(
			XtraitjPackage::eINSTANCE.TJTrait,
			XtraitjValidator::DEPENDENCY_CYCLE,
			"Cycle in dependency of 'T1'"
		)
	}

	@Test def void testCycle2() {
		'''
		trait T1 uses T2, T3 {}
		
		trait T2 {}
		trait T3 uses T2, T1 {}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJTrait,
				XtraitjValidator::DEPENDENCY_CYCLE,
				"Cycle in dependency of 'T1'"
			)
		]
	}

	@Test def void testTraitInitializeField() {
		'''
		trait T {
			String s = "foo";
		}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJField,
				XtraitjValidator::TRAIT_INITIALIZES_FIELD,
				"Traits cannot initialize fields"
			)
		]
	}

	@Test def void testClassMissingFields() {
		'''
		trait T {
			String s;
		}
		
		class C uses T {}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJClass,
				XtraitjValidator::MISSING_REQUIRED_FIELD,
				"Class must provide required field 'String s'"
			)
		]
	}

	@Test def void testClassMissingRequiredMethod() {
		'''
		trait T1 {
			int m() { return 0; }
			String n(int i);
		}
		
		trait T2 {
			Integer m(); // this satisfy T1's requirement
		}
		
		class C uses T1, T2 {}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJClass,
				XtraitjValidator::MISSING_REQUIRED_METHOD,
				"Class must provide required method 'String n(int)'"
			)
		]
	}

	@Test def void testClassMissingRenamedRequiredMethod() {
		'''
		trait T1 {
			int m() { return 0; }
			String n(int i);
		}
		
		trait T2 {
			String n(int i) { "n" }; // this satisfy T1's requirement
		}
		
		trait T3 uses T2[rename n to n1] {}
		
		class C uses T1, T3 {}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJClass,
				XtraitjValidator::MISSING_REQUIRED_METHOD,
				"Class must provide required method 'String n(int)'"
			)
		]
	}

	@Test def void testClassMissingRestrictedMethod() {
		'''
		trait T1 {
			String m() { return 0; }
		}
		
		trait T2 uses T1[restrict m] {}
		
		class C uses T2 {}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJClass,
				XtraitjValidator::MISSING_REQUIRED_METHOD,
				"Class must provide required method 'String m()'"
			)
		]
	}

	@Test def void testHideRequiredMethod() {
		'''
		trait T1 {
			String n(int i);
		}
		
		trait T2 uses T1[hide n] {
		}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJHideOperation,
				XtraitjValidator::HIDING_REQUIRED,
				"Cannot hide required method 'n'"
			)
		]
	}

	@Test def void testAliasRequiredMethod() {
		'''
		trait T1 {
			String n(int i);
		}
		
		trait T2 uses T1[alias n] {
		}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJAliasOperation,
				XtraitjValidator::ALIASING_REQUIRED,
				"Cannot alias required method 'n'"
			)
		]
	}

	@Test def void testRestrictRequiredMethod() {
		'''
		trait T1 {
			String n(int i);
		}
		
		trait T2 uses T1[restrict n] {
		}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJRestrictOperation,
				XtraitjValidator::RESTRICTING_REQUIRED,
				"Cannot restrict required method 'n'"
			)
		]
	}

	@Test def void testOperationOnPrivateMethod() {
		'''
		trait T1 {
			private String n(int i) { null }
		}
		
		trait T2 uses T1[restrict n] {
		}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJRestrictOperation,
				Diagnostic::LINKING_DIAGNOSTIC,
				"Couldn't resolve reference to JvmMember 'n'."
			)
		]
	}

	@Test def void testFieldRedirectedToMethod() {
		'''
		trait T1 {
			String f;
			String m() { null }
		}
		
		trait T2 uses T1[redirect f to m] {
		}
		'''.parse.assertError(
				XtraitjPackage::eINSTANCE.TJRedirectOperation,
				XtraitjValidator::FIELD_REDIRECTED_TO_METHOD,
				"Cannot redirect field 'f' to method 'm'"
			)
	}

	@Test def void testMethodRedirectedToField() {
		'''
		trait T1 {
			String f;
			String m() { null }
		}
		
		trait T2 uses T1[redirect m to f] {
		}
		'''.parse.assertError(
				XtraitjPackage::eINSTANCE.TJRedirectOperation,
				XtraitjValidator::METHOD_REDIRECTED_TO_FIELD,
				"Cannot redirect method 'm' to field 'f'"
			)
	}
	
	@Test 
	def void testRedirectNotCompliant() {
		'''
		import java.util.List
		import java.util.ArrayList
		
		trait T1 {
			String f;
			int i;
			
			List<? extends String> m();
			List<String> n();
		}
		
		trait T2 uses T1[redirect f to i, redirect n to m] {
		}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJRedirectOperation,
				XtraitjValidator::REDIRECT_NOT_COMPLIANT,
				"'int i' is not compliant with 'String f'"
			)
			assertError(
				XtraitjPackage::eINSTANCE.TJRedirectOperation,
				XtraitjValidator::REDIRECT_NOT_COMPLIANT,
				"'List<? extends String> m()' is not compliant with 'List<String> n()'"
			)
		]
	}

	@Test 
	def void testRedirectToTheSameMember() {
		'''
		trait T1 {
			String f;
			
			int n();
		}
		
		trait T2 uses T1[redirect f to f, redirect n to n] {
		}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJRedirectOperation,
				XtraitjValidator::REDIRECT_TO_SAME_MEMBER,
				"Redirect to the same member 'f'"
			)
			assertError(
				XtraitjPackage::eINSTANCE.TJRedirectOperation,
				XtraitjValidator::REDIRECT_TO_SAME_MEMBER,
				"Redirect to the same member 'n'"
			)
		]
	}

	@Test
	def void testClassImplementsClass() {
		'''
		class C implements java.util.LinkedList {}
		'''.parse.assertError(
				TypesPackage::eINSTANCE.jvmParameterizedTypeReference,
				XtraitjValidator::NOT_AN_INTERFACE,
				"Not a valid interface 'LinkedList'"
			)
	}

	@Test
	def void testClassDoesNotImplementAllInterfaceMethods() {
		'''
		class C implements java.util.List {}
		'''.parse => [
			assertMissingInterfaceMethod("void add(int, E)")
			assertMissingInterfaceMethod("int indexOf(Object)")
		]
	}

	@Test def void testClassImplementsAllInterfaceMethods() {
		'''
		import xtraitj.input.tests.MyTestInterface
		
		trait T {
			int m(java.util.List<String> l) { return l.size }
		}
		
		class C implements MyTestInterface uses T {}
		'''.parse.assertNoErrors
	}

	@Test def void testDuplicateTraitReference() {
		'''
		trait T {}
		
		class C uses T, T {}
		'''.parse.assertError(
			XtraitjPackage::eINSTANCE.TJTraitReference,
			XtraitjValidator::DUPLICATE_TRAIT_REFERENCE,
			"Duplicate trait reference 'T'"
		)
	}

	@Test def void testDuplicateTraitReference_Issue_2() {
		'''
		trait T {}
		
		trait T1 uses T, T {}
		'''.parse.assertError(
			XtraitjPackage::eINSTANCE.TJTraitReference,
			XtraitjValidator::DUPLICATE_TRAIT_REFERENCE,
			"Duplicate trait reference 'T'"
		)
	}

	@Test def void testDuplicateMember() {
		'''
		trait T {
			int f;
			int f;
			String m();
			String m(int i) { return null; }
		}
		
		class C {
			String c;
			int c;
		}
		'''.parse => [
			assertDuplicateMember("f", XtraitjPackage::eINSTANCE.TJField)
			assertDuplicateMember("c", XtraitjPackage::eINSTANCE.TJField)
			assertDuplicateMember("m", XtraitjPackage::eINSTANCE.TJMethod)
			assertDuplicateMember("m", XtraitjPackage::eINSTANCE.TJRequiredMethod)
		]
	}

	@Test def void testFieldConflicts() {
		'''
		trait T1 {
			String s;
		}
		
		trait T2 {
			int s;
		}
		
		trait T3 uses T1, T2 {}
 		'''.parse => [
 			assertFieldConflict("String s", "T1")
 			assertFieldConflict("int s", "T2")
 		]
	}

	@Test def void testFieldConflicts2() {
		'''
		trait T1 {
			String s;
		}
		
		trait T2 uses T1 {
			String s;
		}
 		'''.parse => [
 			assertFieldConflict("String s", "T1")
 			assertDeclaredFieldConflict("s")
 		]
	}

	@Test def void testFieldConflicts3() {
		'''
		trait T1 {
			String s;
		}
		
		trait T2 {
			int i;
		}
		
		trait T3 uses T1, T2 {
			String s;
		}'''.parse => [
 			assertFieldConflict("String s", "T1")
 			assertDeclaredFieldConflict("s")
 		]
	}

	@Test def void testFieldConflicts4() {
		'''
		trait T1 {
			int i;
		}
		
		trait T2 {
			String s;
		}
		
		trait T3 uses T1, T2 {
			String s;
		}'''.parse => [
 			assertFieldConflict("String s", "T2")
 			assertDeclaredFieldConflict("s")
 		]
	}

	@Test def void testFieldConflicts5() {
		'''
		trait T1 {
			int i;
		}
		
		trait T2 {
			String s;
		}
		
		trait T3 uses T1, T2 {
			String s;
			int i;
		}'''.parse => [
 			assertFieldConflict("String s", "T2")
 			assertDeclaredFieldConflict("s")
 			assertFieldConflict("int i", "T1")
 			assertDeclaredFieldConflict("i")
 		]
	}

	@Test def void testRequiredMethodConflicts() {
		'''
		trait T1 {
			String m(int i);
		}
		
		trait T2 {
			int m(int i);
		}
		
		trait T3 uses T1, T2 {}
 		'''.parse => [
 			assertMethodConflict("String m(int)", "T1")
 			assertMethodConflict("int m(int)", "T2")
 		]
	}

	@Test def void testRequiredMethodConflicts2() {
		'''
		trait T1 {
			String m(int i);
		}
		
		trait T2 uses T1 {
			String m(int i);
		}
 		'''.parse => [
 			assertMethodConflict("String m(int)", "T1")
 			assertDeclaredMethodConflict("m")
 		]
	}

	@Test def void testRequiredMethodConflicts3() {
		'''
		trait T1 {
			String m(int i);
		}
		
		trait T2 {
			int n(boolean i);
		}
		
		trait T3 uses T1, T2 {
			String m(int i);
		}
 		'''.parse => [
 			assertMethodConflict("String m(int)", "T1")
 			assertDeclaredMethodConflict("m")
 		]
	}

	@Test def void testRequiredMethodConflicts4() {
		'''
		trait T1 {
			String m(int i);
		}
		
		trait T2 {
			int n(boolean i);
		}
		
		trait T3 uses T1, T2 {
			int n(boolean i);
		}
 		'''.parse => [
 			assertMethodConflict("int n(boolean)", "T2")
 			assertDeclaredMethodConflict("n")
 		]
	}

	@Test def void testRequiredMethodConflicts5() {
		'''
		trait T1 {
			String m(int i);
		}
		
		trait T2 {
			int n(boolean i);
		}
		
		trait T3 uses T1, T2 {
			int n(boolean i);
			String m(int i);
		}
 		'''.parse => [
 			assertMethodConflict("int n(boolean)", "T2")
 			assertDeclaredMethodConflict("n")
 			assertMethodConflict("String m(int)", "T1")
 			assertDeclaredMethodConflict("m")
 		]
	}

	@Test def void testRequiredMethodConflictsWithDefinedMethod() {
		'''
		trait T1 {
			String m(int i) { return null; }
			String n(int i) { return null; }
		}
		
		trait T2 uses T1 {
			String m(int i);
			int n(boolean i);
		}
 		'''.parse => [
 			assertMethodConflict("String m(int)", "T1")
 			assertDeclaredMethodConflict("m")
 			
 			assertMethodConflict("String n(int)", "T1")
 			assertDeclaredMethodConflict("n")
 		]
	}

	@Test def void testDefinedMethodConflicts() {
		'''
		trait T1 {
			String m(int i) { return null; }
			String n(int i) { return null; }
		}
		
		trait T2 {
			int m(int i) { return 0; }
			String n(int i) { return null; }
		}
		
		trait T3 uses T1, T2 {}
 		'''.parse => [
 			assertMethodConflict("String m(int)", "T1")
 			assertMethodConflict("int m(int)", "T2")
 			
 			assertMethodConflict("String n(int)", "T1")
 			assertMethodConflict("String n(int)", "T2")
 		]
	}

	@Test def void testDefinedMethodConflicts2() {
		'''
		trait T1 {
			String m(int i) { return null; }
			String n(int i) { return null; }
		}
		
		trait T2 uses T1 {
			String m(int i) { return null; }
			int n(boolean i) { return 0; }
		}
 		'''.parse => [
 			assertMethodConflict("String m(int)", "T1")
 			assertDeclaredMethodConflict("m")
 			
 			assertMethodConflict("String n(int)", "T1")
 			assertDeclaredMethodConflict("n")
 		]
	}

	@Test def void testMethodConflictsWithRenaming() {
		'''
		trait T1 {
			String m(int i) { return null; }
			String n(int i) { return null; }
		}
		
		trait T2 {
			String n1(int i) { return null; }
		}
		
		trait T3 uses T1[rename m to m1, rename n to n1], T2 {
			String m1(int i) { return null; }
		}
 		'''.parse => [
 			assertMethodConflict("String m1(int)", "T1")
 			assertDeclaredMethodConflict("m1")
 			
 			assertMethodConflict("String n1(int)", "T1")
 			assertMethodConflict("String n1(int)", "T2")
 		]
	}

	@Test def void testMethodConflictsWithAlias() {
		'''
		trait T1 {
			String m(int i) { return null; }
			String n(int i) { return null; }
		}
		
		trait T2 {
			String n1(int i) { return null; }
		}
		
		trait T3 uses T1[alias m as m1], T2[alias n1 as n] {
			String m1(int i) { return null; }
		}
 		'''.parse => [
 			assertMethodConflict("String m1(int)", "T1")
 			assertDeclaredMethodConflict("m1")
 			
 			assertMethodConflict("String n(int)", "T1")
 			assertMethodConflict("String n(int)", "T2")
 		]
	}

	@Test def void testDuplicateDeclarations() {
		'''
		trait T {}
		trait T {}
		trait T1 {}
		class T1 {}
		'''.parse =>[
			assertDuplicateDeclaration("T", XtraitjPackage::eINSTANCE.TJTrait)
			assertDuplicateDeclaration("T1", XtraitjPackage::eINSTANCE.TJTrait)
			assertDuplicateDeclaration("T1", XtraitjPackage::eINSTANCE.TJClass)
		]
	}

	@Test def void testAlterationsToAlreadyExistingNames() {
		'''
		trait T1 {
			int m() { return 0; }
			int m1();
			
			int n();
			int n1();
		}
		
		trait T2 uses T1[alias m as m1, rename n to n1] {
			
		}
		'''.parse => [
			assertAlreadyExistingMember("m1", XtraitjPackage::eINSTANCE.TJAliasOperation)
			assertAlreadyExistingMember("n1", XtraitjPackage::eINSTANCE.TJRenameOperation)
		]
	}

	@Test def void testConstructorWithTheWrongName() {
		'''
		class C {
			D() {}
		}
		'''.parse.assertError(
			XtraitjPackage.eINSTANCE.TJConstructor,
			XtraitjValidator.WRONG_CONSTRUCTOR_NAME,
			"Wrong constructor name 'D'"
		)
	}

	@Test def void testDuplicateConstructors() {
		'''
		class C {
			C() {}
			C(int i) {}
			C() {}
		}
		'''.parse => [
			assertError(
				XtraitjPackage.eINSTANCE.TJConstructor,
				XtraitjValidator.DUPLICATE_CONSTRUCTOR,
				"Duplicate constructor 'C()'"
			)
			2.assertEquals(validate.size)
		]
	}

	@Test def void testDuplicateConstructors2() {
		'''
		class C {
			C(int j, String s) {}
			C(int i) {}
			C(int k, String s2) {}
		}
		'''.parse => [
			assertError(
				XtraitjPackage.eINSTANCE.TJConstructor,
				XtraitjValidator.DUPLICATE_CONSTRUCTOR,
				"Duplicate constructor 'C(int, String)'"
			)
			2.assertEquals(validate.size)
		]
	}

	@Test def void testTypeMismatchForTraitTypeParameters() {
		'''
		package tests;
		
		trait T1 <T, U> {
			T t;
			U u;
			
			void m() {
				val t1 = u // type mismatch
				t = t1
			}
		}
		'''.parse.assertErrorsAsStrings(
			'''Type mismatch: cannot convert from U to T'''
		)
	}

	@Test def void testClassMissingRequiredMethodWithGeneric() {
		'''
		trait TGeneric<T> {
			T required(T t);
		} 
		
		trait TUsesGeneric uses TGeneric<String> {
		}
		
		class CUsesGeneric uses TUsesGeneric {
		}
		'''.parse => [
			assertError(
				XtraitjPackage::eINSTANCE.TJClass,
				XtraitjValidator::MISSING_REQUIRED_METHOD,
				"Class must provide required method 'String required(String)'"
			)
		]
	}

	@Test def void testWrongReferenceToTypeParameter() {
		'''
		package tests;
				
		trait TFirst<T> {
			
		}
		
		trait T2 {
			T m() { return null; }
		}
		'''.parse.assertErrorsAsStrings(
			'''Cannot make a static reference to the non-static type T'''
		)
	}

	@Test def void testWrongInstantiationOfTypeParameter() {
		'''
		package tests;
				
		trait TFirst<T> {
			T m() { return new T; }
		}
		'''.parse.assertErrorsAsStrings(
			'''Cannot instantiate the type parameter T'''
		)
	}

	@Test def void testInvalidAnnotationOnTraitField() {
		'''
		package tests;
				
		trait T {
			@SuppressWarnings("all")
			String f;
		}
		'''.parse.assertError(
				XtraitjPackage.eINSTANCE.TJField,
				XtraitjValidator.ANNOTATION_ON_TRAIT_FIELD,
				"Traits cannot annotate fields"
			)
	}

	def private assertErrorsAsStrings(EObject o, CharSequence expected) {
		expected.toString.trim.assertEquals(
			o.validate.map[message].join("\n"))
	}

	def private assertMissingInterfaceMethod(EObject o, String methodRepr) {
		o.assertError(
			XtraitjPackage::eINSTANCE.TJClass,
			XtraitjValidator::MISSING_INTERFACE_METHOD,
			"Class must provide interface method '" + methodRepr + "'"
		)
	}

	def private assertDuplicateMember(EObject o, String memberName, EClass c) {
		o.assertError(
			c, XtraitjValidator::DUPLICATE_MEMBER,
			"Duplicate member '" + memberName + "'"
		)
	}

	def private assertDuplicateDeclaration(EObject o, String name, EClass c) {
		o.assertError(
			c, XtraitjValidator::DUPLICATE_DECLARATION,
			"Duplicate declaration '" + name + "'"
		)
	}

	def private assertFieldConflict(EObject o, String repr, String traitName) {
		o.assertError(XtraitjPackage::eINSTANCE.TJTraitReference,
			XtraitjValidator::FIELD_CONFLICT,
			"Field conflict '" + repr + "' in " + traitName
		)
	}

	def private assertDeclaredFieldConflict(EObject o, String repr) {
		o.assertError(XtraitjPackage::eINSTANCE.TJField,
			XtraitjValidator::FIELD_CONFLICT,
			"Field conflict '" + repr + "'"
		)
	}

	def private assertMethodConflict(EObject o, String repr, String traitName) {
		o.assertError(XtraitjPackage::eINSTANCE.TJTraitReference,
			XtraitjValidator::METHOD_CONFLICT,
			"Method conflict '" + repr + "' in " + traitName
		)
	}

	def private assertDeclaredMethodConflict(EObject o, String repr) {
		o.assertError(XtraitjPackage::eINSTANCE.TJMember,
			XtraitjValidator::METHOD_CONFLICT,
			"Method conflict '" + repr + "'"
		)
	}

	def private assertAlreadyExistingMember(EObject o, String memberName, EClass c) {
		o.assertError(
			c, XtraitjValidator::MEMBER_ALREADY_EXISTS,
			"Member already exists '" + memberName + "'"
		)
	}
}

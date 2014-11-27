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
import static extension xtraitj.tests.utils.XtraitjTestsUtils.*

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class TempXtraitjValidatorTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper









	@Test def void testClassMissingFieldWithCorrectTypeAfterRedirect() {
		'''
import java.util.List

trait T1<T> {
	List<T> s1;
	List<T> s2;
}

trait T2 uses T1<String> {
	String useField() { return s1.get(0); }
}

trait T3 uses T2[ redirect s1 to s2 ] {
}

class C uses T3 {
	String s2 = "s2";
}
		'''.parse => [
			assertMissingRequiredField('List<String> s2')
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

	@Test
	def void testClassDoesNotImplementAllInterfaceMethodsWithGenerics() {
		'''
		import xtraitj.input.tests.MyGenericTestInterface
		import java.util.ArrayList
		
		trait T1<T> {
			T m(T l) { return null; }
		}
		
		// required m(List<T>) provided m(ArrayList<T>)
		class C implements MyGenericTestInterface<String> uses T1<String> {}
		'''.parse => [
			assertMissingInterfaceMethod("int m(List<String>)")
		]
	}

	@Test
	def void testClassDoesNotImplementAllInterfaceMethodsWithGenerics2() {
		'''
		import xtraitj.input.tests.MyGenericTestInterface
		
		trait T1<T> {
			int m(T l) { return 0; }
		}
		
		// required m(List<T>) provided m(T)
		class C implements MyGenericTestInterface<String> uses T1<String> {}
		'''.parse => [
			assertMissingInterfaceMethod("int m(List<String>)")
		]
	}

	@Test
	def void testClassDoesNotImplementAllInterfaceMethodsWithGenerics3() {
		'''
		import xtraitj.input.tests.MyGenericTestInterface
		import java.util.ArrayList
		
		trait T1<T> {
			int m(ArrayList<T> l) { return 0; }
		}
		
		// required m(List<T>) provided m(ArrayList<T>)
		class C implements MyGenericTestInterface<String> uses T1<String> {}
		'''.parse => [
			assertMissingInterfaceMethod("int m(List<String>)")
		]
	}

	@Test
	def void testClassDoesNotImplementAllInterfaceMethodsWithGenerics4() {
		'''
		import xtraitj.input.tests.MyGenericTestInterface2
		
		trait T1<T> {
			T n(int i) { return null; }
		}
		
		// required List<T> n(int i) provided T n(int i)
		class C implements MyGenericTestInterface2<String> uses T1<String> {}
		'''.parse => [
			assertMissingInterfaceMethod("List<String> n(int)")
		]
	}

	@Test
	def void testClassDoesNotImplementAllInterfaceMethodsWithGenericsWithCovariantReturnType() {
		'''
		import xtraitj.input.tests.MyGenericTestInterface2
		import java.util.ArrayList
		
		trait T1<T> {
			ArrayList<T> n(int i) { return null; }
		}
		
		// required List<T> n(int i) provided ArrayList<T> n(int i)
		// OK: covariant return type
		class C implements MyGenericTestInterface2<String> uses T1<String> {}
		'''.parse => [
			assertNoErrors
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

	@Test def void testFieldConflictsWithGenerics() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> i;
		}
		
		trait T2 {
			List<String> i;
		}
		
		trait T3 uses T1<Integer>, T2 {
		}'''.parse => [
 			assertFieldConflict("List<Integer> i", "T1")
 			assertFieldConflict("List<String> i", "T2")
 		]
	}

	@Test def void testFieldConflictsWithGenerics2() {
		'''
		import java.util.List
		
		trait T1<T> {
			List<T> i;
		}
		
		trait T2 {
			List<String> i;
		}
		
		trait T3<U> uses T1<U>, T2 {
		}'''.parse => [
 			assertFieldConflict("List<U> i", "T1")
 			assertFieldConflict("List<String> i", "T2")
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

	@Test def void testMethodConflictsWithGenerics() {
		'''
import java.util.List

trait T1<T> {
	int i();
	List<T> m();
}

trait T2  {
	int i();
	List<String> m();
}

trait T3 uses T1<Integer>, T2 {
	
}
		'''.parse => [
 			assertMethodConflict("List<Integer> m()", "T1")
 			assertMethodConflict("List<String> m()", "T2")
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

	@Test def void testMethodConflictsWithAlias2() {
		'''
trait TFirst {
	String s() { return ""; }
}

trait T1 uses TFirst[alias s as s2] {
	
}

trait T2 uses T1[alias s as s2] {
	
}
 		'''.parse => [
 			assertAlreadyExistingMember("s2", XtraitjPackage::eINSTANCE.TJAliasOperation)
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











	def private assertErrorsAsStrings(EObject o, CharSequence expected) {
		expected.assertEqualsStrings(
			o.validate.map[message].join("\n"))
	}

	def private assertMissingInterfaceMethod(EObject o, String methodRepr) {
		o.assertError(
			XtraitjPackage::eINSTANCE.TJClass,
			XtraitjValidator::MISSING_INTERFACE_METHOD,
			"Class must provide interface method '" + methodRepr + "'"
		)
	}

	def private assertMissingRequiredField(EObject o, String fieldRepr) {
		o.assertError(
			XtraitjPackage::eINSTANCE.TJClass,
			XtraitjValidator::MISSING_REQUIRED_FIELD,
			"Class must provide required field '" + fieldRepr + "'"
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

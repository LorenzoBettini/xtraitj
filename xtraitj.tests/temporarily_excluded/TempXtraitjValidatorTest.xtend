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

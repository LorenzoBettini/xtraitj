package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.TypesPackage
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
import org.eclipse.xtext.xbase.validation.IssueCodes

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjValidatorTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper

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

	@Test def void testDuplicateParameters() {
		'''
		trait T {
			void req(String p1, int p2, int p1);
			void defined(String a1, int a2, int a1) { }
		}
		
		class C {
			C(String c1, int c2, int c1)
		}
		'''.parse =>[
			assertDuplicateParameter("p1", TypesPackage.eINSTANCE.jvmFormalParameter)
			assertDuplicateParameter("a1", TypesPackage.eINSTANCE.jvmFormalParameter)
			assertDuplicateParameter("c1", TypesPackage.eINSTANCE.jvmFormalParameter)
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

	@Test def void testDuplicateConstructorsErasedSignature() {
		'''
		import java.util.List
		
		class C {
			C(int j, List<String> s) {}
			C(int i) {}
			C(int k, List<Integer> s2) {}
		}
		'''.parse => [
			assertError(
				XtraitjPackage.eINSTANCE.TJConstructor,
				XtraitjValidator.DUPLICATE_CONSTRUCTOR,
				"Duplicate constructor 'C(int, List<Integer>)'"
			)
			2.assertEquals(validate.size)
		]
	}

	@Test def void testDuplicateConstructorsErasedSignature2() {
		'''
		import java.util.List
		
		class C<T> {
			C(int j, List<T> s) {}
			C(int i) {}
			C(int k, List<T> s2) {}
		}
		'''.parse => [
			assertError(
				XtraitjPackage.eINSTANCE.TJConstructor,
				XtraitjValidator.DUPLICATE_CONSTRUCTOR,
				"Duplicate constructor 'C(int, List<T>)'"
			)
			2.assertEquals(validate.size)
		]
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

	@Test def void testWrongReturnExpressionWithGenerics() {
		'''
package tests;

trait T1<T> {
	T f;
	
	String m() {
		return f;
	}
}
		'''.parse.assertErrorsAsStrings("Type mismatch: cannot convert from T to String")
	}

	@Test def void testWrongReturnExpressionWithGenerics2() {
		'''
package tests;

trait T1<T> {
	T f;
	
	String m() {
		val v = f;
		return v;
	}
}
		'''.parse.assertErrorsAsStrings("Type mismatch: cannot convert from T to String")
	}

	@Test def void testWrongReturnExpressionWithGenerics3() {
		'''
package tests;

trait T2<U> {
	U f;
}

trait T1<T> uses T2<T> {
	String m() {
		val v = f;
		return v;
	}
}
		'''.parse.assertErrorsAsStrings("Type mismatch: cannot convert from T to String")
	}

	@Test def void testWrongReturnExpressionWithGenerics4() {
		'''
package tests;

trait T3<U> {
	U f;
}

trait T2<V> uses T3<V> {

}

trait T1<T> uses T2<T> {
	String m() {
		val v = f;
		return v;
	}
}
		'''.parse.assertErrorsAsStrings("Type mismatch: cannot convert from T to String")
	}

	@Test def void testWrongReturnExpressionWithGenerics5() {
		'''
package tests;

trait T1<E1> {
	E1 fieldT1;
	E1 mT1() { return null; }
}

trait T2<G2> uses T1<G2> {
	G2 fieldT2;
	G2 mT2() { return null; }
}

trait T3<G3> uses T2<G3> {
	String meth() {
		println(fieldT1)
		val t1 = fieldT1
		fieldT1 = t1
		println(fieldT2)
		val t2 = fieldT2
		fieldT2 = t2
		return fieldT2; // + t2; // "foo" // t1 + t2;
	}
}

class C3<U> uses T3<U>{
	U fieldT1;
	U fieldT2;
}
		'''.parse.assertErrorsAsStrings("Type mismatch: cannot convert from G3 to String")
	}

	@Test def void testAccessToRenamedMethod() {
		'''
package tests;

import java.util.List
import java.util.LinkedList

trait TGeneric<T> {
	List<T> returnList() {
		return new LinkedList<T>
	}
	void printList(List<T> l) {}
}

trait UsesTGeneric uses 
	TGeneric<Integer>[rename returnList to returnListOfInteger, rename printList to printListOfInteger]
{
	String useLists() {
		val intList1 = returnList()
		val intList2 = returnListOfInteger()
		return (intList1.toString + intList2.toString)
	}
}
		'''.parse.assertErrorsAsStrings("The method returnList() is undefined")
	}

	@Test def void testAccessToRenamedField() {
		'''
package tests;

trait T {
	String f;
	boolean b;
}

trait UsesT uses 
	T[rename field f to g, rename field b to h]
{
	void useFields() {
		println(g)
		println(f)
		println(b)
		println(h)
		g = "foo"
		f = "bar"
		b = false
		h = false
	}
}
		'''.parse.assertErrorsAsStrings(
'''
Couldn't resolve reference to JvmIdentifiableElement 'f'.
Couldn't resolve reference to JvmIdentifiableElement 'b'.
The method f(String) is undefined
The method b(boolean) is undefined'''
)
	}

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

	@Test def void testWrongTypeArgument() {
		'''
trait T1<T> {
	
}

trait T2 uses T1 {
	
}
		'''.parse.assertWarning(
			TypesPackage.Literals.JVM_TYPE_REFERENCE,
			IssueCodes.RAW_TYPE,
			"T1 is a raw type. References to generic type T1<T> should be parameterized"
		)
	}

	@Test def void testWrongTypeArgument2() {
		'''
trait T1<T,V> {
	
}

trait T2 uses T1<String> {
	
}
		'''.parse.assertError(
			TypesPackage.Literals.JVM_TYPE_REFERENCE,
			IssueCodes.INVALID_NUMBER_OF_TYPE_ARGUMENTS,
			"Incorrect number of arguments for type T1<T, V>; it cannot be parameterized with arguments <String>"
		)
	}

	@Test def void testTypeArgumentCannotBeSubstitutedForBoundedType() {
		'''
trait T1<T extends Integer> {
	
}

trait T2 uses T1<String> {
	
}
		'''.parse.assertErrorsAsStrings(
			'''The type String is not a valid substitute for the bounded parameter T extends Integer'''
		)
	}

	@Test def void testUnresolvedTraitReference() {
		'''
trait T3<T,V> {
	
}

trait T2 uses T1<String> {
	
}
		'''.parse.assertErrorsAsStrings(
'''
Couldn't resolve reference to JvmType 'T1'.'''
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

	@Test def void testWrongReferenceToTypeParameter2() {
		'''
		package tests;
				
		trait T2 {
			T m() { return null; }
		}

		class TFirst<T> {
			
		}
		'''.parse.assertErrorsAsStrings(
			'''Cannot make a static reference to the non-static type T'''
		)
	}

	@Test def void testWrongReferenceToTypeParameter3() {
		'''
		package tests;
				
		trait T2<T> {
			T m() { return null; }
		}

		class TFirst {
			T f;
		}
		'''.parse.assertErrorsAsStrings(
			'''Cannot make a static reference to the non-static type T'''
		)
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

	@Test def void testClassMissingRequiredField() {
		'''
		trait T {
			String s;
		}
		
		class C uses T {}
		'''.parse => [
			assertMissingRequiredField('String s')
		]
	}

	@Test def void testClassMissingRequiredFields() {
		'''
		trait T {
			String s;
			int i;
		}
		
		class C uses T {}
		'''.parse => [
			assertMissingRequiredField('String s')
			assertMissingRequiredField('int i')
		]
	}

	@Test def void testClassMissingRequiredFieldsDoesNotShowSetters() {
		'''
		trait T {
			String s;
		}
		
		class C uses T {}
		'''.parse => [
			assertErrorsAsStrings(
"Class must provide required field 'String s'"
			)
		]
	}

	@Test def void testClassMismatchRequiredFieldsDoesNotShowSetters() {
		'''
		trait T {
			String s;
		}
		
		class C uses T {
			int s;
		}
		'''.parse => [
			assertErrorsAsStrings(
"Incompatible field 'int s' for required field 'String s'"
			)
		]
	}

	@Test def void testClassMissingRequiredFieldsWithSeveralTraits() {
		'''
		trait T1 {
			String s;
		}
		
		trait T2 {
			int i;
		}
		
		class C uses T1, T2 {}
		'''.parse => [
			assertMissingRequiredField('String s')
			assertMissingRequiredField('int i')
		]
	}

	@Test def void testClassMissingRequiredFieldsWithSeveralTraits2() {
		'''
		import java.util.List
		
		trait T1 {
			String s;
		}
		
		trait T2 {
			int i;
		}
		
		trait T3 uses T1 {
			boolean b;
		}
		
		trait T4 uses T2 {
			List<String> l;
		}
		
		class C uses T3, T4 {}
		'''.parse => [
			assertMissingRequiredField('String s')
			assertMissingRequiredField('int i')
			assertMissingRequiredField('boolean b')
			assertMissingRequiredField('List<String> l')
		]
	}

	@Test def void testClassMissingFieldWithCorrectTypeArgument() {
		'''
import java.util.List

trait T {
	List<Integer> integers;
}

class C uses T {
	List <String > integers ;
}
		'''.parse => [
			assertMismatchRequiredField('List<Integer> integers', 'List<String> integers')
		]
	}

	@Test def void testClassMismatchRequiredFieldsWithSubtyping() {
		'''
		import xtraitj.input.tests.MyBaseClass
		import xtraitj.input.tests.MyDerivedClass
		
		trait T {
			MyBaseClass f;
		}
		
		class C uses T {
			// although the getter would be fine,
			// the setter would be wrong
			MyDerivedClass f;
		}
		'''.parse => [
			assertErrorsAsStrings(
"Class must provide required field 'MyBaseClass f'"
			)
		]
	}

	@Test def void testClassMissingFieldInThePresenceOfTypeArguments() {
		'''
trait T {
	String s;
	List<String> strings;
}

trait T1 {
	int i;
}

class C uses T, T1 {
	String s ;
	List <String > strings ;
}
		'''.parse => [
			assertMissingRequiredField('int i')
		]
	}

	@Test def void testClassProvidesFieldAfterTypeArgumentInstantiation() {
		'''
import java.util.List

trait T<U> {
	List<U> r;
}

class C uses T<String> {
	List<String> r ;
}
		'''.parse => [
			assertNoErrors
		]
	}

	@Test def void testClassMissingFieldAfterTypeArgumentInstantiation() {
		'''
import java.util.List

trait T<U> {
	List<U> r;
}

class C uses T<String> {
}
		'''.parse => [
			assertMissingRequiredField('List<String> r')
		]
	}

	@Test def void testClassMissingFieldWithoutTypeArgumentInstantiation() {
		'''
import java.util.List

trait T<U> {
	List<U> r;
}

class C uses T {
}
		'''.parse => [
			assertMissingRequiredField('List r')
		]
	}

	@Test def void testClassMismatchFieldAfterTypeArgumentInstantiation() {
		'''
import java.util.List

trait T<U> {
	List<U> r;
}

class C uses T<String> {
	List<Integer> r ;
}
		'''.parse => [
			assertMismatchRequiredField('List<String> r', 'List<Integer> r')
		]
	}

	@Test def void testClassMismatchFieldWithCorrectTypeAfterRedirect() {
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
			assertErrorsAsStrings(
"Incompatible field 'String s2' for required field 'List<String> s2'"
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
			assertMissingRequiredMethod("String n(int)")
		]
	}

	def private assertErrorsAsStrings(EObject o, CharSequence expected) {
		expected.assertEqualsStrings(
			o.validate.map[message].join("\n"))
	}

	def private assertDuplicateMember(EObject o, String memberName, EClass c) {
		o.assertError(
			c, XtraitjValidator.DUPLICATE_MEMBER,
			"Duplicate member '" + memberName + "'"
		)
	}

	def private assertDuplicateDeclaration(EObject o, String name, EClass c) {
		o.assertError(
			c, XtraitjValidator.DUPLICATE_DECLARATION,
			"Duplicate declaration '" + name + "'"
		)
	}

	def private assertDuplicateParameter(EObject o, String name, EClass c) {
		o.assertError(
			c, XtraitjValidator.DUPLICATE_PARAM,
			"Duplicate parameter '" + name + "'"
		)
	}

	def private assertMissingRequiredField(EObject o, String fieldRepr) {
		o.assertError(
			XtraitjPackage.eINSTANCE.TJClass,
			XtraitjValidator.MISSING_REQUIRED_FIELD,
			"Class must provide required field '" + fieldRepr + "'"
		)
	}

	def private assertMismatchRequiredField(EObject o, String requiredRepr, String actualRepr) {
		o.assertError(
			XtraitjPackage.eINSTANCE.TJClass,
			XtraitjValidator.INCOMPATIBLE_REQUIRED_FIELD,
			"Incompatible field '" +
				actualRepr +
				"' for required field '" +
				requiredRepr + "'"
		)
	}

	def private assertMissingRequiredMethod(EObject o, String methodRepr) {
		o.assertError(
			XtraitjPackage.eINSTANCE.TJClass,
			XtraitjValidator.MISSING_REQUIRED_METHOD,
			"Class must provide required method '" + methodRepr + "'"
		)
	}
}

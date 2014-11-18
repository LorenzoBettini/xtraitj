package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EObject
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
}

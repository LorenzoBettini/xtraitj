package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.xtraitj.TJProgram

import static extension xtraitj.tests.utils.XtraitjTestsUtils.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjValidatorTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension ValidationTestHelper

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
		'''.parse.assertErrorsAsStrings("The method returnList() is not visible")
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
The method getF() is not visible
The method isB() is not visible
The method setF(String) is not visible
The method setB(boolean) is not visible'''
)
	}


	def private assertErrorsAsStrings(EObject o, CharSequence expected) {
		expected.assertEqualsStrings(
			o.validate.map[message].join("\n"))
	}


}

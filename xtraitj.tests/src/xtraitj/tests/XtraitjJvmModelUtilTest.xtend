package xtraitj.tests

import com.google.inject.Inject
import java.util.List
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjInjectorProvider
import xtraitj.input.tests.XtraitjInputs
import xtraitj.jvmmodel.XtraitjJvmModelHelper
import xtraitj.jvmmodel.XtraitjJvmModelUtil
import xtraitj.xtraitj.TJDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJTrait

import static extension org.junit.Assert.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjJvmModelUtilTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension XtraitjInputs
	@Inject extension XtraitjJvmModelUtil
	@Inject extension IJvmModelAssociations
	@Inject extension XtraitjJvmModelHelper

	@Test def void testFieldRepresentation() {
		traitDependency.associatedResolvedOperations => [
			resolvedOperationByName("getF1").assertFieldRepresentation("Object f1")
			resolvedOperationByName("getF3").assertFieldRepresentation("Object f3")
		]
	}

	@Test def void testMethodRepresentation() {
		'''
		import java.util.List
		import java.util.Set
		
		trait T {
			int m(List<String> l, Object o);
			Set<? extends String> n() { return null; }
		}
		'''.associatedResolvedOperations => [
			resolvedOperationByName("n").assertMethodRepresentation("Set<? extends String> n()")
			resolvedOperationByName("m").assertMethodRepresentation("int m(List<String>, Object)")
		]
	}

	@Test def void testStripGetter() {
		"".assertEquals(null.stripGetter)
		"foo".assertEquals("foo".stripGetter)
		"foo".assertEquals("getFoo".stripGetter)
		"foo".assertEquals("isFoo".stripGetter)
		"get".assertEquals("get".stripGetter)
		"is".assertEquals("is".stripGetter)
	}

	@Test def void testRenameGetterOrSetter() {
		"".assertEquals(null.renameGetterOrSetter("bar"))
		"getBar".assertEquals("getFoo".renameGetterOrSetter("bar"))
		"setBar".assertEquals("setFoo".renameGetterOrSetter("bar"))
		"isBar".assertEquals("isFoo".renameGetterOrSetter("bar"))
		"bar".assertEquals("get".renameGetterOrSetter("bar"))
		"bar".assertEquals("set".renameGetterOrSetter("bar"))
		"bar".assertEquals("is".renameGetterOrSetter("bar"))
	}


	@Test def void testCompliantWhenSameSignature() {
		assertCompliant("int m(List<String> l)", "int n(List<String> l)", true)
	}

	@Test def void testCompliantWhenCovariantReturnType() {
		assertCompliant("MyDerivedClass m(List<String> l)", "MyBaseClass n(List<String> l)", true)
	}

	@Test def void testCompliantWhenCovariantReturnTypeGenericType() {
		assertCompliant("ArrayList<String> m(List<String> l)", "List<String> n(List<String> l)", true)
	}

	@Test def void testNotCompliantWhenCovariantReturnTypeGenericTypeWithWildcard() {
		assertCompliant("List<? extends String> m(List<String> l)", "List<String> n(List<String> l)", false)
	}

	@Test def void testNotCompliantWhenCovariantReturnTypeGenericTypeWithWildcard2() {
		assertCompliant("List<? super String> m(List<String> l)", "List<String> n(List<String> l)", false)
	}

	@Test def void testNotCompliantWhenContravariantReturnTypeGenericType() {
		assertCompliant("List<String> m(List<String> l)", "ArrayList<String> n(List<String> l)", false)
	}

	@Test def void testNotCompliantWhenDifferentReturnType() {
		assertCompliant("String m(List<String> l)", "int n(List<String> l)", false)
	}

	@Test def void testNotCompliantWhenDifferentParametersSize() {
		assertCompliant("int m(List<String> l, List<String> l2)", "int n(List<String> l)", false)
	}

	@Test def void testNotCompliantWhenParamIsSubtype() {
		assertCompliant("int m(MyBaseClass p)", "int n(MyDerivedClass p)", false)
	}

	@Test def void testExactWhenSameSignature() {
		assertExact("int m(List<String> l)", "int n(List<String> l)", true)
	}

	@Test def void testNotExactWhenCovariantReturnType() {
		assertExact("MyDerivedClass m()", "MyBaseClass n()", false)
	}

	@Test def void testFindOperationByNameWithMethod() {
		'''
		trait T {
			String n(int i);
			String p(int i);
			String m(int i);
		}
		'''.assertFindOperationByName("m", "String m(int)")
	}

	@Test def void testFindOperationByNameWithField() {
		'''
		trait T {
			String n;
			String p;
			String m;
		}
		'''.assertFindOperationByName("getM", "String getM()")
	}

	def private assertFieldRepresentation(IResolvedOperation o, String expected) {
		expected.assertEquals(o.fieldRepresentation)
	}

	def private assertMethodRepresentation(IResolvedOperation o, String expected) {
		expected.assertEquals(o.methodRepresentation)
	}

	def private resolvedOperationByName(List<IResolvedOperation> ops, String name) {
		ops.findFirst[declaration.simpleName == name]
	}

	def private associatedResolvedOperations(CharSequence input) {
		input.parse.associatedResolvedOperations
	}

	def private assertCompliant(String o1Desc, String o2Desc, boolean expected) {
		configurableAssertForResolvedOperations(o1Desc, o2Desc)
		[
			o1, o2 |
			assertCompliant(o1, o2, expected)
		]
	}

	def private assertExact(String o1Desc, String o2Desc, boolean expected) {
		configurableAssertForResolvedOperations(o1Desc, o2Desc)
		[
			o1, o2 |
			assertExact(o1, o2, expected)
		]
	}

	def private configurableAssertForResolvedOperations(String o1Desc, String o2Desc, 
		(IResolvedOperation, IResolvedOperation) => void acceptor
	) {
		'''
		import java.util.*
		import xtraitj.input.tests.MyBaseClass
		import xtraitj.input.tests.MyDerivedClass
		
		trait T {
			«o1Desc»;
			«o2Desc»;
		}
		'''.associatedResolvedOperations => [
			acceptor.apply(get(0), get(1))
		]
	}

	def private assertCompliant(IResolvedOperation o1, IResolvedOperation o2, boolean expected) {
		val result = o1.compliant(o2)
		assertEquals(o1.headerRepresentation + " compliant to " + o2.headerRepresentation,
			expected, result)
	}

	def private assertExact(IResolvedOperation o1, IResolvedOperation o2, boolean expected) {
		val result = o1.exact(o2)
		assertEquals(o1.headerRepresentation + " exact " + o2.headerRepresentation,
			expected, result)
	}

	def private headerRepresentation(IResolvedOperation m) {
		m.resolvedReturnType.simpleName + " " + 
			m.resolvedParameterTypes.map[simpleName].join(", ")
	}

	def private assertFindOperationByName(CharSequence input, String toFindName, String expectedRepr) {
		val ops = input.associatedResolvedOperations
		val toFind = ops.findFirst[op | op.declaration.simpleName == toFindName ]
		assertNotNull("not found: ", toFind)
		val found = ops.findOperationByName(toFind)
		expectedRepr.assertEquals(found.methodRepresentation)
	}

	/**
	 * Retrieves all the JvmOperations associated to (Java interface inferred for) the first 
	 * trait in the program
	 */
	private def associatedResolvedOperations(TJProgram it) {
		val TJDeclaration programElement = elements.filter(TJTrait).head
		programElement.jvmElements.filter(JvmGenericType).filter[isInterface].
				head.resolvedOperations.allOperations
	}
}
package xtraitj.tests

import com.google.inject.Inject
import java.util.List
import org.eclipse.xtext.common.types.JvmGenericType
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
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
	@Inject extension ValidationTestHelper
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

//	@Test def void testCompliant() {
//		'''
//		import java.util.List
//		
//		trait T {
//			int m(List<String> l) { return 0; }
//			int n(List<String> l) { return 0; }
//			int o(List<String> l, int j) { return 0; }
//			boolean p(List<String> l) { return false; }
//			int q(List<Integer> l) { return 0; }
//			int r(List<? extends String> l) { return 0; }
//		}
//		'''.parse.traits.head.jvmAllOperations => [
//			get(0).assertCompliant(get(0), true)
//			get(1).assertCompliant(get(0), true)
//			get(2).assertCompliant(get(0), false)
//			get(3).assertCompliant(get(0), false)
//			get(4).assertCompliant(get(0), false)
//			get(5).assertCompliant(get(0), false)
//		]
//	}
//

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

	/**
	 * Retrieves all the JvmOperations associated to (Java interface inferred for) the first 
	 * trait in the program
	 */
	private def associatedResolvedOperations(TJProgram it) {
		assertNoErrors
		val TJDeclaration programElement = elements.filter(TJTrait).head
		programElement.jvmElements.filter(JvmGenericType).filter[isInterface].
				head.resolvedOperations.allOperations
	}
}
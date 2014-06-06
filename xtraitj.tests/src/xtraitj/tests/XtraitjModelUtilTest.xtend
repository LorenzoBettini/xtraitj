package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.xtraitj.TJField
import xtraitj.xtraitj.TJMethodDeclaration
import xtraitj.xtraitj.TJProgram
import xtraitj.xtraitj.TJTraitExpression

import static extension org.junit.Assert.*
import static extension xtraitj.util.TraitJModelUtil.*
import xtraitj.XtraitjInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjModelUtilTest {
	@Inject extension ParseHelper<TJProgram>

	@Test def void testMethodsForAtomicTraitExpression() {
		'''
		trait T uses T1 {}
		trait T1 {
			Object m() { return null; }
		}
		'''.parse.traits.head.traitExpression.assertMethods("m")
	}

	@Test def void testFieldRepresentationWithTypes() {
		'''
		import java.util.List
		import java.util.Set
		
		class C {
			Object o;
			List<String> l;
			int m(List<String> l, Object o);
			Set<? extends String> n() { return null; }
		}
		'''.parse.classes.head.fields => [
			get(0).assertRepresentation("Object o")
			get(1).assertRepresentation("List<String> l")
		]
	}

	@Test def void testMethodRepresentationWithTypes() {
		'''
		import java.util.List
		import java.util.Set
		
		trait T {
			int m(List<String> l, Object o);
			Set<? extends String> n() { return null; }
		}
		'''.parse.traits.head => [
			requiredMethods.head.assertRepresentation("int m(List<String>, Object)")
			methods.head.assertRepresentation("Set<? extends String> n()")
		]
	}

	def private assertMethods(TJTraitExpression e, String expected) {
		1.assertEquals(e.references.size)
		expected.assertEquals
			(e.references.head.methods.map[name].join(","))
	}

	def private assertRepresentation(TJField f, String expected) {
		expected.assertEquals(f.representationWithTypes)
	}

	def private assertRepresentation(TJMethodDeclaration m, String expected) {
		expected.assertEquals(m.representationWithTypes)
	}
}
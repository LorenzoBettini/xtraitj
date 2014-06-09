package xtraitj.tests

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.xtraitj.TJMember
import xtraitj.xtraitj.TJProgram

import static org.junit.Assert.*

import xtraitj.XtraitjInjectorProvider
import xtraitj.typing.XtraitjTypingUtil
import static extension xtraitj.util.XtraitjModelUtil.*

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjInjectorProvider))
class XtraitjTypingUtilTest {
	@Inject extension ParseHelper<TJProgram>
	@Inject extension XtraitjTypingUtil

	@Test def void testSameType() {
		'''
		import java.util.List
		
		class C {
			Object o1;
			Object o2;
			String s1;
			List<String> ls1;
			List<String> ls2;
			List<? extends String> ls3;
		}
		'''.parse.classes.head.fields => [
			get(0).assertSameType(get(1), true)
			get(0).assertSameType(get(2), false)
			get(3).assertSameType(get(4), true)
			get(3).assertSameType(get(5), false)
		]
	}

	@Test def void testSubtype() {
		'''
		import java.util.List
		import java.util.ArrayList
		
		class C {
			Object o1; 				// 0
			Object o2;				// 1
			String s1;				// 2
			List<String> ls1;		// 3
			List<String> ls2;		// 4
			List<? extends String> ls3; // 5
			ArrayList<? extends String> ls4; // 6
		}
		'''.parse.classes.head.fields => [
			// Object <; Object
			get(0).assertSubtype(get(1), true)
			// Object NOT <: List
			get(0).assertSubtype(get(2), false)
			// List <: Object
			get(3).assertSubtype(get(1), true)
			// List<String> <: List<String>
			get(3).assertSubtype(get(4), true)
			// List<? extends String> NOT <: List<String>
			get(5).assertSubtype(get(3), false)
			// List<String> <: List<? extends String>
			get(3).assertSubtype(get(5), true)
			// ArrayList<? extends String> <: List<? extends String>
			get(6).assertSubtype(get(5), true)
		]
	}

	@Test def void testSameTypeWithBasicTypes() {
		'''
		class C {
			int i1;
			Integer i2;
			int i3;
			Integer i4;
		}
		'''.parse.classes.head.fields => [
			get(0).assertSameType(get(1), false)
			get(1).assertSameType(get(0), false)
			get(0).assertSameType(get(2), true)
			get(1).assertSameType(get(3), true)
		]
	}

	@Test def void testSubtypeWithBasicTypes() {
		'''
		class C {
			int i1;
			Integer i2;
			int i3;
			Integer i4;
		}
		'''.parse.classes.head.fields => [
			get(0).assertSubtype(get(1), false)
			get(1).assertSubtype(get(0), false)
			get(0).assertSubtype(get(2), true)
			get(1).assertSubtype(get(3), true)
		]
	}

	def private assertSameType(TJMember m1, TJMember m2, boolean mustBeTheSame) {
		val t1 = m1.type
		val t2 = m2.type
		assertEquals(
			'''failed expected: «mustBeTheSame» - «t1.simpleName», «t2.simpleName»''',
			mustBeTheSame, m1.sameType(t1, t2)
		)
	}

	def private assertSubtype(TJMember m1, TJMember m2, boolean mustBeSubtype) {
		val t1 = m1.type
		val t2 = m2.type
		assertEquals(
			'''failed expected: «mustBeSubtype» - «t1.simpleName» <: «t2.simpleName»''',
			mustBeSubtype, m1.isSubtype(t1, t2)
		)
	}
}
package xtraitj.ui.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.junit.ui.AbstractContentAssistTest
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.XtraitjUiInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(XtraitjUiInjectorProvider))
class TraitJContentAssistTest extends AbstractContentAssistTest {

	val T = '''
		trait T {
			String s;
			Object m() { return null; }
		}
		'''

	@Test
	def void testRenameMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[rename '''
		).assertText('m', 's')
	}

	@Test
	def void testHideMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[hide '''
		).assertText('m')
	}

	@Test
	def void testAliasMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[alias '''
		).assertText('m')
	}

	@Test
	def void testRestrictMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[restrict '''
		).assertText('m')
	}

	@Test
	def void testPrivateMethod() {
		newBuilder.append(
		'''
		trait T {
			private String m() { null; }
			String n() { null; }
		}
		
		trait T1 uses T[rename '''
		).assertText('n')
	}

	@Test
	def void testRedirectMembers() {
		newBuilder.append(
		T + '''
		trait T1 uses T[redirect '''
		).assertText('m', 's')
		.append(" m to ").assertText('m', 's')
	}

	@Test
	def void testImplementsInterface() {
		newBuilder.append(
		'''
		import java.util.List
		
		class C implements Lis'''
		).assertProposal('List')
	}

	@Test
	def void testImplementsNotClass() {
		newBuilder.append(
		'''
		import java.util.LinkedList
		
		class C implements LinkedL'''
		).assertText()
	}

}
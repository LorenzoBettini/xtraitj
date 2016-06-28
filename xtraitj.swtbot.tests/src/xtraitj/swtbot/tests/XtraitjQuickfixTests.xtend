package xtraitj.swtbot.tests;

import org.eclipse.swtbot.eclipse.finder.widgets.SWTBotEclipseEditor
import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner
import org.junit.Test
import org.junit.runner.RunWith

import static extension xtraitj.tests.utils.XtraitjTestsUtils.*

@RunWith(typeof(SWTBotJunit4ClassRunner))
class XtraitjQuickfixTests extends XtraitjSwtbotAbstractTests {

	@Test
	def void testQuickfixForMissingField() {
		createProject(PROJECT_TYPE);
		val editor = updateEditorContents(
		'''
		package my.traits;
		
		trait T {
			String s;
		}
		
		class C uses T {
		}
		'''
		).toTextEditor
		
		//1.assertEquals(editor.quickFixes.size)
		
		editor.selectRange(6, 13, 1)
		
		editor.quickfixCustom
		
		editor.saveAndWaitForAutoBuild
		
		'''
		package my.traits;
		
		trait T {
			String s;
		}
		
		class C uses T {
		String s ;
		}
		
		'''.toString.
		assertEqualsStrings(editor.text)
		
	}

	@Test
	def void testQuickfixForMissingFieldWithGeneric() {
		createProject(PROJECT_TYPE);
		val editor = updateEditorContents(
		'''
		package my.traits;
		
		trait T<Type> {
			Type s;
		}
		
		class C uses T<Integer> {
		}
		'''
		).toTextEditor
		
		//1.assertEquals(editor.quickFixes.size)
		
		editor.selectRange(6, 13, 1)
		
		editor.quickfixCustom
		
		editor.saveAndWaitForAutoBuild
		
		'''
		package my.traits;
		
		trait T<Type> {
			Type s;
		}
		
		class C uses T<Integer> {
		Integer s ;
		}
		
		'''.toString.
		assertEqualsStrings(editor.text)
		
	}

	@Test
	def void testQuickfixForMissingFieldAfterRenaming() {
		createProject(PROJECT_TYPE);
		// in this test it seems that we need to update the editor contents
		// twice otherwise the error marker and the quickfix don't appear
		// it must be a problem with the workbench in the case of SWTBot tests
		updateEditorContents(
		'''
		package my.traits;
		
		trait T<Type> {
			Type s;
		}
		
		class C uses T<Integer>[rename field s to s1] {
		}
		'''
		)
		val editor = updateEditorContents(
		'''
		package my.traits;
		
		trait T<Type> {
			Type s;
		}
		
		class C uses T<Integer>[rename field s to s1] {
		}
		'''
		).toTextEditor
		
		//1.assertEquals(editor.quickFixes.size)
		
		editor.selectRange(6, 13, 10)
		
		editor.quickfixCustom
		
		editor.saveAndWaitForAutoBuild
		
		'''
		package my.traits;
		
		trait T<Type> {
			Type s;
		}
		
		class C uses T<Integer>[rename field s to s1] {
		Integer s1 ;
		}
		
		'''.toString.
		assertEqualsStrings(editor.text)
		
	}

	def private quickfixCustom(SWTBotEclipseEditor editor) {
		editor.quickfix(0)
	}

}
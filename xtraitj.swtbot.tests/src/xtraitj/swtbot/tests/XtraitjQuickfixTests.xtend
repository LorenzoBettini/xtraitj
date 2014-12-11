package xtraitj.swtbot.tests;

import org.eclipse.swtbot.eclipse.finder.widgets.SWTBotEclipseEditor
import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner
import org.junit.Test
import org.junit.runner.RunWith
import xtraitj.swtbot.tests.utils.SWTBotEclipseEditorCustom

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

	def private quickfixCustom(SWTBotEclipseEditor editor) {
		new SWTBotEclipseEditorCustom(editor.reference, bot).quickfix(0)
	}

}
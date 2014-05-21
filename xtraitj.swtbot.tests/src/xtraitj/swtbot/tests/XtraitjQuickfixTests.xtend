package xtraitj.swtbot.tests;

import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(SWTBotJunit4ClassRunner))
class XtraitjQuickfixTests extends XtraitjSwtbotAbstractTests {

	@Test
	def void testQuickfixForMissingField() {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
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
		
		editor.quickfix(0)
		
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
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
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
		
		editor.quickfix(0)
		
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


}
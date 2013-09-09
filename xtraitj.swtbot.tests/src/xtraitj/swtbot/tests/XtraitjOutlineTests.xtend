package xtraitj.swtbot.tests;

import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(SWTBotJunit4ClassRunner))
class XtraitjOutlineTests extends XtraitjSwtbotAbstractTests {

	@Test
	def void testOutline() {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
		outlineTraitNode("T").expand => [
			getNode("s : String")
			getNode("m() : String")
		]
		outlineClassNode("C").expand => [
			getNode("T")
			getNode("s : String")
			getNode("requirements").expand.getNode("s : String")
		]
	}

	@Test
	def void testOutlineForRequirements() {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
		updateEditorContents(
		'''
		package my.traits;
		
		trait T1 {
			String s;
			int m(String a);
		}
		
		trait T2 uses T1 {
			
		}
		'''
		)
		outlineTraitNode("T2").expand => [
			getNode("T1")
			getNode("requirements").expand => [
				getNode("s : String")
				getNode("m(String) : int")
			]
		]
	}

	@Test
	def void testOutlineForProvides() {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
		updateEditorContents(
		'''
		package my.traits;
		
		trait T1 {
			String s;
			int m(String a) { return 0; }
		}
		
		trait T2 uses T1 {
			String n(int i) { return ""; }
		}
		
		trait T3 uses T2 {
			
		}
		
		class C uses T3 {
			String s;
		}
		'''
		)
		outlineTraitNode("T3").expand => [
			getNode("T2")
			getNode("provides").expand => [
				getNode("m(String) : int")
				getNode("n(int) : String")
			]
		]
		outlineClassNode("C").expand => [
			getNode("T3")
			getNode("provides").expand => [
				getNode("m(String) : int")
				getNode("n(int) : String")
			]
		]
	}


	@Test
	def void testOutlineForConstructors() {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
		updateEditorContents(
		'''
		package my.traits;
		
		class C {
			String s;
			C() {}
			C(int i, String s) {}
		}
		'''
		)
		outlineTraitNode("C").expand => [
			getNode("C()")
			getNode("C(int, String)")
		]
	}

}
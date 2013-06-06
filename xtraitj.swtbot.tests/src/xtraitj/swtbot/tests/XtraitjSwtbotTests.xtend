package xtraitj.swtbot.tests;

import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(SWTBotJunit4ClassRunner))
class XtraitjSwtbotTests extends XtraitjSwtbotAbstractTests {

	@Test
	def void canCreateANewXtraitjProject() {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
	}
	
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

}
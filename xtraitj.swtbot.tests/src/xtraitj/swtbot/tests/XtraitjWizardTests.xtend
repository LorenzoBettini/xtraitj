package xtraitj.swtbot.tests;

import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(SWTBotJunit4ClassRunner))
class XtraitjWizardTests extends XtraitjSwtbotAbstractTests {

	@Test
	def void canCreateANewXtraitjProject() {
		createProjectAndAssertNoErrorMarker(PROJECT_TYPE);
	}

}
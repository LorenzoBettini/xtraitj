package xtraitj.swtbot.tests;

import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(SWTBotJunit4ClassRunner))
class XtraitjImportExampleWizardTests extends XtraitjSwtbotAbstractTests {

	@Test
	def void canImportXtraitjExample() {
		importExampleProjectAndAssertNoErrorMarker(
			"Some Xtraitj Examples", "xtraitj.example.examples");
	}

}
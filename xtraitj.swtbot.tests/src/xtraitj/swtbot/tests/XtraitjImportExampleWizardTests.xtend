package xtraitj.swtbot.tests;

import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(typeof(SWTBotJunit4ClassRunner))
class XtraitjImportExampleWizardTests extends XtraitjSwtbotAbstractTests {

	@Test
	def void canImportXtraitjExample() {
		// simulates the import of examples in a clean workbench.
		// apparently .trace files are not generated in this case
		importExampleProjectAndAssertNoErrorMarker(
			"Some Xtraitj Examples", "xtraitj.example.examples");
	}

	@Test
	def void canImportXtraitjExample2() {
		// simulates the import of examples in a workbench where we
		// already compiled a Plug-in project.
		importExampleProjectAndAssertNoErrorMarker(
			"Some Xtraitj Examples", "xtraitj.example.examples");
	}

}
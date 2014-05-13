package xtraitj.swtbot.tests;

import org.junit.BeforeClass;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

/**
 * This is intended to be run during the Tycho build.
 * 
 * @author Lorenzo Bettini
 *
 */
@RunWith(Suite.class)
@SuiteClasses({
	XtraitjQuickfixTests.class,
	XtraitjImportExampleWizardTests.class,
	XtraitjNewProjectWizardTests.class
})
public class AllSWTBotTests {
	
	@BeforeClass
	public static void setUp() throws Exception {
		//if (System.getProperty("buildingWithTycho") != null) {
			System.err.println("Generating a target platform");
			Utils.setTargetPlatform();
		//}
	}
}

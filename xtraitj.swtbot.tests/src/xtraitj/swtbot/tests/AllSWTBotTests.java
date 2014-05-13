package xtraitj.swtbot.tests;

import org.junit.BeforeClass;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({
	XtraitjQuickfixTests.class
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

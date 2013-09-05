package xtraitj.swtbot.tests;

import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.swtbot.tests.XtraitjSwtbotAbstractTests;

@RunWith(SWTBotJunit4ClassRunner.class)
@SuppressWarnings("all")
public class XtraitjWizardTests extends XtraitjSwtbotAbstractTests {
  @Test
  public void canCreateANewXtraitjProject() {
    try {
      this.createProjectAndAssertNoErrorMarker(XtraitjSwtbotAbstractTests.PROJECT_TYPE);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}

package xtraitj.swtbot.tests;

import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotTreeItem;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.swtbot.tests.XtraitjSwtbotAbstractTests;

@RunWith(SWTBotJunit4ClassRunner.class)
@SuppressWarnings("all")
public class XtraitjSwtbotTests extends XtraitjSwtbotAbstractTests {
  @Test
  public void canCreateANewXtraitjProject() {
    try {
      this.createProjectAndAssertNoErrorMarker(XtraitjSwtbotAbstractTests.PROJECT_TYPE);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testOutline() {
    try {
      this.createProjectAndAssertNoErrorMarker(XtraitjSwtbotAbstractTests.PROJECT_TYPE);
      SWTBotTreeItem _outlineTraitNode = this.outlineTraitNode("T");
      SWTBotTreeItem _expand = _outlineTraitNode.expand();
      final Procedure1<SWTBotTreeItem> _function = new Procedure1<SWTBotTreeItem>() {
          public void apply(final SWTBotTreeItem it) {
            it.getNode("s : String");
            it.getNode("m() : String");
          }
        };
      ObjectExtensions.<SWTBotTreeItem>operator_doubleArrow(_expand, _function);
      SWTBotTreeItem _outlineClassNode = this.outlineClassNode("C");
      SWTBotTreeItem _expand_1 = _outlineClassNode.expand();
      final Procedure1<SWTBotTreeItem> _function_1 = new Procedure1<SWTBotTreeItem>() {
          public void apply(final SWTBotTreeItem it) {
            it.getNode("T");
            it.getNode("s : String");
            SWTBotTreeItem _node = it.getNode("requirements");
            SWTBotTreeItem _expand = _node.expand();
            _expand.getNode("s : String");
          }
        };
      ObjectExtensions.<SWTBotTreeItem>operator_doubleArrow(_expand_1, _function_1);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}

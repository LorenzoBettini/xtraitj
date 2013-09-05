package xtraitj.swtbot.tests;

import org.eclipse.swtbot.eclipse.finder.widgets.SWTBotEclipseEditor;
import org.eclipse.swtbot.eclipse.finder.widgets.SWTBotEditor;
import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.swtbot.tests.XtraitjSwtbotAbstractTests;

@RunWith(SWTBotJunit4ClassRunner.class)
@SuppressWarnings("all")
public class XtraitjQuickfixTests extends XtraitjSwtbotAbstractTests {
  @Test
  public void testQuickfixForMissingField() {
    try {
      this.createProjectAndAssertNoErrorMarker(XtraitjSwtbotAbstractTests.PROJECT_TYPE);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("package my.traits;");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C uses T {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      SWTBotEditor _updateEditorContents = this.updateEditorContents(_builder);
      final SWTBotEclipseEditor editor = _updateEditorContents.toTextEditor();
      editor.selectRange(6, 13, 1);
      editor.quickfix(0);
      this.saveAndWaitForAutoBuild(editor);
      StringConcatenation _builder_1 = new StringConcatenation();
      _builder_1.append("package my.traits;");
      _builder_1.newLine();
      _builder_1.newLine();
      _builder_1.append("trait T {");
      _builder_1.newLine();
      _builder_1.append("\t");
      _builder_1.append("String s;");
      _builder_1.newLine();
      _builder_1.append("}");
      _builder_1.newLine();
      _builder_1.newLine();
      _builder_1.append("class C uses T { String s ; }");
      _builder_1.newLine();
      String _string = _builder_1.toString();
      String _text = editor.getText();
      Assert.assertEquals(_string, _text);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}

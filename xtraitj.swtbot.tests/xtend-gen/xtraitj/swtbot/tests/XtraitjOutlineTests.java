package xtraitj.swtbot.tests;

import org.eclipse.swtbot.swt.finder.junit.SWTBotJunit4ClassRunner;
import org.eclipse.swtbot.swt.finder.widgets.SWTBotTreeItem;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.swtbot.tests.XtraitjSwtbotAbstractTests;

@RunWith(SWTBotJunit4ClassRunner.class)
@SuppressWarnings("all")
public class XtraitjOutlineTests extends XtraitjSwtbotAbstractTests {
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
  
  @Test
  public void testOutlineForRequirements() {
    try {
      this.createProjectAndAssertNoErrorMarker(XtraitjSwtbotAbstractTests.PROJECT_TYPE);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("package my.traits;");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m(String a);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      this.updateEditorContents(_builder);
      SWTBotTreeItem _outlineTraitNode = this.outlineTraitNode("T2");
      SWTBotTreeItem _expand = _outlineTraitNode.expand();
      final Procedure1<SWTBotTreeItem> _function = new Procedure1<SWTBotTreeItem>() {
        public void apply(final SWTBotTreeItem it) {
          it.getNode("T1");
          SWTBotTreeItem _node = it.getNode("requirements");
          SWTBotTreeItem _expand = _node.expand();
          final Procedure1<SWTBotTreeItem> _function = new Procedure1<SWTBotTreeItem>() {
            public void apply(final SWTBotTreeItem it) {
              it.getNode("s : String");
              it.getNode("m(String) : int");
            }
          };
          ObjectExtensions.<SWTBotTreeItem>operator_doubleArrow(_expand, _function);
        }
      };
      ObjectExtensions.<SWTBotTreeItem>operator_doubleArrow(_expand, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testOutlineForProvides() {
    try {
      this.createProjectAndAssertNoErrorMarker(XtraitjSwtbotAbstractTests.PROJECT_TYPE);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("package my.traits;");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m(String a) { return 0; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i) { return \"\"; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C uses T3 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      this.updateEditorContents(_builder);
      SWTBotTreeItem _outlineTraitNode = this.outlineTraitNode("T3");
      SWTBotTreeItem _expand = _outlineTraitNode.expand();
      final Procedure1<SWTBotTreeItem> _function = new Procedure1<SWTBotTreeItem>() {
        public void apply(final SWTBotTreeItem it) {
          it.getNode("T2");
          SWTBotTreeItem _node = it.getNode("provides");
          SWTBotTreeItem _expand = _node.expand();
          final Procedure1<SWTBotTreeItem> _function = new Procedure1<SWTBotTreeItem>() {
            public void apply(final SWTBotTreeItem it) {
              it.getNode("m(String) : int");
              it.getNode("n(int) : String");
            }
          };
          ObjectExtensions.<SWTBotTreeItem>operator_doubleArrow(_expand, _function);
        }
      };
      ObjectExtensions.<SWTBotTreeItem>operator_doubleArrow(_expand, _function);
      SWTBotTreeItem _outlineClassNode = this.outlineClassNode("C");
      SWTBotTreeItem _expand_1 = _outlineClassNode.expand();
      final Procedure1<SWTBotTreeItem> _function_1 = new Procedure1<SWTBotTreeItem>() {
        public void apply(final SWTBotTreeItem it) {
          it.getNode("T3");
          SWTBotTreeItem _node = it.getNode("provides");
          SWTBotTreeItem _expand = _node.expand();
          final Procedure1<SWTBotTreeItem> _function = new Procedure1<SWTBotTreeItem>() {
            public void apply(final SWTBotTreeItem it) {
              it.getNode("m(String) : int");
              it.getNode("n(int) : String");
            }
          };
          ObjectExtensions.<SWTBotTreeItem>operator_doubleArrow(_expand, _function);
        }
      };
      ObjectExtensions.<SWTBotTreeItem>operator_doubleArrow(_expand_1, _function_1);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testOutlineForConstructors() {
    try {
      this.createProjectAndAssertNoErrorMarker(XtraitjSwtbotAbstractTests.PROJECT_TYPE);
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("package my.traits;");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("C() {}");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("C(int i, String s) {}");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      this.updateEditorContents(_builder);
      SWTBotTreeItem _outlineTraitNode = this.outlineTraitNode("C");
      SWTBotTreeItem _expand = _outlineTraitNode.expand();
      final Procedure1<SWTBotTreeItem> _function = new Procedure1<SWTBotTreeItem>() {
        public void apply(final SWTBotTreeItem it) {
          it.getNode("C()");
          it.getNode("C(int, String)");
        }
      };
      ObjectExtensions.<SWTBotTreeItem>operator_doubleArrow(_expand, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}

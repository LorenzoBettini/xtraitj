package xtraitj.ui.tests;

import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.eclipse.xtext.junit4.ui.ContentAssistProcessorTestBuilder;
import org.eclipse.xtext.xbase.junit.ui.AbstractContentAssistTest;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.XtraitjUiInjectorProvider;

@RunWith(XtextRunner.class)
@InjectWith(XtraitjUiInjectorProvider.class)
@SuppressWarnings("all")
public class TraitJContentAssistTest extends AbstractContentAssistTest {
  private final String T = new Function0<String>() {
    public String apply() {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object m() { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      return _builder.toString();
    }
  }.apply();
  
  @Test
  public void testRenameMembers() {
    try {
      ContentAssistProcessorTestBuilder _newBuilder = this.newBuilder();
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 uses T[rename ");
      String _plus = (this.T + _builder);
      ContentAssistProcessorTestBuilder _append = _newBuilder.append(_plus);
      _append.assertText("m", "s");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testHideMembers() {
    try {
      ContentAssistProcessorTestBuilder _newBuilder = this.newBuilder();
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 uses T[hide ");
      String _plus = (this.T + _builder);
      ContentAssistProcessorTestBuilder _append = _newBuilder.append(_plus);
      _append.assertText("m");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testAliasMembers() {
    try {
      ContentAssistProcessorTestBuilder _newBuilder = this.newBuilder();
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 uses T[alias ");
      String _plus = (this.T + _builder);
      ContentAssistProcessorTestBuilder _append = _newBuilder.append(_plus);
      _append.assertText("m");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRestrictMembers() {
    try {
      ContentAssistProcessorTestBuilder _newBuilder = this.newBuilder();
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 uses T[restrict ");
      String _plus = (this.T + _builder);
      ContentAssistProcessorTestBuilder _append = _newBuilder.append(_plus);
      _append.assertText("m");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testPrivateMethod() {
    try {
      ContentAssistProcessorTestBuilder _newBuilder = this.newBuilder();
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("private String m() { null; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n() { null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T1 uses T[rename ");
      ContentAssistProcessorTestBuilder _append = _newBuilder.append(_builder.toString());
      _append.assertText("n");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRedirectMembers() {
    try {
      ContentAssistProcessorTestBuilder _newBuilder = this.newBuilder();
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 uses T[redirect ");
      String _plus = (this.T + _builder);
      ContentAssistProcessorTestBuilder _append = _newBuilder.append(_plus);
      ContentAssistProcessorTestBuilder _assertText = _append.assertText("m", "s");
      ContentAssistProcessorTestBuilder _append_1 = _assertText.append(" m to ");
      _append_1.assertText("m", "s");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testImplementsInterface() {
    try {
      ContentAssistProcessorTestBuilder _newBuilder = this.newBuilder();
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C implements Lis");
      ContentAssistProcessorTestBuilder _append = _newBuilder.append(_builder.toString());
      _append.assertProposal("List");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testImplementsNotClass() {
    try {
      ContentAssistProcessorTestBuilder _newBuilder = this.newBuilder();
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.LinkedList");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C implements LinkedL");
      ContentAssistProcessorTestBuilder _append = _newBuilder.append(_builder.toString());
      _append.assertText();
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}

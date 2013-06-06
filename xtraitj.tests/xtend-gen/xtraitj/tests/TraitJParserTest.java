package xtraitj.tests;

import com.google.inject.Inject;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.eclipse.xtext.junit4.util.ParseHelper;
import org.eclipse.xtext.junit4.validation.ValidationTestHelper;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.XtraitjInjectorProvider;
import xtraitj.input.tests.TraitJInputs;
import xtraitj.xtraitj.TJProgram;

@RunWith(XtextRunner.class)
@InjectWith(XtraitjInjectorProvider.class)
@SuppressWarnings("all")
public class TraitJParserTest {
  @Inject
  @Extension
  private ParseHelper<TJProgram> _parseHelper;
  
  @Inject
  @Extension
  private ValidationTestHelper _validationTestHelper;
  
  @Inject
  @Extension
  private TraitJInputs _traitJInputs;
  
  @Test
  public void simpleProgram() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C uses T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFields() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("package my.pack;");
      _builder.newLine();
      _builder.newLine();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object o;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C uses T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object o;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<String> l;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testMethods() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object a(String s);");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object m(List<String> l, String s) {");
      _builder.newLine();
      _builder.append("\t\t");
      _builder.append("return null;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("}");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitSum() {
    try {
      CharSequence _traitSum = this._traitJInputs.traitSum();
      TJProgram _parse = this._parseHelper.parse(_traitSum);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitUsesTraitWithFields() {
    try {
      CharSequence _traitUsesTraitWithFields = this._traitJInputs.traitUsesTraitWithFields();
      TJProgram _parse = this._parseHelper.parse(_traitUsesTraitWithFields);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitRenameOperations() {
    try {
      CharSequence _traitRenameOperations = this._traitJInputs.traitRenameOperations();
      TJProgram _parse = this._parseHelper.parse(_traitRenameOperations);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitRenameField() {
    try {
      CharSequence _classUsesTraitWithRenamedFields = this._traitJInputs.classUsesTraitWithRenamedFields();
      TJProgram _parse = this._parseHelper.parse(_classUsesTraitWithRenamedFields);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassUsesTraitWithRenamedRequiredMethods() {
    try {
      CharSequence _classUsesTraitWithRenamedRequiredMethods = this._traitJInputs.classUsesTraitWithRenamedRequiredMethods();
      TJProgram _parse = this._parseHelper.parse(_classUsesTraitWithRenamedRequiredMethods);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassUsesTraitRenameProvidedMethodToRequiredAndSum() {
    try {
      CharSequence _classUsesTraitRenameProvidedMethodToRequiredAndSum = this._traitJInputs.classUsesTraitRenameProvidedMethodToRequiredAndSum();
      TJProgram _parse = this._parseHelper.parse(_classUsesTraitRenameProvidedMethodToRequiredAndSum);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testUsesTraitRenameProvidedMethodToRequiredAndSum2() {
    try {
      CharSequence _classUsesTraitRenameProvidedMethodToRequiredAndSum2 = this._traitJInputs.classUsesTraitRenameProvidedMethodToRequiredAndSum2();
      TJProgram _parse = this._parseHelper.parse(_classUsesTraitRenameProvidedMethodToRequiredAndSum2);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassRenamesRequiredMethodToProvidedAndSum() {
    try {
      CharSequence _classRenamesRequiredMethodToProvidedAndSum = this._traitJInputs.classRenamesRequiredMethodToProvidedAndSum();
      TJProgram _parse = this._parseHelper.parse(_classRenamesRequiredMethodToProvidedAndSum);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitHide() {
    try {
      CharSequence _traitHide = this._traitJInputs.traitHide();
      TJProgram _parse = this._parseHelper.parse(_traitHide);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitAlias() {
    try {
      CharSequence _traitAlias = this._traitJInputs.traitAlias();
      TJProgram _parse = this._parseHelper.parse(_traitAlias);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitAliasWithRenameAndHide() {
    try {
      CharSequence _traitAliasWithRenameAndHide = this._traitJInputs.traitAliasWithRenameAndHide();
      TJProgram _parse = this._parseHelper.parse(_traitAliasWithRenameAndHide);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitRestrict() {
    try {
      CharSequence _traitRestrict = this._traitJInputs.traitRestrict();
      TJProgram _parse = this._parseHelper.parse(_traitRestrict);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testPrivateMethod() {
    try {
      CharSequence _traitPrivateMethod = this._traitJInputs.traitPrivateMethod();
      TJProgram _parse = this._parseHelper.parse(_traitPrivateMethod);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitRedirect() {
    try {
      CharSequence _traitRedirect = this._traitJInputs.traitRedirect();
      TJProgram _parse = this._parseHelper.parse(_traitRedirect);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitRequiredMethodProvidedWithCovariantReturnType() {
    try {
      CharSequence _traitRequiredMethodProvidedWithCovariantReturnType = this._traitJInputs.traitRequiredMethodProvidedWithCovariantReturnType();
      TJProgram _parse = this._parseHelper.parse(_traitRequiredMethodProvidedWithCovariantReturnType);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassImplementsSerializableAndClonable() {
    try {
      CharSequence _classImplementsSerializableAndClonable = this._traitJInputs.classImplementsSerializableAndClonable();
      TJProgram _parse = this._parseHelper.parse(_classImplementsSerializableAndClonable);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
}

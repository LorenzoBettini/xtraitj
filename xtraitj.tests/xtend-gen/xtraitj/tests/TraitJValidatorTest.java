package xtraitj.tests;

import com.google.inject.Inject;
import java.util.List;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.common.types.TypesPackage;
import org.eclipse.xtext.diagnostics.Diagnostic;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.eclipse.xtext.junit4.util.ParseHelper;
import org.eclipse.xtext.junit4.validation.ValidationTestHelper;
import org.eclipse.xtext.validation.Issue;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.XtraitjInjectorProvider;
import xtraitj.validation.XtraitjValidator;
import xtraitj.xtraitj.TJProgram;
import xtraitj.xtraitj.XtraitjPackage;

@RunWith(XtextRunner.class)
@InjectWith(XtraitjInjectorProvider.class)
@SuppressWarnings("all")
public class TraitJValidatorTest {
  @Inject
  @Extension
  private ParseHelper<TJProgram> _parseHelper;
  
  @Inject
  @Extension
  private ValidationTestHelper _validationTestHelper;
  
  @Test
  public void testCycle() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 uses T2, T1 {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      EClass _tJTrait = XtraitjPackage.eINSTANCE.getTJTrait();
      this._validationTestHelper.assertError(_parse, _tJTrait, 
        XtraitjValidator.DEPENDENCY_CYCLE, 
        "Cycle in dependency of \'T1\'");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testCycle2() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 uses T2, T3 {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {}");
      _builder.newLine();
      _builder.append("trait T3 uses T2, T1 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJTrait = XtraitjPackage.eINSTANCE.getTJTrait();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJTrait, 
            XtraitjValidator.DEPENDENCY_CYCLE, 
            "Cycle in dependency of \'T1\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitInitializeField() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s = \"foo\";");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJField = XtraitjPackage.eINSTANCE.getTJField();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJField, 
            XtraitjValidator.TRAIT_INITIALIZES_FIELD, 
            "Traits cannot initialize fields");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassMissingFields() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C uses T {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJClass = XtraitjPackage.eINSTANCE.getTJClass();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJClass, 
            XtraitjValidator.MISSING_REQUIRED_FIELD, 
            "Class must provide required field \'String s\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassMissingRequiredMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m() { return 0; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Integer m(); // this satisfy T1\'s requirement");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C uses T1, T2 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJClass = XtraitjPackage.eINSTANCE.getTJClass();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJClass, 
            XtraitjValidator.MISSING_REQUIRED_METHOD, 
            "Class must provide required method \'String n(int)\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassMissingRenamedRequiredMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m() { return 0; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i) { \"n\" }; // this satisfy T1\'s requirement");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T2[rename n to n1] {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C uses T1, T3 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJClass = XtraitjPackage.eINSTANCE.getTJClass();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJClass, 
            XtraitjValidator.MISSING_REQUIRED_METHOD, 
            "Class must provide required method \'String n(int)\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassMissingRestrictedMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m() { return 0; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[restrict m] {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C uses T2 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJClass = XtraitjPackage.eINSTANCE.getTJClass();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJClass, 
            XtraitjValidator.MISSING_REQUIRED_METHOD, 
            "Class must provide required method \'String m()\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testHideRequiredMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[hide n] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJHideOperation = XtraitjPackage.eINSTANCE.getTJHideOperation();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJHideOperation, 
            XtraitjValidator.HIDING_REQUIRED, 
            "Cannot hide required method \'n\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testAliasRequiredMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[alias n] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJAliasOperation = XtraitjPackage.eINSTANCE.getTJAliasOperation();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJAliasOperation, 
            XtraitjValidator.ALIASING_REQUIRED, 
            "Cannot alias required method \'n\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRestrictRequiredMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[restrict n] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJRestrictOperation = XtraitjPackage.eINSTANCE.getTJRestrictOperation();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJRestrictOperation, 
            XtraitjValidator.RESTRICTING_REQUIRED, 
            "Cannot restrict required method \'n\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testOperationOnPrivateMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("private String n(int i) { null }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[restrict n] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJRestrictOperation = XtraitjPackage.eINSTANCE.getTJRestrictOperation();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJRestrictOperation, 
            Diagnostic.LINKING_DIAGNOSTIC, 
            "Couldn\'t resolve reference to JvmMember \'n\'.");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFieldRedirectedToMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String f;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m() { null }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[redirect f to m] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      EClass _tJRedirectOperation = XtraitjPackage.eINSTANCE.getTJRedirectOperation();
      this._validationTestHelper.assertError(_parse, _tJRedirectOperation, 
        XtraitjValidator.FIELD_REDIRECTED_TO_METHOD, 
        "Cannot redirect field \'f\' to method \'m\'");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testMethodRedirectedToField() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String f;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m() { null }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[redirect m to f] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      EClass _tJRedirectOperation = XtraitjPackage.eINSTANCE.getTJRedirectOperation();
      this._validationTestHelper.assertError(_parse, _tJRedirectOperation, 
        XtraitjValidator.METHOD_REDIRECTED_TO_FIELD, 
        "Cannot redirect method \'m\' to field \'f\'");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRedirectNotCompliant() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.append("import java.util.ArrayList");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String f;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i;");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<? extends String> m();");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<String> n();");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[redirect f to i, redirect n to m] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJRedirectOperation = XtraitjPackage.eINSTANCE.getTJRedirectOperation();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJRedirectOperation, 
            XtraitjValidator.REDIRECT_NOT_COMPLIANT, 
            "\'int i\' is not compliant with \'String f\'");
          EClass _tJRedirectOperation_1 = XtraitjPackage.eINSTANCE.getTJRedirectOperation();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJRedirectOperation_1, 
            XtraitjValidator.REDIRECT_NOT_COMPLIANT, 
            "\'List<? extends String> m()\' is not compliant with \'List<String> n()\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRedirectToTheSameMember() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String f;");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n();");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[redirect f to f, redirect n to n] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJRedirectOperation = XtraitjPackage.eINSTANCE.getTJRedirectOperation();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJRedirectOperation, 
            XtraitjValidator.REDIRECT_TO_SAME_MEMBER, 
            "Redirect to the same member \'f\'");
          EClass _tJRedirectOperation_1 = XtraitjPackage.eINSTANCE.getTJRedirectOperation();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJRedirectOperation_1, 
            XtraitjValidator.REDIRECT_TO_SAME_MEMBER, 
            "Redirect to the same member \'n\'");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassImplementsClass() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("class C implements java.util.LinkedList {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      EClass _jvmParameterizedTypeReference = TypesPackage.eINSTANCE.getJvmParameterizedTypeReference();
      this._validationTestHelper.assertError(_parse, _jvmParameterizedTypeReference, 
        XtraitjValidator.NOT_AN_INTERFACE, 
        "Not a valid interface \'LinkedList\'");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassDoesNotImplementAllInterfaceMethods() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("class C implements java.util.List {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMissingInterfaceMethod(it, "void add(int, E)");
          TraitJValidatorTest.this.assertMissingInterfaceMethod(it, "int indexOf(Object)");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassImplementsAllInterfaceMethods() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import xtraitj.input.tests.MyTestInterface");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m(java.util.List<String> l) { return l.size }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C implements MyTestInterface uses T {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassImplementsAllInterfaceMethodsWithSum() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import xtraitj.input.tests.MyTestInterface");
      _builder.newLine();
      _builder.append("import xtraitj.input.tests.MyTestInterface2");
      _builder.newLine();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m(List<String> l) { return l.size }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<Integer> n(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C implements MyTestInterface, MyTestInterface2 uses T1, T2 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      this._validationTestHelper.assertNoErrors(_parse);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testDuplicateTraitReference() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C uses T, T {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      EClass _tJTraitReference = XtraitjPackage.eINSTANCE.getTJTraitReference();
      this._validationTestHelper.assertError(_parse, _tJTraitReference, 
        XtraitjValidator.DUPLICATE_TRAIT_REFERENCE, 
        "Duplicate trait reference \'T\'");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testDuplicateMember() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int f;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int f;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m();");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String c;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int c;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJField = XtraitjPackage.eINSTANCE.getTJField();
          TraitJValidatorTest.this.assertDuplicateMember(it, "f", _tJField);
          EClass _tJField_1 = XtraitjPackage.eINSTANCE.getTJField();
          TraitJValidatorTest.this.assertDuplicateMember(it, "c", _tJField_1);
          EClass _tJMethod = XtraitjPackage.eINSTANCE.getTJMethod();
          TraitJValidatorTest.this.assertDuplicateMember(it, "m", _tJMethod);
          EClass _tJRequiredMethod = XtraitjPackage.eINSTANCE.getTJRequiredMethod();
          TraitJValidatorTest.this.assertDuplicateMember(it, "m", _tJRequiredMethod);
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFieldConflicts() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertFieldConflict(it, "String s", "T1");
          TraitJValidatorTest.this.assertFieldConflict(it, "int s", "T2");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFieldConflicts2() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertFieldConflict(it, "String s", "T1");
          TraitJValidatorTest.this.assertDeclaredFieldConflict(it, "s");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFieldConflicts3() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertFieldConflict(it, "String s", "T1");
          TraitJValidatorTest.this.assertDeclaredFieldConflict(it, "s");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFieldConflicts4() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertFieldConflict(it, "String s", "T2");
          TraitJValidatorTest.this.assertDeclaredFieldConflict(it, "s");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFieldConflicts5() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i;");
      _builder.newLine();
      _builder.append("}");
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertFieldConflict(it, "String s", "T2");
          TraitJValidatorTest.this.assertDeclaredFieldConflict(it, "s");
          TraitJValidatorTest.this.assertFieldConflict(it, "int i", "T1");
          TraitJValidatorTest.this.assertDeclaredFieldConflict(it, "i");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRequiredMethodConflicts() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "String m(int)", "T1");
          TraitJValidatorTest.this.assertMethodConflict(it, "int m(int)", "T2");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRequiredMethodConflicts2() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "String m(int)", "T1");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "m");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRequiredMethodConflicts3() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n(boolean i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "String m(int)", "T1");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "m");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRequiredMethodConflicts4() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n(boolean i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n(boolean i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "int n(boolean)", "T2");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "n");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRequiredMethodConflicts5() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n(boolean i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n(boolean i);");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "int n(boolean)", "T2");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "n");
          TraitJValidatorTest.this.assertMethodConflict(it, "String m(int)", "T1");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "m");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRequiredMethodConflictsWithDefinedMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i) { return null; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i);");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n(boolean i);");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "String m(int)", "T1");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "m");
          TraitJValidatorTest.this.assertMethodConflict(it, "String n(int)", "T1");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "n");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testDefinedMethodConflicts() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i) { return null; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m(int i) { return 0; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "String m(int)", "T1");
          TraitJValidatorTest.this.assertMethodConflict(it, "int m(int)", "T2");
          TraitJValidatorTest.this.assertMethodConflict(it, "String n(int)", "T1");
          TraitJValidatorTest.this.assertMethodConflict(it, "String n(int)", "T2");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testDefinedMethodConflicts2() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i) { return null; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i) { return null; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n(boolean i) { return 0; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "String m(int)", "T1");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "m");
          TraitJValidatorTest.this.assertMethodConflict(it, "String n(int)", "T1");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "n");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testMethodConflictsWithRenaming() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i) { return null; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n1(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1[rename m to m1, rename n to n1], T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m1(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "String m1(int)", "T1");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "m1");
          TraitJValidatorTest.this.assertMethodConflict(it, "String n1(int)", "T1");
          TraitJValidatorTest.this.assertMethodConflict(it, "String n1(int)", "T2");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testMethodConflictsWithAlias() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m(int i) { return null; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n1(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1[alias m as m1], T2[alias n1 as n] {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m1(int i) { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          TraitJValidatorTest.this.assertMethodConflict(it, "String m1(int)", "T1");
          TraitJValidatorTest.this.assertDeclaredMethodConflict(it, "m1");
          TraitJValidatorTest.this.assertMethodConflict(it, "String n(int)", "T1");
          TraitJValidatorTest.this.assertMethodConflict(it, "String n(int)", "T2");
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testDuplicateDeclarations() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T {}");
      _builder.newLine();
      _builder.append("trait T {}");
      _builder.newLine();
      _builder.append("trait T1 {}");
      _builder.newLine();
      _builder.append("class T1 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJTrait = XtraitjPackage.eINSTANCE.getTJTrait();
          TraitJValidatorTest.this.assertDuplicateDeclaration(it, "T", _tJTrait);
          EClass _tJTrait_1 = XtraitjPackage.eINSTANCE.getTJTrait();
          TraitJValidatorTest.this.assertDuplicateDeclaration(it, "T1", _tJTrait_1);
          EClass _tJClass = XtraitjPackage.eINSTANCE.getTJClass();
          TraitJValidatorTest.this.assertDuplicateDeclaration(it, "T1", _tJClass);
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testAlterationsToAlreadyExistingNames() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m() { return 0; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m1();");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n();");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n1();");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 uses T1[alias m as m1, rename n to n1] {");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJAliasOperation = XtraitjPackage.eINSTANCE.getTJAliasOperation();
          TraitJValidatorTest.this.assertAlreadyExistingMember(it, "m1", _tJAliasOperation);
          EClass _tJRenameOperation = XtraitjPackage.eINSTANCE.getTJRenameOperation();
          TraitJValidatorTest.this.assertAlreadyExistingMember(it, "n1", _tJRenameOperation);
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testConstructorWithTheWrongName() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("D() {}");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      EClass _tJConstructor = XtraitjPackage.eINSTANCE.getTJConstructor();
      this._validationTestHelper.assertError(_parse, _tJConstructor, 
        XtraitjValidator.WRONG_CONSTRUCTOR_NAME, 
        "Wrong constructor name \'D\'");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testDuplicateConstructors() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("C() {}");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("C(int i) {}");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("C() {}");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJConstructor = XtraitjPackage.eINSTANCE.getTJConstructor();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJConstructor, 
            XtraitjValidator.DUPLICATE_CONSTRUCTOR, 
            "Duplicate constructor \'C()\'");
          List<Issue> _validate = TraitJValidatorTest.this._validationTestHelper.validate(it);
          int _size = _validate.size();
          Assert.assertEquals(2, _size);
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testDuplicateConstructors2() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("C(int j, String s) {}");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("C(int i) {}");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("C(int k, String s2) {}");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
        public void apply(final TJProgram it) {
          EClass _tJConstructor = XtraitjPackage.eINSTANCE.getTJConstructor();
          TraitJValidatorTest.this._validationTestHelper.assertError(it, _tJConstructor, 
            XtraitjValidator.DUPLICATE_CONSTRUCTOR, 
            "Duplicate constructor \'C(int, String)\'");
          List<Issue> _validate = TraitJValidatorTest.this._validationTestHelper.validate(it);
          int _size = _validate.size();
          Assert.assertEquals(2, _size);
        }
      };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  private void assertMissingInterfaceMethod(final EObject o, final String methodRepr) {
    EClass _tJClass = XtraitjPackage.eINSTANCE.getTJClass();
    String _plus = ("Class must provide interface method \'" + methodRepr);
    String _plus_1 = (_plus + "\'");
    this._validationTestHelper.assertError(o, _tJClass, 
      XtraitjValidator.MISSING_INTERFACE_METHOD, _plus_1);
  }
  
  private void assertDuplicateMember(final EObject o, final String memberName, final EClass c) {
    String _plus = ("Duplicate member \'" + memberName);
    String _plus_1 = (_plus + "\'");
    this._validationTestHelper.assertError(o, c, XtraitjValidator.DUPLICATE_MEMBER, _plus_1);
  }
  
  private void assertDuplicateDeclaration(final EObject o, final String name, final EClass c) {
    String _plus = ("Duplicate declaration \'" + name);
    String _plus_1 = (_plus + "\'");
    this._validationTestHelper.assertError(o, c, XtraitjValidator.DUPLICATE_DECLARATION, _plus_1);
  }
  
  private void assertFieldConflict(final EObject o, final String repr, final String traitName) {
    EClass _tJTraitReference = XtraitjPackage.eINSTANCE.getTJTraitReference();
    String _plus = ("Field conflict \'" + repr);
    String _plus_1 = (_plus + "\' in ");
    String _plus_2 = (_plus_1 + traitName);
    this._validationTestHelper.assertError(o, _tJTraitReference, 
      XtraitjValidator.FIELD_CONFLICT, _plus_2);
  }
  
  private void assertDeclaredFieldConflict(final EObject o, final String repr) {
    EClass _tJField = XtraitjPackage.eINSTANCE.getTJField();
    String _plus = ("Field conflict \'" + repr);
    String _plus_1 = (_plus + "\'");
    this._validationTestHelper.assertError(o, _tJField, 
      XtraitjValidator.FIELD_CONFLICT, _plus_1);
  }
  
  private void assertMethodConflict(final EObject o, final String repr, final String traitName) {
    EClass _tJTraitReference = XtraitjPackage.eINSTANCE.getTJTraitReference();
    String _plus = ("Method conflict \'" + repr);
    String _plus_1 = (_plus + "\' in ");
    String _plus_2 = (_plus_1 + traitName);
    this._validationTestHelper.assertError(o, _tJTraitReference, 
      XtraitjValidator.METHOD_CONFLICT, _plus_2);
  }
  
  private void assertDeclaredMethodConflict(final EObject o, final String repr) {
    EClass _tJMember = XtraitjPackage.eINSTANCE.getTJMember();
    String _plus = ("Method conflict \'" + repr);
    String _plus_1 = (_plus + "\'");
    this._validationTestHelper.assertError(o, _tJMember, 
      XtraitjValidator.METHOD_CONFLICT, _plus_1);
  }
  
  private void assertAlreadyExistingMember(final EObject o, final String memberName, final EClass c) {
    String _plus = ("Member already exists \'" + memberName);
    String _plus_1 = (_plus + "\'");
    this._validationTestHelper.assertError(o, c, XtraitjValidator.MEMBER_ALREADY_EXISTS, _plus_1);
  }
}

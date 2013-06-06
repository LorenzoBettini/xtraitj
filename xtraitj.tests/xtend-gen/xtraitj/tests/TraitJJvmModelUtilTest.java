package xtraitj.tests;

import com.google.common.base.Objects;
import com.google.inject.Inject;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.common.types.JvmFeature;
import org.eclipse.xtext.common.types.JvmMember;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.eclipse.xtext.junit4.util.ParseHelper;
import org.eclipse.xtext.junit4.validation.ValidationTestHelper;
import org.eclipse.xtext.xbase.lib.Conversions;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.XtraitjInjectorProvider;
import xtraitj.input.tests.TraitJInputs;
import xtraitj.jvmmodel.TraitJJvmModelUtil;
import xtraitj.util.TraitJModelUtil;
import xtraitj.xtraitj.TJClass;
import xtraitj.xtraitj.TJField;
import xtraitj.xtraitj.TJMethod;
import xtraitj.xtraitj.TJProgram;
import xtraitj.xtraitj.TJRequiredMethod;
import xtraitj.xtraitj.TJRestrictOperation;
import xtraitj.xtraitj.TJTrait;
import xtraitj.xtraitj.TJTraitExpression;
import xtraitj.xtraitj.TJTraitReference;

@RunWith(XtextRunner.class)
@InjectWith(XtraitjInjectorProvider.class)
@SuppressWarnings("all")
public class TraitJJvmModelUtilTest {
  @Inject
  @Extension
  private ParseHelper<TJProgram> _parseHelper;
  
  @Inject
  @Extension
  private ValidationTestHelper _validationTestHelper;
  
  @Inject
  @Extension
  private TraitJInputs _traitJInputs;
  
  @Inject
  @Extension
  private TraitJJvmModelUtil _traitJJvmModelUtil;
  
  @Test
  public void testAssociations() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T uses T1 {}");
      _builder.newLine();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object m() { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TraitJJvmModelUtilTest.this.assertAssociatedInterface(_get, "T");
            Iterable<TJTrait> _traits_1 = TraitJModelUtil.traits(it);
            TJTrait _get_1 = ((TJTrait[])Conversions.unwrapArray(_traits_1, TJTrait.class))[0];
            TraitJJvmModelUtilTest.this.assertAssociatedClass(_get_1, "TImpl");
            Iterable<TJTrait> _traits_2 = TraitJModelUtil.traits(it);
            TJTrait _get_2 = ((TJTrait[])Conversions.unwrapArray(_traits_2, TJTrait.class))[0];
            TJTraitExpression _traitExpression = _get_2.getTraitExpression();
            TraitJJvmModelUtilTest.this.assertAssociatedInterface(_traitExpression, "T1");
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitJvmAllFeatures() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TraitJJvmModelUtilTest.this.assertJvmFeatures(_get, "getF, setF, m, t1, t2, getF1, setF1, t3, getF3, setF3, getF2, setF2, req2, t4, t5, getF4, setF4, getF5, setF5");
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitJvmAllOperations() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TraitJJvmModelUtilTest.this.assertJvmOperations(_get, "getF, setF, m, t1, t2, getF1, setF1, t3, getF3, setF3, getF2, setF2, req2, t4, t5, getF4, setF4, getF5, setF5");
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitExpressionAllJvmFeatures() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TJTraitExpression _traitExpression = _get.getTraitExpression();
            List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
            final Procedure1<List<TJTraitReference>> _function = new Procedure1<List<TJTraitReference>>() {
                public void apply(final List<TJTraitReference> it) {
                  TJTraitReference _get = it.get(0);
                  TraitJJvmModelUtilTest.this.assertJvmFeatures(_get, "getF1, setF1, t1, t3, getF3, setF3");
                  TJTraitReference _get_1 = it.get(1);
                  TraitJJvmModelUtilTest.this.assertJvmFeatures(_get_1, "getF2, setF2, t2, req2, t4, t5, getF4, setF4, getF5, setF5");
                }
              };
            ObjectExtensions.<List<TJTraitReference>>operator_doubleArrow(_traitReferences, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitExpressionAllJvmOperations() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TJTraitExpression _traitExpression = _get.getTraitExpression();
            List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
            final Procedure1<List<TJTraitReference>> _function = new Procedure1<List<TJTraitReference>>() {
                public void apply(final List<TJTraitReference> it) {
                  TJTraitReference _get = it.get(0);
                  TraitJJvmModelUtilTest.this.assertJvmOperations(_get, "getF1, setF1, t1, t3, getF3, setF3");
                  TJTraitReference _get_1 = it.get(1);
                  TraitJJvmModelUtilTest.this.assertJvmOperations(_get_1, "getF2, setF2, t2, req2, t4, t5, getF4, setF4, getF5, setF5");
                }
              };
            ObjectExtensions.<List<TJTraitReference>>operator_doubleArrow(_traitReferences, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitExpressionAllJvmMethodOperations() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TJTraitExpression _traitExpression = _get.getTraitExpression();
            List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
            final Procedure1<List<TJTraitReference>> _function = new Procedure1<List<TJTraitReference>>() {
                public void apply(final List<TJTraitReference> it) {
                  TJTraitReference _get = it.get(0);
                  TraitJJvmModelUtilTest.this.assertJvmMethodOperations(_get, "t1, t3");
                  TJTraitReference _get_1 = it.get(1);
                  TraitJJvmModelUtilTest.this.assertJvmMethodOperations(_get_1, "t2, t4, t5");
                }
              };
            ObjectExtensions.<List<TJTraitReference>>operator_doubleArrow(_traitReferences, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testAllJvmMethodOperationsWithPrivate() {
    try {
      CharSequence _traitPrivateMethod = this._traitJInputs.traitPrivateMethod();
      TJProgram _parse = this._parseHelper.parse(_traitPrivateMethod);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJClass> _classes = TraitJModelUtil.classes(it);
            TJClass _head = IterableExtensions.<TJClass>head(_classes);
            TJTraitExpression _traitExpression = _head.getTraitExpression();
            List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
            final Procedure1<List<TJTraitReference>> _function = new Procedure1<List<TJTraitReference>>() {
                public void apply(final List<TJTraitReference> it) {
                  TJTraitReference _get = it.get(0);
                  TraitJJvmModelUtilTest.this.assertJvmMethodOperations(_get, "callPriv");
                }
              };
            ObjectExtensions.<List<TJTraitReference>>operator_doubleArrow(_traitReferences, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassAllJvmMethodOperations() {
    try {
      CharSequence _classUsesTraitWithDependencies = this._traitJInputs.classUsesTraitWithDependencies();
      TJProgram _parse = this._parseHelper.parse(_classUsesTraitWithDependencies);
      Iterable<TJClass> _classes = TraitJModelUtil.classes(_parse);
      TJClass _head = IterableExtensions.<TJClass>head(_classes);
      this.assertJvmMethodOperations(_head, "m, t1, t2, t3, t4, t5");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testAllJvmFieldsOperations() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TJTraitExpression _traitExpression = _get.getTraitExpression();
            List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
            final Procedure1<List<TJTraitReference>> _function = new Procedure1<List<TJTraitReference>>() {
                public void apply(final List<TJTraitReference> it) {
                  TJTraitReference _get = it.get(0);
                  TraitJJvmModelUtilTest.this.assertJvmFieldsOperations(_get, "getF1, setF1, getF3, setF3");
                  TJTraitReference _get_1 = it.get(1);
                  TraitJJvmModelUtilTest.this.assertJvmFieldsOperations(_get_1, "getF2, setF2, getF4, setF4, getF5, setF5");
                }
              };
            ObjectExtensions.<List<TJTraitReference>>operator_doubleArrow(_traitReferences, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testAllJvmRequiredFieldOperations() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TJTraitExpression _traitExpression = _get.getTraitExpression();
            List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
            final Procedure1<List<TJTraitReference>> _function = new Procedure1<List<TJTraitReference>>() {
                public void apply(final List<TJTraitReference> it) {
                  TJTraitReference _get = it.get(0);
                  TraitJJvmModelUtilTest.this.assertJvmRequiredFieldOperations(_get, "getF1, getF3");
                  TJTraitReference _get_1 = it.get(1);
                  TraitJJvmModelUtilTest.this.assertJvmRequiredFieldOperations(_get_1, "getF2, getF4, getF5");
                }
              };
            ObjectExtensions.<List<TJTraitReference>>operator_doubleArrow(_traitReferences, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testDefines() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  Iterable<JvmOperation> _jvmAllOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllOperations(it);
                  final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
                      public Boolean apply(final JvmOperation it) {
                        String _simpleName = it.getSimpleName();
                        boolean _equals = Objects.equal(_simpleName, "m");
                        return Boolean.valueOf(_equals);
                      }
                    };
                  JvmOperation _findFirst = IterableExtensions.<JvmOperation>findFirst(_jvmAllOperations, _function);
                  boolean _defines = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.defines(it, _findFirst);
                  Assert.assertTrue(_defines);
                  Iterable<JvmOperation> _jvmAllOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllOperations(it);
                  final Function1<JvmOperation,Boolean> _function_1 = new Function1<JvmOperation,Boolean>() {
                      public Boolean apply(final JvmOperation it) {
                        String _simpleName = it.getSimpleName();
                        boolean _equals = Objects.equal(_simpleName, "t1");
                        return Boolean.valueOf(_equals);
                      }
                    };
                  JvmOperation _findFirst_1 = IterableExtensions.<JvmOperation>findFirst(_jvmAllOperations_1, _function_1);
                  boolean _defines_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.defines(it, _findFirst_1);
                  Assert.assertFalse(_defines_1);
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testIsRequiredMethod() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            Iterable<JvmOperation> _jvmAllOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllOperations(_get);
            final Procedure1<Iterable<JvmOperation>> _function = new Procedure1<Iterable<JvmOperation>>() {
                public void apply(final Iterable<JvmOperation> it) {
                  JvmOperation _memberByName = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.memberByName(it, "t1");
                  TraitJJvmModelUtilTest.this.assertRequired(_memberByName, false);
                  JvmOperation _memberByName_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.memberByName(it, "req2");
                  TraitJJvmModelUtilTest.this.assertRequired(_memberByName_1, true);
                }
              };
            ObjectExtensions.<Iterable<JvmOperation>>operator_doubleArrow(_jvmAllOperations, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testIsRequiredMethodFromSum() {
    try {
      CharSequence _traitSum = this._traitJInputs.traitSum();
      TJProgram _parse = this._parseHelper.parse(_traitSum);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            Iterable<JvmOperation> _jvmAllOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllOperations(_get);
            final Procedure1<Iterable<JvmOperation>> _function = new Procedure1<Iterable<JvmOperation>>() {
                public void apply(final Iterable<JvmOperation> it) {
                  JvmOperation _memberByName = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.memberByName(it, "t1");
                  TraitJJvmModelUtilTest.this.assertRequired(_memberByName, false);
                  JvmOperation _memberByName_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.memberByName(it, "t2");
                  TraitJJvmModelUtilTest.this.assertRequired(_memberByName_1, false);
                }
              };
            ObjectExtensions.<Iterable<JvmOperation>>operator_doubleArrow(_jvmAllOperations, _function);
            Iterable<TJTrait> _traits_1 = TraitJModelUtil.traits(it);
            TJTrait _get_1 = ((TJTrait[])Conversions.unwrapArray(_traits_1, TJTrait.class))[1];
            Iterable<JvmOperation> _jvmAllOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllOperations(_get_1);
            final Procedure1<Iterable<JvmOperation>> _function_1 = new Procedure1<Iterable<JvmOperation>>() {
                public void apply(final Iterable<JvmOperation> it) {
                  JvmOperation _memberByName = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.memberByName(it, "t1");
                  TraitJJvmModelUtilTest.this.assertRequired(_memberByName, false);
                  JvmOperation _memberByName_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.memberByName(it, "t2");
                  TraitJJvmModelUtilTest.this.assertRequired(_memberByName_1, true);
                }
              };
            ObjectExtensions.<Iterable<JvmOperation>>operator_doubleArrow(_jvmAllOperations_1, _function_1);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testIsRequiredField() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            Iterable<JvmOperation> _jvmAllOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllOperations(_get);
            final Procedure1<Iterable<JvmOperation>> _function = new Procedure1<Iterable<JvmOperation>>() {
                public void apply(final Iterable<JvmOperation> it) {
                  JvmOperation _memberByName = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.memberByName(it, "getF2");
                  TraitJJvmModelUtilTest.this.assertRequired(_memberByName, true);
                  JvmOperation _memberByName_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.memberByName(it, "getF3");
                  TraitJJvmModelUtilTest.this.assertRequired(_memberByName_1, true);
                }
              };
            ObjectExtensions.<Iterable<JvmOperation>>operator_doubleArrow(_jvmAllOperations, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFieldRepresentation() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TJTraitExpression _traitExpression = _get.getTraitExpression();
            List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
            final Procedure1<List<TJTraitReference>> _function = new Procedure1<List<TJTraitReference>>() {
                public void apply(final List<TJTraitReference> it) {
                  TJTraitReference _get = it.get(0);
                  Iterable<JvmOperation> _jvmAllFieldOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllFieldOperations(_get);
                  final Procedure1<Iterable<JvmOperation>> _function = new Procedure1<Iterable<JvmOperation>>() {
                      public void apply(final Iterable<JvmOperation> it) {
                        JvmOperation _get = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
                        TraitJJvmModelUtilTest.this.assertFieldRepresentation(_get, "Object f1");
                        JvmOperation _get_1 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[2];
                        TraitJJvmModelUtilTest.this.assertFieldRepresentation(_get_1, "Object f3");
                      }
                    };
                  ObjectExtensions.<Iterable<JvmOperation>>operator_doubleArrow(_jvmAllFieldOperations, _function);
                }
              };
            ObjectExtensions.<List<TJTraitReference>>operator_doubleArrow(_traitReferences, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
      CharSequence _traitRenameField = this._traitJInputs.traitRenameField();
      TJProgram _parse_1 = this._parseHelper.parse(_traitRenameField);
      final Procedure1<TJProgram> _function_1 = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[2];
            TJTraitExpression _traitExpression = _get.getTraitExpression();
            List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
            final Procedure1<List<TJTraitReference>> _function = new Procedure1<List<TJTraitReference>>() {
                public void apply(final List<TJTraitReference> it) {
                  TJTraitReference _get = it.get(0);
                  Iterable<JvmOperation> _jvmAllFieldOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllFieldOperations(_get);
                  final Procedure1<Iterable<JvmOperation>> _function = new Procedure1<Iterable<JvmOperation>>() {
                      public void apply(final Iterable<JvmOperation> it) {
                        JvmOperation _get = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
                        TraitJJvmModelUtilTest.this.assertFieldRepresentation(_get, "boolean b");
                      }
                    };
                  ObjectExtensions.<Iterable<JvmOperation>>operator_doubleArrow(_jvmAllFieldOperations, _function);
                }
              };
            ObjectExtensions.<List<TJTraitReference>>operator_doubleArrow(_traitReferences, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse_1, _function_1);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testMethodRepresentation() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.append("import java.util.Set");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m(List<String> l, Object o);");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Set<? extends String> n() { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      Iterable<TJTrait> _traits = TraitJModelUtil.traits(_parse);
      TJTrait _head = IterableExtensions.<TJTrait>head(_traits);
      Iterable<JvmOperation> _jvmAllOperations = this._traitJJvmModelUtil.jvmAllOperations(_head);
      final Procedure1<Iterable<JvmOperation>> _function = new Procedure1<Iterable<JvmOperation>>() {
          public void apply(final Iterable<JvmOperation> it) {
            JvmOperation _get = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
            TraitJJvmModelUtilTest.this.assertMethodRepresentation(_get, "Set<? extends String> n()");
            JvmOperation _get_1 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[1];
            TraitJJvmModelUtilTest.this.assertMethodRepresentation(_get_1, "int m(List<String>, Object)");
          }
        };
      ObjectExtensions.<Iterable<JvmOperation>>operator_doubleArrow(_jvmAllOperations, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testMemberRepresentation() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.append("import java.util.Set");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m(List<String> l, Object o);");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Set<? extends String> f;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      Iterable<TJTrait> _traits = TraitJModelUtil.traits(_parse);
      TJTrait _head = IterableExtensions.<TJTrait>head(_traits);
      final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
          public void apply(final TJTrait it) {
            Iterable<JvmOperation> _jvmAllRequiredMethodOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(it);
            JvmOperation _get = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredMethodOperations, JvmOperation.class))[0];
            TraitJJvmModelUtilTest.this.assertMemberRepresentation(_get, "int m(List<String>, Object)");
            Iterable<JvmOperation> _jvmAllFieldOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllFieldOperations(it);
            JvmOperation _get_1 = ((JvmOperation[])Conversions.unwrapArray(_jvmAllFieldOperations, JvmOperation.class))[0];
            TraitJJvmModelUtilTest.this.assertMemberRepresentation(_get_1, "Set<? extends String> f");
          }
        };
      ObjectExtensions.<TJTrait>operator_doubleArrow(_head, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassRequiredFields() {
    try {
      CharSequence _classUsesTraitWithDependencies = this._traitJInputs.classUsesTraitWithDependencies();
      TJProgram _parse = this._parseHelper.parse(_classUsesTraitWithDependencies);
      Iterable<TJClass> _classes = TraitJModelUtil.classes(_parse);
      TJClass _head = IterableExtensions.<TJClass>head(_classes);
      this.assertAllRequiredFieldOperations(_head, "String f, Object f1, Object f3, Object f2, Object f4, Object f5");
      CharSequence _classUsesTraitWithRenamedFields = this._traitJInputs.classUsesTraitWithRenamedFields();
      TJProgram _parse_1 = this._parseHelper.parse(_classUsesTraitWithRenamedFields);
      Iterable<TJClass> _classes_1 = TraitJModelUtil.classes(_parse_1);
      TJClass _head_1 = IterableExtensions.<TJClass>head(_classes_1);
      this.assertAllRequiredFieldOperations(_head_1, "boolean b, String s");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitAllJvmRequiredMethods() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T uses T1 {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T1 uses T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object req1();");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object req2();");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            TJTraitExpression _traitExpression = _get.getTraitExpression();
            TraitJJvmModelUtilTest.this.assertJvmRequiredMethodOperations(_traitExpression, "req1, req2");
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitAllJvmRequiredMethodsWhenRenamed() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      CharSequence _traitRenameRequiredMethods = this._traitJInputs.traitRenameRequiredMethods();
      _builder.append(_traitRenameRequiredMethods, "");
      _builder.newLineIfNotEmpty();
      _builder.newLine();
      _builder.append("trait T4 uses T3 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _last = IterableExtensions.<TJTrait>last(_traits);
            TJTraitExpression _traitExpression = _last.getTraitExpression();
            TraitJJvmModelUtilTest.this.assertJvmRequiredMethodOperations(_traitExpression, "req");
            Iterable<TJTrait> _traits_1 = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits_1, TJTrait.class))[1];
            TJTraitExpression _traitExpression_1 = _get.getTraitExpression();
            TraitJJvmModelUtilTest.this.assertJvmRequiredMethodOperations(_traitExpression_1, "req1");
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassAllJvmRequiredMethodsWhenRenamed() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      CharSequence _traitRenameRequiredMethods = this._traitJInputs.traitRenameRequiredMethods();
      _builder.append(_traitRenameRequiredMethods, "");
      _builder.newLineIfNotEmpty();
      _builder.newLine();
      _builder.append("class C uses T3 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      Iterable<TJClass> _classes = TraitJModelUtil.classes(_parse);
      TJClass _head = IterableExtensions.<TJClass>head(_classes);
      this.assertJvmRequiredMethodOperations(_head, "req");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFindMatchingField() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String o;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int j;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.append("class C1 uses T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String o;");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            Iterable<TJClass> _classes = TraitJModelUtil.classes(it);
            TJClass _head = IterableExtensions.<TJClass>head(_classes);
            final Procedure1<TJClass> _function = new Procedure1<TJClass>() {
                public void apply(final TJClass it) {
                  EList<TJField> _fields = it.getFields();
                  Iterable<JvmOperation> _jvmAllRequiredFieldOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredFieldOperations(it);
                  JvmOperation _get = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredFieldOperations, JvmOperation.class))[0];
                  EList<TJField> _fields_1 = it.getFields();
                  TJField _get_1 = _fields_1.get(1);
                  TraitJJvmModelUtilTest.this.assertFoundField(_fields, _get, _get_1);
                  EList<TJField> _fields_2 = it.getFields();
                  Iterable<JvmOperation> _jvmAllRequiredFieldOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredFieldOperations(it);
                  JvmOperation _get_2 = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredFieldOperations_1, JvmOperation.class))[1];
                  TraitJJvmModelUtilTest.this.assertFoundField(_fields_2, _get_2, null);
                }
              };
            ObjectExtensions.<TJClass>operator_doubleArrow(_head, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFindMatchingFieldWithRenamedField() {
    try {
      CharSequence _classUsesTraitWithRenamedFields = this._traitJInputs.classUsesTraitWithRenamedFields();
      TJProgram _parse = this._parseHelper.parse(_classUsesTraitWithRenamedFields);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            Iterable<TJClass> _classes = TraitJModelUtil.classes(it);
            TJClass _head = IterableExtensions.<TJClass>head(_classes);
            final Procedure1<TJClass> _function = new Procedure1<TJClass>() {
                public void apply(final TJClass it) {
                  EList<TJField> _fields = it.getFields();
                  Iterable<JvmOperation> _jvmAllRequiredFieldOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredFieldOperations(it);
                  JvmOperation _get = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredFieldOperations, JvmOperation.class))[0];
                  EList<TJField> _fields_1 = it.getFields();
                  TJField _get_1 = _fields_1.get(0);
                  TraitJJvmModelUtilTest.this.assertFoundField(_fields, _get, _get_1);
                  EList<TJField> _fields_2 = it.getFields();
                  Iterable<JvmOperation> _jvmAllRequiredFieldOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredFieldOperations(it);
                  JvmOperation _get_2 = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredFieldOperations_1, JvmOperation.class))[1];
                  EList<TJField> _fields_3 = it.getFields();
                  TJField _get_3 = _fields_3.get(1);
                  TraitJJvmModelUtilTest.this.assertFoundField(_fields_2, _get_2, _get_3);
                }
              };
            ObjectExtensions.<TJClass>operator_doubleArrow(_head, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFindMatchingMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m();");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n();");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m() { 0 }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C1 uses T1, T2 {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            final Iterable<TJTrait> traits = TraitJModelUtil.traits(it);
            Iterable<TJClass> _classes = TraitJModelUtil.classes(it);
            TJClass _head = IterableExtensions.<TJClass>head(_classes);
            final Procedure1<TJClass> _function = new Procedure1<TJClass>() {
                public void apply(final TJClass it) {
                  Iterable<JvmOperation> _jvmAllMethodOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllMethodOperations(it);
                  Iterable<JvmOperation> _jvmAllRequiredMethodOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(it);
                  JvmOperation _get = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredMethodOperations, JvmOperation.class))[0];
                  TJTrait _get_1 = ((TJTrait[])Conversions.unwrapArray(traits, TJTrait.class))[1];
                  Iterable<TJMethod> _methods = TraitJModelUtil.methods(_get_1);
                  TJMethod _head = IterableExtensions.<TJMethod>head(_methods);
                  TraitJJvmModelUtilTest.this.assertFoundMethod(_jvmAllMethodOperations, _get, _head);
                  Iterable<JvmOperation> _jvmAllMethodOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllMethodOperations(it);
                  Iterable<JvmOperation> _jvmAllRequiredMethodOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(it);
                  JvmOperation _get_2 = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredMethodOperations_1, JvmOperation.class))[1];
                  TraitJJvmModelUtilTest.this.assertFoundMethod(_jvmAllMethodOperations_1, _get_2, null);
                }
              };
            ObjectExtensions.<TJClass>operator_doubleArrow(_head, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFindMatchingMethodWithSubtypeReturn() {
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
      _builder.append("List<? extends String> m();");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<String> n();");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("// this fulfills T1\'s m requirement");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("// since ArrayList<String> <: List<? extends String>");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("ArrayList<String> m() { return null; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("// this won\'t fulfill T1\'s n requirement");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("// since List<? extends String> is NOT <: List<String>");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<? extends String> n() { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C1 uses T1, T2 {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            final Iterable<TJTrait> traits = TraitJModelUtil.traits(it);
            Iterable<TJClass> _classes = TraitJModelUtil.classes(it);
            TJClass _head = IterableExtensions.<TJClass>head(_classes);
            final Procedure1<TJClass> _function = new Procedure1<TJClass>() {
                public void apply(final TJClass it) {
                  Iterable<JvmOperation> _jvmAllMethodOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllMethodOperations(it);
                  Iterable<JvmOperation> _jvmAllRequiredMethodOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(it);
                  JvmOperation _get = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredMethodOperations, JvmOperation.class))[0];
                  TJTrait _get_1 = ((TJTrait[])Conversions.unwrapArray(traits, TJTrait.class))[1];
                  Iterable<TJMethod> _methods = TraitJModelUtil.methods(_get_1);
                  TJMethod _head = IterableExtensions.<TJMethod>head(_methods);
                  TraitJJvmModelUtilTest.this.assertFoundMethod(_jvmAllMethodOperations, _get, _head);
                  Iterable<JvmOperation> _jvmAllMethodOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllMethodOperations(it);
                  Iterable<JvmOperation> _jvmAllRequiredMethodOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(it);
                  JvmOperation _get_2 = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredMethodOperations_1, JvmOperation.class))[1];
                  TraitJJvmModelUtilTest.this.assertFoundMethod(_jvmAllMethodOperations_1, _get_2, null);
                }
              };
            ObjectExtensions.<TJClass>operator_doubleArrow(_head, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFindMatchingMethodWhenRenamed() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m1();");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n();");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m() { 0 }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T2[rename m to m1], T1 {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C1 uses T3 {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            final Iterable<TJTrait> traits = TraitJModelUtil.traits(it);
            Iterable<TJClass> _classes = TraitJModelUtil.classes(it);
            TJClass _head = IterableExtensions.<TJClass>head(_classes);
            final Procedure1<TJClass> _function = new Procedure1<TJClass>() {
                public void apply(final TJClass it) {
                  final Iterable<JvmOperation> ops = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllMethodOperations(it);
                  TJTrait _get = ((TJTrait[])Conversions.unwrapArray(traits, TJTrait.class))[0];
                  Iterable<JvmOperation> _jvmAllRequiredMethodOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(_get);
                  JvmOperation _get_1 = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredMethodOperations, JvmOperation.class))[0];
                  TJTrait _get_2 = ((TJTrait[])Conversions.unwrapArray(traits, TJTrait.class))[1];
                  Iterable<TJMethod> _methods = TraitJModelUtil.methods(_get_2);
                  TJMethod _head = IterableExtensions.<TJMethod>head(_methods);
                  TraitJJvmModelUtilTest.this.assertFoundMethod(ops, _get_1, _head);
                  Iterable<JvmOperation> _jvmAllMethodOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllMethodOperations(it);
                  TJTrait _get_3 = ((TJTrait[])Conversions.unwrapArray(traits, TJTrait.class))[0];
                  Iterable<JvmOperation> _jvmAllRequiredMethodOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(_get_3);
                  JvmOperation _get_4 = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredMethodOperations_1, JvmOperation.class))[1];
                  TraitJJvmModelUtilTest.this.assertFoundMethod(_jvmAllMethodOperations, _get_4, null);
                }
              };
            ObjectExtensions.<TJClass>operator_doubleArrow(_head, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFindMatchingMethodWhenRenamed2() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m1();");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String n();");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m() { 0 }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T3 uses T1, T2[rename m to m1] {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C1 uses T3 {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            final Iterable<TJTrait> traits = TraitJModelUtil.traits(it);
            Iterable<TJClass> _classes = TraitJModelUtil.classes(it);
            TJClass _head = IterableExtensions.<TJClass>head(_classes);
            final Procedure1<TJClass> _function = new Procedure1<TJClass>() {
                public void apply(final TJClass it) {
                  final Iterable<JvmOperation> ops = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllMethodOperations(it);
                  TJTrait _get = ((TJTrait[])Conversions.unwrapArray(traits, TJTrait.class))[0];
                  Iterable<JvmOperation> _jvmAllRequiredMethodOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(_get);
                  JvmOperation _get_1 = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredMethodOperations, JvmOperation.class))[0];
                  TJTrait _get_2 = ((TJTrait[])Conversions.unwrapArray(traits, TJTrait.class))[1];
                  Iterable<TJMethod> _methods = TraitJModelUtil.methods(_get_2);
                  TJMethod _head = IterableExtensions.<TJMethod>head(_methods);
                  TraitJJvmModelUtilTest.this.assertFoundMethod(ops, _get_1, _head);
                  Iterable<JvmOperation> _jvmAllMethodOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllMethodOperations(it);
                  TJTrait _get_3 = ((TJTrait[])Conversions.unwrapArray(traits, TJTrait.class))[0];
                  Iterable<JvmOperation> _jvmAllRequiredMethodOperations_1 = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(_get_3);
                  JvmOperation _get_4 = ((JvmOperation[])Conversions.unwrapArray(_jvmAllRequiredMethodOperations_1, JvmOperation.class))[1];
                  TraitJJvmModelUtilTest.this.assertFoundMethod(_jvmAllMethodOperations, _get_4, null);
                }
              };
            ObjectExtensions.<TJClass>operator_doubleArrow(_head, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSourceMethod() {
    try {
      CharSequence _traitDependency = this._traitJInputs.traitDependency();
      TJProgram _parse = this._parseHelper.parse(_traitDependency);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "m", "String m()");
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "t1", "Object t1()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSourceRenamedMethod() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      CharSequence _traitRenameOperations = this._traitJInputs.traitRenameOperations();
      _builder.append(_traitRenameOperations, "");
      _builder.newLineIfNotEmpty();
      _builder.newLine();
      _builder.append("trait T4 uses T3 {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[2];
            final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "m2", "int m()");
                  TraitJJvmModelUtilTest.this.assertSourceRequiredMethod(it, "n2", "int n()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get, _function);
            Iterable<TJTrait> _traits_1 = TraitJModelUtil.traits(it);
            TJTrait _get_1 = ((TJTrait[])Conversions.unwrapArray(_traits_1, TJTrait.class))[3];
            final Procedure1<TJTrait> _function_1 = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "m2", "int m()");
                  TraitJJvmModelUtilTest.this.assertSourceRequiredMethod(it, "n2", "int n()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get_1, _function_1);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSourceRenameRenamedMethod() {
    try {
      CharSequence _traitRenameRenamed = this._traitJInputs.traitRenameRenamed();
      TJProgram _parse = this._parseHelper.parse(_traitRenameRenamed);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[1];
            final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "firstRename", "String m()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get, _function);
            Iterable<TJTrait> _traits_1 = TraitJModelUtil.traits(it);
            TJTrait _get_1 = ((TJTrait[])Conversions.unwrapArray(_traits_1, TJTrait.class))[2];
            final Procedure1<TJTrait> _function_1 = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "secondRename", "String m()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get_1, _function_1);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSourceMethodWhenSplitInTwoFiles() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T1 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String m() { return null; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      Resource _eResource = _parse.eResource();
      final ResourceSet rs = _eResource.getResourceSet();
      StringConcatenation _builder_1 = new StringConcatenation();
      _builder_1.append("trait T2 uses T1[alias m as newM] {");
      _builder_1.newLine();
      _builder_1.append("\t");
      _builder_1.newLine();
      _builder_1.append("}");
      _builder_1.newLine();
      TJProgram _parse_1 = this._parseHelper.parse(_builder_1, rs);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[0];
            final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "newM", "String m()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse_1, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSourceRequiredMethodProvidedBySum() {
    try {
      CharSequence _traitRequiredMethodProvidedBySum = this._traitJInputs.traitRequiredMethodProvidedBySum();
      TJProgram _parse = this._parseHelper.parse(_traitRequiredMethodProvidedBySum);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[2];
            final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "m1", "int m1()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSourceRequiredMethodProvidedBySum2() {
    try {
      CharSequence _traitRequiredMethodProvidedBySum2 = this._traitJInputs.traitRequiredMethodProvidedBySum2();
      TJProgram _parse = this._parseHelper.parse(_traitRequiredMethodProvidedBySum2);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[2];
            final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "m1", "int m1()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSourceRenamedMethodAndSum() {
    try {
      CharSequence _traitRenameProvidedMethodToRequiredAndSum = this._traitJInputs.traitRenameProvidedMethodToRequiredAndSum();
      TJProgram _parse = this._parseHelper.parse(_traitRenameProvidedMethodToRequiredAndSum);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[2];
            final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "m1", "int m()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSourceRenamedMethodAndSum2() {
    try {
      CharSequence _traitRenameProvidedMethodToRequiredAndSum2 = this._traitJInputs.traitRenameProvidedMethodToRequiredAndSum2();
      TJProgram _parse = this._parseHelper.parse(_traitRenameProvidedMethodToRequiredAndSum2);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _get = ((TJTrait[])Conversions.unwrapArray(_traits, TJTrait.class))[2];
            final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
                public void apply(final TJTrait it) {
                  TraitJJvmModelUtilTest.this.assertSourceMethod(it, "m1", "int m()");
                }
              };
            ObjectExtensions.<TJTrait>operator_doubleArrow(_get, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testRestrictedConsideredRequired() {
    try {
      CharSequence _traitRestrict = this._traitJInputs.traitRestrict();
      TJProgram _parse = this._parseHelper.parse(_traitRestrict);
      final Procedure1<TJProgram> _function = new Procedure1<TJProgram>() {
          public void apply(final TJProgram it) {
            TraitJJvmModelUtilTest.this._validationTestHelper.assertNoErrors(it);
            Iterable<TJTrait> _traits = TraitJModelUtil.traits(it);
            TJTrait _last = IterableExtensions.<TJTrait>last(_traits);
            TJTraitExpression _traitExpression = _last.getTraitExpression();
            EList<TJTraitReference> _references = _traitExpression.getReferences();
            TJTraitReference _head = IterableExtensions.<TJTraitReference>head(_references);
            Iterable<JvmOperation> _jvmAllOperations = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.jvmAllOperations(_head);
            final Procedure1<Iterable<JvmOperation>> _function = new Procedure1<Iterable<JvmOperation>>() {
                public void apply(final Iterable<JvmOperation> it) {
                  JvmOperation _memberByName = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.memberByName(it, "m");
                  TraitJJvmModelUtilTest.this.assertRequired(_memberByName, true);
                }
              };
            ObjectExtensions.<Iterable<JvmOperation>>operator_doubleArrow(_jvmAllOperations, _function);
          }
        };
      ObjectExtensions.<TJProgram>operator_doubleArrow(_parse, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSourceRestricted() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T uses T1 {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T1 uses T2[ restrict m ] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object m() { null }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      Iterable<TJTrait> _traits = TraitJModelUtil.traits(_parse);
      TJTrait _head = IterableExtensions.<TJTrait>head(_traits);
      this.assertSourceRestricted(_head, "m");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitAllJvmRequiredMethodsWithRestricted() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("trait T uses T1 {}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T1 uses T2[ restrict m ] {");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T2 {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object m() { null }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      Iterable<TJTrait> _traits = TraitJModelUtil.traits(_parse);
      TJTrait _head = IterableExtensions.<TJTrait>head(_traits);
      this.assertJvmRequiredMethodOperations(_head, "m");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassJvmAllMethods() {
    try {
      CharSequence _classUsesTraitWithDependencies = this._traitJInputs.classUsesTraitWithDependencies();
      TJProgram _parse = this._parseHelper.parse(_classUsesTraitWithDependencies);
      Iterable<TJClass> _classes = TraitJModelUtil.classes(_parse);
      TJClass _head = IterableExtensions.<TJClass>head(_classes);
      Iterable<JvmOperation> _jvmAllMethods = this._traitJJvmModelUtil.jvmAllMethods(_head);
      final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
          public String apply(final JvmOperation it) {
            String _simpleName = it.getSimpleName();
            return _simpleName;
          }
        };
      Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllMethods, _function);
      List<String> _list = IterableExtensions.<String>toList(_map);
      final Procedure1<List<String>> _function_1 = new Procedure1<List<String>>() {
          public void apply(final List<String> it) {
            boolean _contains = it.contains("m");
            Assert.assertTrue(_contains);
            boolean _contains_1 = it.contains("t1");
            Assert.assertTrue(_contains_1);
            boolean _contains_2 = it.contains("notify");
            Assert.assertTrue(_contains_2);
            boolean _contains_3 = it.contains("wait");
            Assert.assertTrue(_contains_3);
          }
        };
      ObjectExtensions.<List<String>>operator_doubleArrow(_list, _function_1);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testClassJvmAllInterfaceMethods() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("class C implements java.util.List {}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      Iterable<TJClass> _classes = TraitJModelUtil.classes(_parse);
      TJClass _head = IterableExtensions.<TJClass>head(_classes);
      Iterable<JvmOperation> _jvmAllInterfaceMethods = this._traitJJvmModelUtil.jvmAllInterfaceMethods(_head);
      final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
          public String apply(final JvmOperation it) {
            String _simpleName = it.getSimpleName();
            return _simpleName;
          }
        };
      Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllInterfaceMethods, _function);
      List<String> _list = IterableExtensions.<String>toList(_map);
      final Procedure1<List<String>> _function_1 = new Procedure1<List<String>>() {
          public void apply(final List<String> it) {
            boolean _contains = it.contains("listIterator");
            Assert.assertTrue(_contains);
            boolean _contains_1 = it.contains("add");
            Assert.assertTrue(_contains_1);
            boolean _contains_2 = it.contains("removeAll");
            Assert.assertTrue(_contains_2);
            boolean _contains_3 = it.contains("notify");
            Assert.assertFalse(_contains_3);
          }
        };
      ObjectExtensions.<List<String>>operator_doubleArrow(_list, _function_1);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testCompliant() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.newLine();
      _builder.append("trait T {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int m(List<String> l) { return 0; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int n(List<String> l) { return 0; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int o(List<String> l, int j) { return 0; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("boolean p(List<String> l) { return false; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int q(List<Integer> l) { return 0; }");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int r(List<? extends String> l) { return 0; }");
      _builder.newLine();
      _builder.append("}");
      _builder.newLine();
      TJProgram _parse = this._parseHelper.parse(_builder);
      Iterable<TJTrait> _traits = TraitJModelUtil.traits(_parse);
      TJTrait _head = IterableExtensions.<TJTrait>head(_traits);
      Iterable<JvmOperation> _jvmAllOperations = this._traitJJvmModelUtil.jvmAllOperations(_head);
      final Procedure1<Iterable<JvmOperation>> _function = new Procedure1<Iterable<JvmOperation>>() {
          public void apply(final Iterable<JvmOperation> it) {
            JvmOperation _get = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
            JvmOperation _get_1 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
            TraitJJvmModelUtilTest.this.assertCompliant(_get, _get_1, true);
            JvmOperation _get_2 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[1];
            JvmOperation _get_3 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
            TraitJJvmModelUtilTest.this.assertCompliant(_get_2, _get_3, true);
            JvmOperation _get_4 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[2];
            JvmOperation _get_5 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
            TraitJJvmModelUtilTest.this.assertCompliant(_get_4, _get_5, false);
            JvmOperation _get_6 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[3];
            JvmOperation _get_7 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
            TraitJJvmModelUtilTest.this.assertCompliant(_get_6, _get_7, false);
            JvmOperation _get_8 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[4];
            JvmOperation _get_9 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
            TraitJJvmModelUtilTest.this.assertCompliant(_get_8, _get_9, false);
            JvmOperation _get_10 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[5];
            JvmOperation _get_11 = ((JvmOperation[])Conversions.unwrapArray(it, JvmOperation.class))[0];
            TraitJJvmModelUtilTest.this.assertCompliant(_get_10, _get_11, false);
          }
        };
      ObjectExtensions.<Iterable<JvmOperation>>operator_doubleArrow(_jvmAllOperations, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  private void assertAssociatedInterface(final TJTrait o, final String expectedName) {
    JvmParameterizedTypeReference _associatedInterface = this._traitJJvmModelUtil.associatedInterface(o);
    String _simpleName = _associatedInterface.getSimpleName();
    Assert.assertEquals(expectedName, _simpleName);
  }
  
  private void assertAssociatedClass(final TJTrait o, final String expectedName) {
    JvmParameterizedTypeReference _associatedClass = this._traitJJvmModelUtil.associatedClass(o);
    String _simpleName = _associatedClass.getSimpleName();
    Assert.assertEquals(expectedName, _simpleName);
  }
  
  private void assertAssociatedInterface(final TJTraitExpression o, final String expectedName) {
    EList<TJTraitReference> _references = o.getReferences();
    TJTraitReference _head = IterableExtensions.<TJTraitReference>head(_references);
    this.assertAssociatedInterface(_head, expectedName);
  }
  
  private void assertAssociatedInterface(final TJTraitReference o, final String expectedName) {
    JvmParameterizedTypeReference _associatedInterface = this._traitJJvmModelUtil.associatedInterface(o);
    String _simpleName = _associatedInterface.getSimpleName();
    Assert.assertEquals(expectedName, _simpleName);
  }
  
  private void assertJvmFeatures(final TJTrait o, final String expected) {
    Iterable<JvmFeature> _jvmAllFeatures = this._traitJJvmModelUtil.jvmAllFeatures(o);
    final Function1<JvmFeature,String> _function = new Function1<JvmFeature,String>() {
        public String apply(final JvmFeature it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmFeature, String>map(_jvmAllFeatures, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmOperations(final TJTrait o, final String expected) {
    Iterable<JvmOperation> _jvmAllOperations = this._traitJJvmModelUtil.jvmAllOperations(o);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmOperations(final TJTraitReference o, final String expected) {
    Iterable<JvmOperation> _jvmAllOperations = this._traitJJvmModelUtil.jvmAllOperations(o);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmFeatures(final TJTraitReference o, final String expected) {
    Iterable<JvmFeature> _jvmAllFeatures = this._traitJJvmModelUtil.jvmAllFeatures(o);
    final Function1<JvmFeature,String> _function = new Function1<JvmFeature,String>() {
        public String apply(final JvmFeature it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmFeature, String>map(_jvmAllFeatures, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmMethodOperations(final TJTraitReference o, final String expected) {
    Iterable<JvmOperation> _jvmAllMethodOperations = this._traitJJvmModelUtil.jvmAllMethodOperations(o);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllMethodOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmMethodOperations(final TJClass o, final String expected) {
    Iterable<JvmOperation> _jvmAllMethodOperations = this._traitJJvmModelUtil.jvmAllMethodOperations(o);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllMethodOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmFieldsOperations(final TJTraitReference o, final String expected) {
    Iterable<JvmOperation> _jvmAllFieldOperations = this._traitJJvmModelUtil.jvmAllFieldOperations(o);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllFieldOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmRequiredFieldOperations(final TJTraitReference o, final String expected) {
    Iterable<JvmOperation> _jvmAllRequiredFieldOperations = this._traitJJvmModelUtil.jvmAllRequiredFieldOperations(o);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllRequiredFieldOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmRequiredMethodOperations(final TJTraitExpression o, final String expected) {
    EList<TJTraitReference> _references = o.getReferences();
    TJTraitReference _head = IterableExtensions.<TJTraitReference>head(_references);
    this.assertJvmRequiredMethodOperations(_head, expected);
  }
  
  private void assertJvmRequiredMethodOperations(final TJTraitReference o, final String expected) {
    Iterable<JvmOperation> _jvmAllRequiredMethodOperations = this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(o);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllRequiredMethodOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmRequiredMethodOperations(final TJTrait o, final String expected) {
    Iterable<JvmOperation> _jvmAllRequiredMethodOperations = this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(o);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllRequiredMethodOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertJvmRequiredMethodOperations(final TJClass o, final String expected) {
    Iterable<JvmOperation> _jvmAllRequiredMethodOperations = this._traitJJvmModelUtil.jvmAllRequiredMethodOperations(o);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          return _simpleName;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllRequiredMethodOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertRequired(final JvmMember m, final boolean expected) {
    Assert.assertNotNull("member is null", m);
    boolean _isRequired = this._traitJJvmModelUtil.isRequired(m);
    Assert.assertEquals(Boolean.valueOf(expected), Boolean.valueOf(_isRequired));
  }
  
  private void assertMemberRepresentation(final JvmMember o, final String expected) {
    String _memberRepresentation = this._traitJJvmModelUtil.memberRepresentation(o);
    Assert.assertEquals(expected, _memberRepresentation);
  }
  
  private void assertFieldRepresentation(final JvmOperation o, final String expected) {
    String _fieldRepresentation = this._traitJJvmModelUtil.fieldRepresentation(o);
    Assert.assertEquals(expected, _fieldRepresentation);
  }
  
  private void assertMethodRepresentation(final JvmOperation o, final String expected) {
    String _methodRepresentation = this._traitJJvmModelUtil.methodRepresentation(o);
    Assert.assertEquals(expected, _methodRepresentation);
  }
  
  private void assertAllRequiredFieldOperations(final TJClass c, final String expected) {
    Iterable<JvmOperation> _jvmAllRequiredFieldOperations = this._traitJJvmModelUtil.jvmAllRequiredFieldOperations(c);
    final Function1<JvmOperation,String> _function = new Function1<JvmOperation,String>() {
        public String apply(final JvmOperation it) {
          String _fieldRepresentation = TraitJJvmModelUtilTest.this._traitJJvmModelUtil.fieldRepresentation(it);
          return _fieldRepresentation;
        }
      };
    Iterable<String> _map = IterableExtensions.<JvmOperation, String>map(_jvmAllRequiredFieldOperations, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertFoundField(final Iterable<? extends TJField> fields, final JvmOperation member, final TJField expected) {
    TJField _findMatchingField = this._traitJJvmModelUtil.findMatchingField(fields, member);
    Assert.assertSame(expected, _findMatchingField);
  }
  
  private void assertFoundMethod(final Iterable<? extends JvmOperation> operations, final JvmOperation member, final TJMethod expected) {
    JvmOperation _findMatchingMethod = this._traitJJvmModelUtil.findMatchingMethod(operations, member);
    TJMethod _sourceMethod = this._traitJJvmModelUtil.sourceMethod(_findMatchingMethod);
    Assert.assertSame(expected, _sourceMethod);
  }
  
  private void assertSourceMethod(final TJTrait e, final String name, final String expected) {
    Iterable<JvmFeature> __jvmAllFeatures = this._traitJJvmModelUtil._jvmAllFeatures(e);
    final Function1<JvmFeature,Boolean> _function = new Function1<JvmFeature,Boolean>() {
        public Boolean apply(final JvmFeature it) {
          String _simpleName = it.getSimpleName();
          boolean _equals = Objects.equal(_simpleName, name);
          return Boolean.valueOf(_equals);
        }
      };
    JvmFeature _findFirst = IterableExtensions.<JvmFeature>findFirst(__jvmAllFeatures, _function);
    TJMethod _sourceMethod = this._traitJJvmModelUtil.sourceMethod(_findFirst);
    String _representationWithTypes = TraitJModelUtil.representationWithTypes(_sourceMethod);
    Assert.assertEquals(expected, _representationWithTypes);
  }
  
  private void assertSourceRequiredMethod(final TJTrait e, final String name, final String expected) {
    Iterable<JvmFeature> __jvmAllFeatures = this._traitJJvmModelUtil._jvmAllFeatures(e);
    final Function1<JvmFeature,Boolean> _function = new Function1<JvmFeature,Boolean>() {
        public Boolean apply(final JvmFeature it) {
          String _simpleName = it.getSimpleName();
          boolean _equals = Objects.equal(_simpleName, name);
          return Boolean.valueOf(_equals);
        }
      };
    JvmFeature _findFirst = IterableExtensions.<JvmFeature>findFirst(__jvmAllFeatures, _function);
    TJRequiredMethod _sourceRequiredMethod = this._traitJJvmModelUtil.sourceRequiredMethod(_findFirst);
    String _representationWithTypes = TraitJModelUtil.representationWithTypes(_sourceRequiredMethod);
    Assert.assertEquals(expected, _representationWithTypes);
  }
  
  private void assertSourceRestricted(final TJTrait e, final String name) {
    Iterable<JvmFeature> __jvmAllFeatures = this._traitJJvmModelUtil._jvmAllFeatures(e);
    final Function1<JvmFeature,Boolean> _function = new Function1<JvmFeature,Boolean>() {
        public Boolean apply(final JvmFeature it) {
          String _simpleName = it.getSimpleName();
          boolean _equals = Objects.equal(_simpleName, name);
          return Boolean.valueOf(_equals);
        }
      };
    JvmFeature _findFirst = IterableExtensions.<JvmFeature>findFirst(__jvmAllFeatures, _function);
    TJRestrictOperation _sourceRestricted = this._traitJJvmModelUtil.sourceRestricted(_findFirst);
    JvmMember _member = _sourceRestricted.getMember();
    String _simpleName = _member.getSimpleName();
    Assert.assertEquals(name, _simpleName);
  }
  
  private void assertCompliant(final JvmOperation o1, final JvmOperation o2, final boolean expectedTrue) {
    String _memberRepresentation = this._traitJJvmModelUtil.memberRepresentation(o1);
    String _plus = (_memberRepresentation + " compliant to ");
    String _memberRepresentation_1 = this._traitJJvmModelUtil.memberRepresentation(o2);
    String _plus_1 = (_plus + _memberRepresentation_1);
    String _plus_2 = (_plus_1 + 
      " expected ");
    String _plus_3 = (_plus_2 + Boolean.valueOf(expectedTrue));
    boolean _compliant = this._traitJJvmModelUtil.compliant(o1, o2);
    Assert.assertEquals(_plus_3, Boolean.valueOf(expectedTrue), Boolean.valueOf(_compliant));
  }
}

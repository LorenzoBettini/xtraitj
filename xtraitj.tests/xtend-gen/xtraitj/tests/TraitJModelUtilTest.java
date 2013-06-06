package xtraitj.tests;

import com.google.inject.Inject;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.eclipse.xtext.junit4.util.ParseHelper;
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
import xtraitj.util.TraitJModelUtil;
import xtraitj.xtraitj.TJClass;
import xtraitj.xtraitj.TJField;
import xtraitj.xtraitj.TJMethod;
import xtraitj.xtraitj.TJMethodDeclaration;
import xtraitj.xtraitj.TJProgram;
import xtraitj.xtraitj.TJRequiredMethod;
import xtraitj.xtraitj.TJTrait;
import xtraitj.xtraitj.TJTraitExpression;
import xtraitj.xtraitj.TJTraitReference;

@RunWith(XtextRunner.class)
@InjectWith(XtraitjInjectorProvider.class)
@SuppressWarnings("all")
public class TraitJModelUtilTest {
  @Inject
  @Extension
  private ParseHelper<TJProgram> _parseHelper;
  
  @Test
  public void testMethodsForAtomicTraitExpression() {
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
      Iterable<TJTrait> _traits = TraitJModelUtil.traits(_parse);
      TJTrait _head = IterableExtensions.<TJTrait>head(_traits);
      TJTraitExpression _traitExpression = _head.getTraitExpression();
      this.assertMethods(_traitExpression, "m");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testFieldRepresentationWithTypes() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.append("import java.util.Set");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object o;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<String> l;");
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
      Iterable<TJClass> _classes = TraitJModelUtil.classes(_parse);
      TJClass _head = IterableExtensions.<TJClass>head(_classes);
      EList<TJField> _fields = _head.getFields();
      final Procedure1<EList<TJField>> _function = new Procedure1<EList<TJField>>() {
          public void apply(final EList<TJField> it) {
            TJField _get = it.get(0);
            TraitJModelUtilTest.this.assertRepresentation(_get, "Object o");
            TJField _get_1 = it.get(1);
            TraitJModelUtilTest.this.assertRepresentation(_get_1, "List<String> l");
          }
        };
      ObjectExtensions.<EList<TJField>>operator_doubleArrow(_fields, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testMethodRepresentationWithTypes() {
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
      final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
          public void apply(final TJTrait it) {
            Iterable<TJRequiredMethod> _requiredMethods = TraitJModelUtil.requiredMethods(it);
            TJRequiredMethod _head = IterableExtensions.<TJRequiredMethod>head(_requiredMethods);
            TraitJModelUtilTest.this.assertRepresentation(_head, "int m(List<String>, Object)");
            Iterable<TJMethod> _methods = TraitJModelUtil.methods(it);
            TJMethod _head_1 = IterableExtensions.<TJMethod>head(_methods);
            TraitJModelUtilTest.this.assertRepresentation(_head_1, "Set<? extends String> n()");
          }
        };
      ObjectExtensions.<TJTrait>operator_doubleArrow(_head, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  private void assertMethods(final TJTraitExpression e, final String expected) {
    EList<TJTraitReference> _references = e.getReferences();
    int _size = _references.size();
    Assert.assertEquals(1, _size);
    EList<TJTraitReference> _references_1 = e.getReferences();
    TJTraitReference _head = IterableExtensions.<TJTraitReference>head(_references_1);
    Iterable<TJMethod> _methods = TraitJModelUtil.methods(_head);
    final Function1<TJMethod,String> _function = new Function1<TJMethod,String>() {
        public String apply(final TJMethod it) {
          String _name = it.getName();
          return _name;
        }
      };
    Iterable<String> _map = IterableExtensions.<TJMethod, String>map(_methods, _function);
    String _join = IterableExtensions.join(_map, ",");
    Assert.assertEquals(expected, _join);
  }
  
  private void assertRepresentation(final TJField f, final String expected) {
    String _representationWithTypes = TraitJModelUtil.representationWithTypes(f);
    Assert.assertEquals(expected, _representationWithTypes);
  }
  
  private void assertRepresentation(final TJMethodDeclaration m, final String expected) {
    String _representationWithTypes = TraitJModelUtil.representationWithTypes(m);
    Assert.assertEquals(expected, _representationWithTypes);
  }
}

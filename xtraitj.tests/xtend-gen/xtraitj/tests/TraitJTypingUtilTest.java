package xtraitj.tests;

import com.google.inject.Inject;
import org.eclipse.emf.common.util.EList;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.eclipse.xtext.junit4.util.ParseHelper;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.XtraitjInjectorProvider;
import xtraitj.typing.TraitJTypingUtil;
import xtraitj.util.TraitJModelUtil;
import xtraitj.xtraitj.TJClass;
import xtraitj.xtraitj.TJField;
import xtraitj.xtraitj.TJMember;
import xtraitj.xtraitj.TJProgram;

@RunWith(XtextRunner.class)
@InjectWith(XtraitjInjectorProvider.class)
@SuppressWarnings("all")
public class TraitJTypingUtilTest {
  @Inject
  @Extension
  private ParseHelper<TJProgram> _parseHelper;
  
  @Inject
  @Extension
  private TraitJTypingUtil _traitJTypingUtil;
  
  @Test
  public void testSameType() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object o1;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object o2;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s1;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<String> ls1;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<String> ls2;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<? extends String> ls3;");
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
            TJField _get_1 = it.get(1);
            TraitJTypingUtilTest.this.assertSameType(_get, _get_1, true);
            TJField _get_2 = it.get(0);
            TJField _get_3 = it.get(2);
            TraitJTypingUtilTest.this.assertSameType(_get_2, _get_3, false);
            TJField _get_4 = it.get(3);
            TJField _get_5 = it.get(4);
            TraitJTypingUtilTest.this.assertSameType(_get_4, _get_5, true);
            TJField _get_6 = it.get(3);
            TJField _get_7 = it.get(5);
            TraitJTypingUtilTest.this.assertSameType(_get_6, _get_7, false);
          }
        };
      ObjectExtensions.<EList<TJField>>operator_doubleArrow(_fields, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSubtype() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("import java.util.List");
      _builder.newLine();
      _builder.append("import java.util.ArrayList");
      _builder.newLine();
      _builder.newLine();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object o1; \t\t\t\t// 0");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Object o2;\t\t\t\t// 1");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("String s1;\t\t\t\t// 2");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<String> ls1;\t\t// 3");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<String> ls2;\t\t// 4");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("List<? extends String> ls3; // 5");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("ArrayList<? extends String> ls4; // 6");
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
            TJField _get_1 = it.get(1);
            TraitJTypingUtilTest.this.assertSubtype(_get, _get_1, true);
            TJField _get_2 = it.get(0);
            TJField _get_3 = it.get(2);
            TraitJTypingUtilTest.this.assertSubtype(_get_2, _get_3, false);
            TJField _get_4 = it.get(3);
            TJField _get_5 = it.get(1);
            TraitJTypingUtilTest.this.assertSubtype(_get_4, _get_5, true);
            TJField _get_6 = it.get(3);
            TJField _get_7 = it.get(4);
            TraitJTypingUtilTest.this.assertSubtype(_get_6, _get_7, true);
            TJField _get_8 = it.get(5);
            TJField _get_9 = it.get(3);
            TraitJTypingUtilTest.this.assertSubtype(_get_8, _get_9, false);
            TJField _get_10 = it.get(3);
            TJField _get_11 = it.get(5);
            TraitJTypingUtilTest.this.assertSubtype(_get_10, _get_11, true);
            TJField _get_12 = it.get(6);
            TJField _get_13 = it.get(5);
            TraitJTypingUtilTest.this.assertSubtype(_get_12, _get_13, true);
          }
        };
      ObjectExtensions.<EList<TJField>>operator_doubleArrow(_fields, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSameTypeWithBasicTypes() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i1;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Integer i2;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i3;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Integer i4;");
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
            TJField _get_1 = it.get(1);
            TraitJTypingUtilTest.this.assertSameType(_get, _get_1, false);
            TJField _get_2 = it.get(1);
            TJField _get_3 = it.get(0);
            TraitJTypingUtilTest.this.assertSameType(_get_2, _get_3, false);
            TJField _get_4 = it.get(0);
            TJField _get_5 = it.get(2);
            TraitJTypingUtilTest.this.assertSameType(_get_4, _get_5, true);
            TJField _get_6 = it.get(1);
            TJField _get_7 = it.get(3);
            TraitJTypingUtilTest.this.assertSameType(_get_6, _get_7, true);
          }
        };
      ObjectExtensions.<EList<TJField>>operator_doubleArrow(_fields, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testSubtypeWithBasicTypes() {
    try {
      StringConcatenation _builder = new StringConcatenation();
      _builder.append("class C {");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i1;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Integer i2;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("int i3;");
      _builder.newLine();
      _builder.append("\t");
      _builder.append("Integer i4;");
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
            TJField _get_1 = it.get(1);
            TraitJTypingUtilTest.this.assertSubtype(_get, _get_1, false);
            TJField _get_2 = it.get(1);
            TJField _get_3 = it.get(0);
            TraitJTypingUtilTest.this.assertSubtype(_get_2, _get_3, false);
            TJField _get_4 = it.get(0);
            TJField _get_5 = it.get(2);
            TraitJTypingUtilTest.this.assertSubtype(_get_4, _get_5, true);
            TJField _get_6 = it.get(1);
            TJField _get_7 = it.get(3);
            TraitJTypingUtilTest.this.assertSubtype(_get_6, _get_7, true);
          }
        };
      ObjectExtensions.<EList<TJField>>operator_doubleArrow(_fields, _function);
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  private void assertSameType(final TJMember m1, final TJMember m2, final boolean mustBeTheSame) {
    final JvmTypeReference t1 = m1.getType();
    final JvmTypeReference t2 = m2.getType();
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("failed expected: ");
    _builder.append(mustBeTheSame, "");
    _builder.append(" - ");
    String _simpleName = t1.getSimpleName();
    _builder.append(_simpleName, "");
    _builder.append(", ");
    String _simpleName_1 = t2.getSimpleName();
    _builder.append(_simpleName_1, "");
    boolean _sameType = this._traitJTypingUtil.sameType(t1, t2);
    Assert.assertEquals(_builder.toString(), Boolean.valueOf(mustBeTheSame), Boolean.valueOf(_sameType));
  }
  
  private void assertSubtype(final TJMember m1, final TJMember m2, final boolean mustBeSubtype) {
    final JvmTypeReference t1 = m1.getType();
    final JvmTypeReference t2 = m2.getType();
    StringConcatenation _builder = new StringConcatenation();
    _builder.append("failed expected: ");
    _builder.append(mustBeSubtype, "");
    _builder.append(" - ");
    String _simpleName = t1.getSimpleName();
    _builder.append(_simpleName, "");
    _builder.append(" <: ");
    String _simpleName_1 = t2.getSimpleName();
    _builder.append(_simpleName_1, "");
    boolean _isSubtype = this._traitJTypingUtil.isSubtype(t1, t2);
    Assert.assertEquals(_builder.toString(), Boolean.valueOf(mustBeSubtype), Boolean.valueOf(_isSubtype));
  }
}

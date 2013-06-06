package xtraitj.tests;

import com.google.common.collect.Iterators;
import com.google.inject.Inject;
import java.util.Iterator;
import org.eclipse.emf.common.util.TreeIterator;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.eclipse.xtext.junit4.util.ParseHelper;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.scoping.IScope;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.Functions.Function0;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.IteratorExtensions;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import xtraitj.XtraitjInjectorProvider;
import xtraitj.input.tests.TraitJInputs;
import xtraitj.scoping.TraitJXbaseBatchScopeProvider;
import xtraitj.xtraitj.TJHideOperation;
import xtraitj.xtraitj.TJProgram;
import xtraitj.xtraitj.TJRenameOperation;
import xtraitj.xtraitj.TJRestrictOperation;
import xtraitj.xtraitj.XtraitjPackage;

@RunWith(XtextRunner.class)
@InjectWith(XtraitjInjectorProvider.class)
@SuppressWarnings("all")
public class TraitJScopeProviderTest {
  @Inject
  @Extension
  private ParseHelper<TJProgram> _parseHelper;
  
  @Inject
  @Extension
  private TraitJInputs _traitJInputs;
  
  @Inject
  @Extension
  private TraitJXbaseBatchScopeProvider _traitJXbaseBatchScopeProvider;
  
  private final EReference memberFeature = new Function0<EReference>() {
    public EReference apply() {
      EReference _tJTraitOperation_Member = XtraitjPackage.eINSTANCE.getTJTraitOperation_Member();
      return _tJTraitOperation_Member;
    }
  }.apply();
  
  @Test
  public void testTraitRenameOperations() {
    try {
      CharSequence _traitRenameOperations = this._traitJInputs.traitRenameOperations();
      TJProgram _parse = this._parseHelper.parse(_traitRenameOperations);
      TJRenameOperation _renameOperation = this.renameOperation(_parse);
      this.assertScope(_renameOperation, this.memberFeature, "n, m, t1, s");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitRenameFieldOperations() {
    try {
      CharSequence _traitRenameField = this._traitJInputs.traitRenameField();
      TJProgram _parse = this._parseHelper.parse(_traitRenameField);
      TJRenameOperation _renameOperation = this.renameOperation(_parse);
      this.assertScope(_renameOperation, this.memberFeature, "fieldB, n, m, fieldS");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitHideOperations() {
    try {
      CharSequence _traitHide = this._traitJInputs.traitHide();
      TJProgram _parse = this._parseHelper.parse(_traitHide);
      TJHideOperation _hideOperation = this.hideOperation(_parse);
      this.assertScope(_hideOperation, this.memberFeature, "p, m, n");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  @Test
  public void testTraitRestrictOperations() {
    try {
      CharSequence _traitRestrict = this._traitJInputs.traitRestrict();
      TJProgram _parse = this._parseHelper.parse(_traitRestrict);
      TJRestrictOperation _restrictOperation = this.restrictOperation(_parse);
      this.assertScope(_restrictOperation, this.memberFeature, "p, m, n");
    } catch (Throwable _e) {
      throw Exceptions.sneakyThrow(_e);
    }
  }
  
  private TJRenameOperation renameOperation(final EObject o) {
    TreeIterator<EObject> _eAllContents = o.eAllContents();
    Iterator<TJRenameOperation> _filter = Iterators.<TJRenameOperation>filter(_eAllContents, TJRenameOperation.class);
    TJRenameOperation _head = IteratorExtensions.<TJRenameOperation>head(_filter);
    return _head;
  }
  
  private TJHideOperation hideOperation(final EObject o) {
    TreeIterator<EObject> _eAllContents = o.eAllContents();
    Iterator<TJHideOperation> _filter = Iterators.<TJHideOperation>filter(_eAllContents, TJHideOperation.class);
    TJHideOperation _head = IteratorExtensions.<TJHideOperation>head(_filter);
    return _head;
  }
  
  private TJRestrictOperation restrictOperation(final EObject o) {
    TreeIterator<EObject> _eAllContents = o.eAllContents();
    Iterator<TJRestrictOperation> _filter = Iterators.<TJRestrictOperation>filter(_eAllContents, TJRestrictOperation.class);
    TJRestrictOperation _head = IteratorExtensions.<TJRestrictOperation>head(_filter);
    return _head;
  }
  
  private void assertScope(final EObject o, final EReference ref, final String expected) {
    IScope _scope = this._traitJXbaseBatchScopeProvider.getScope(o, ref);
    Iterable<IEObjectDescription> _allElements = _scope.getAllElements();
    final Function1<IEObjectDescription,QualifiedName> _function = new Function1<IEObjectDescription,QualifiedName>() {
        public QualifiedName apply(final IEObjectDescription it) {
          QualifiedName _name = it.getName();
          return _name;
        }
      };
    Iterable<QualifiedName> _map = IterableExtensions.<IEObjectDescription, QualifiedName>map(_allElements, _function);
    String _join = IterableExtensions.join(_map, ", ");
    Assert.assertEquals(expected, _join);
  }
}

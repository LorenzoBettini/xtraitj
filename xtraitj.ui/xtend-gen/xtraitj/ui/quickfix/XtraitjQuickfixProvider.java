/**
 * generated by Xtext
 */
package xtraitj.ui.quickfix;

import com.google.common.base.Objects;
import com.google.inject.Inject;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.ui.editor.model.edit.IModificationContext;
import org.eclipse.xtext.ui.editor.model.edit.ISemanticModification;
import org.eclipse.xtext.ui.editor.quickfix.DefaultQuickfixProvider;
import org.eclipse.xtext.ui.editor.quickfix.Fix;
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor;
import org.eclipse.xtext.validation.Issue;
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import xtraitj.jvmmodel.TraitJJvmModelUtil;
import xtraitj.validation.XtraitjValidator;
import xtraitj.xtraitj.TJClass;
import xtraitj.xtraitj.TJField;
import xtraitj.xtraitj.XtraitjFactory;

/**
 * Custom quickfixes.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#quickfixes
 */
@SuppressWarnings("all")
public class XtraitjQuickfixProvider extends DefaultQuickfixProvider {
  @Inject
  @Extension
  private JvmTypesBuilder _jvmTypesBuilder;
  
  @Inject
  @Extension
  private TraitJJvmModelUtil _traitJJvmModelUtil;
  
  @Fix(XtraitjValidator.MISSING_REQUIRED_FIELD)
  public void addMissingRequiredField(final Issue issue, final IssueResolutionAcceptor acceptor) {
    String[] _data = issue.getData();
    String _get = _data[0];
    final String fieldName = this._traitJJvmModelUtil.stripGetter(_get);
    String[] _data_1 = issue.getData();
    final String fieldType = _data_1[1];
    String _plus = ("Add required field \'" + fieldType);
    String _plus_1 = (_plus + " ");
    String _plus_2 = (_plus_1 + fieldName);
    String _plus_3 = (_plus_2 + "\'");
    String _plus_4 = ("Add the missing required field \'" + fieldType);
    String _plus_5 = (_plus_4 + " ");
    String _plus_6 = (_plus_5 + fieldName);
    String _plus_7 = (_plus_6 + "\'");
    final ISemanticModification _function = new ISemanticModification() {
      public void apply(final EObject elem, final IModificationContext context) throws Exception {
        final TJClass clazz = ((TJClass) elem);
        EList<TJField> _fields = clazz.getFields();
        TJField _createTJField = XtraitjFactory.eINSTANCE.createTJField();
        final Procedure1<TJField> _function = new Procedure1<TJField>() {
          public void apply(final TJField it) {
            it.setName(fieldName);
            Iterable<JvmOperation> _jvmAllRequiredFieldOperations = XtraitjQuickfixProvider.this._traitJJvmModelUtil.jvmAllRequiredFieldOperations(clazz);
            final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
              public Boolean apply(final JvmOperation it) {
                String _simpleName = it.getSimpleName();
                String _stripGetter = XtraitjQuickfixProvider.this._traitJJvmModelUtil.stripGetter(_simpleName);
                boolean _equals = Objects.equal(_stripGetter, fieldName);
                return Boolean.valueOf(_equals);
              }
            };
            JvmOperation _findFirst = IterableExtensions.<JvmOperation>findFirst(_jvmAllRequiredFieldOperations, _function);
            JvmTypeReference _returnType = _findFirst.getReturnType();
            JvmTypeReference _cloneWithProxies = XtraitjQuickfixProvider.this._jvmTypesBuilder.cloneWithProxies(_returnType);
            it.setType(_cloneWithProxies);
          }
        };
        TJField _doubleArrow = ObjectExtensions.<TJField>operator_doubleArrow(_createTJField, _function);
        XtraitjQuickfixProvider.this._jvmTypesBuilder.<TJField>operator_add(_fields, _doubleArrow);
      }
    };
    acceptor.accept(issue, _plus_3, _plus_7, 
      "field_private_obj.gif", _function);
  }
}

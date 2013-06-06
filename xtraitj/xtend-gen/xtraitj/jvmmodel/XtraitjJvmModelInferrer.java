package xtraitj.jvmmodel;

import com.google.common.base.Objects;
import com.google.common.collect.Iterables;
import com.google.inject.Inject;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtend2.lib.StringConcatenation;
import org.eclipse.xtext.common.types.JvmConstructor;
import org.eclipse.xtext.common.types.JvmField;
import org.eclipse.xtext.common.types.JvmFormalParameter;
import org.eclipse.xtext.common.types.JvmGenericType;
import org.eclipse.xtext.common.types.JvmMember;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference;
import org.eclipse.xtext.common.types.JvmType;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.xbase.XExpression;
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable;
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer;
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor;
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor.IPostIndexingInitializing;
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ListExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;
import xtraitj.jvmmodel.TraitJJvmModelUtil;
import xtraitj.util.TraitJModelUtil;
import xtraitj.xtraitj.TJAliasOperation;
import xtraitj.xtraitj.TJClass;
import xtraitj.xtraitj.TJDeclaration;
import xtraitj.xtraitj.TJField;
import xtraitj.xtraitj.TJHideOperation;
import xtraitj.xtraitj.TJMember;
import xtraitj.xtraitj.TJMethod;
import xtraitj.xtraitj.TJMethodDeclaration;
import xtraitj.xtraitj.TJProgram;
import xtraitj.xtraitj.TJRedirectOperation;
import xtraitj.xtraitj.TJRenameOperation;
import xtraitj.xtraitj.TJRequiredMethod;
import xtraitj.xtraitj.TJRestrictOperation;
import xtraitj.xtraitj.TJTrait;
import xtraitj.xtraitj.TJTraitExpression;
import xtraitj.xtraitj.TJTraitOperation;
import xtraitj.xtraitj.TJTraitReference;

/**
 * <p>Infers a JVM model from the source model.</p>
 * 
 * <p>The JVM model should contain all elements that would appear in the Java code
 * which is generated from the source model. Other models link against the JVM model rather than the source model.</p>
 */
@SuppressWarnings("all")
public class XtraitjJvmModelInferrer extends AbstractModelInferrer {
  @Inject
  @Extension
  private JvmTypesBuilder _jvmTypesBuilder;
  
  @Inject
  @Extension
  private IQualifiedNameProvider _iQualifiedNameProvider;
  
  @Inject
  @Extension
  private TraitJJvmModelUtil _traitJJvmModelUtil;
  
  /**
   * The dispatch method {@code infer} is called for each instance of the
   * given element's type that is contained in a resource.
   * 
   * @param element
   *            the model to create one or more
   *            {@link org.eclipse.xtext.common.types.JvmDeclaredType declared
   *            types} from.
   * @param acceptor
   *            each created
   *            {@link org.eclipse.xtext.common.types.JvmDeclaredType type}
   *            without a container should be passed to the acceptor in order
   *            get attached to the current resource. The acceptor's
   *            {@link IJvmDeclaredTypeAcceptor#accept(org.eclipse.xtext.common.types.JvmDeclaredType)
   *            accept(..)} method takes the constructed empty type for the
   *            pre-indexing phase. This one is further initialized in the
   *            indexing phase using the closure you pass to the returned
   *            {@link org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor.IPostIndexingInitializing#initializeLater(org.eclipse.xtext.xbase.lib.Procedures.Procedure1)
   *            initializeLater(..)}.
   * @param isPreIndexingPhase
   *            whether the method is called in a pre-indexing phase, i.e.
   *            when the global index is not yet fully updated. You must not
   *            rely on linking using the index if isPreIndexingPhase is
   *            <code>true</code>.
   */
  protected void _infer(final TJProgram p, final IJvmDeclaredTypeAcceptor acceptor, final boolean isPreIndexingPhase) {
    EList<TJDeclaration> _elements = p.getElements();
    Iterable<TJTrait> _filter = Iterables.<TJTrait>filter(_elements, TJTrait.class);
    final Procedure1<TJTrait> _function = new Procedure1<TJTrait>() {
        public void apply(final TJTrait it) {
          XtraitjJvmModelInferrer.this.inferTraitInterface(it, acceptor);
        }
      };
    IterableExtensions.<TJTrait>forEach(_filter, _function);
    EList<TJDeclaration> _elements_1 = p.getElements();
    Iterable<TJTrait> _filter_1 = Iterables.<TJTrait>filter(_elements_1, TJTrait.class);
    final Procedure1<TJTrait> _function_1 = new Procedure1<TJTrait>() {
        public void apply(final TJTrait it) {
          XtraitjJvmModelInferrer.this.inferTraitClass(it, acceptor);
        }
      };
    IterableExtensions.<TJTrait>forEach(_filter_1, _function_1);
    EList<TJDeclaration> _elements_2 = p.getElements();
    Iterable<TJClass> _filter_2 = Iterables.<TJClass>filter(_elements_2, TJClass.class);
    final Procedure1<TJClass> _function_2 = new Procedure1<TJClass>() {
        public void apply(final TJClass it) {
          XtraitjJvmModelInferrer.this.inferClass(it, acceptor);
        }
      };
    IterableExtensions.<TJClass>forEach(_filter_2, _function_2);
  }
  
  public void inferClass(final TJClass c, final IJvmDeclaredTypeAcceptor acceptor) {
    QualifiedName _fullyQualifiedName = this._iQualifiedNameProvider.getFullyQualifiedName(c);
    final JvmGenericType inferredClass = this._jvmTypesBuilder.toClass(c, _fullyQualifiedName);
    List<TJTraitReference> _traitOperationExpressions = TraitJModelUtil.traitOperationExpressions(c);
    final Procedure1<TJTraitReference> _function = new Procedure1<TJTraitReference>() {
        public void apply(final TJTraitReference it) {
          XtraitjJvmModelInferrer.this.inferTraitExpressionInterface(it, acceptor);
        }
      };
    IterableExtensions.<TJTraitReference>forEach(_traitOperationExpressions, _function);
    List<TJTraitReference> _traitOperationExpressions_1 = TraitJModelUtil.traitOperationExpressions(c);
    final Procedure1<TJTraitReference> _function_1 = new Procedure1<TJTraitReference>() {
        public void apply(final TJTraitReference it) {
          XtraitjJvmModelInferrer.this.inferTraitExpressionClass(it, acceptor);
        }
      };
    IterableExtensions.<TJTraitReference>forEach(_traitOperationExpressions_1, _function_1);
    IPostIndexingInitializing<JvmGenericType> _accept = acceptor.<JvmGenericType>accept(inferredClass);
    final Procedure1<JvmGenericType> _function_2 = new Procedure1<JvmGenericType>() {
        public void apply(final JvmGenericType it) {
          String _documentation = XtraitjJvmModelInferrer.this._jvmTypesBuilder.getDocumentation(c);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setDocumentation(it, _documentation);
          EList<TJField> _fields = c.getFields();
          final Procedure1<TJField> _function = new Procedure1<TJField>() {
              public void apply(final TJField field) {
                EList<JvmMember> _members = it.getMembers();
                String _name = field.getName();
                JvmTypeReference _type = field.getType();
                final Procedure1<JvmField> _function = new Procedure1<JvmField>() {
                    public void apply(final JvmField it) {
                      XExpression _init = field.getInit();
                      boolean _notEquals = (!Objects.equal(_init, null));
                      if (_notEquals) {
                        XExpression _init_1 = field.getInit();
                        XtraitjJvmModelInferrer.this._jvmTypesBuilder.setInitializer(it, _init_1);
                      }
                    }
                  };
                JvmField _field = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toField(field, _name, _type, _function);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _field);
                EList<JvmMember> _members_1 = it.getMembers();
                String _name_1 = field.getName();
                JvmTypeReference _type_1 = field.getType();
                JvmOperation _getter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toGetter(field, _name_1, _type_1);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _getter);
                EList<JvmMember> _members_2 = it.getMembers();
                String _name_2 = field.getName();
                JvmTypeReference _type_2 = field.getType();
                JvmOperation _setter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toSetter(field, _name_2, _type_2);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_2, _setter);
              }
            };
          IterableExtensions.<TJField>forEach(_fields, _function);
          TJTraitExpression _traitExpression = c.getTraitExpression();
          List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
          final Procedure1<TJTraitReference> _function_1 = new Procedure1<TJTraitReference>() {
              public void apply(final TJTraitReference traitExp) {
                EList<JvmTypeReference> _superTypes = it.getSuperTypes();
                JvmParameterizedTypeReference _associatedInterface = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedInterface(traitExp);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmTypeReference>operator_add(_superTypes, _associatedInterface);
                EList<JvmMember> _members = it.getMembers();
                JvmField _traitField = XtraitjJvmModelInferrer.this.toTraitField(traitExp);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _traitField);
                Iterable<JvmOperation> _jvmAllMethodOperations = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.jvmAllMethodOperations(traitExp);
                final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
                    public void apply(final JvmOperation traitMethod) {
                      EList<JvmMember> _members = it.getMembers();
                      String _traitFieldName = XtraitjJvmModelInferrer.this.traitFieldName(traitExp);
                      JvmOperation _methodDelegate = XtraitjJvmModelInferrer.this.toMethodDelegate(traitMethod, _traitFieldName);
                      XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _methodDelegate);
                    }
                  };
                IterableExtensions.<JvmOperation>forEach(_jvmAllMethodOperations, _function);
              }
            };
          IterableExtensions.<TJTraitReference>forEach(_traitReferences, _function_1);
        }
      };
    _accept.initializeLater(_function_2);
  }
  
  public JvmField toTraitField(final TJTraitReference e) {
    String _traitFieldName = this.traitFieldName(e);
    JvmParameterizedTypeReference _associatedClass = this._traitJJvmModelUtil.associatedClass(e);
    final Procedure1<JvmField> _function = new Procedure1<JvmField>() {
        public void apply(final JvmField it) {
          final Procedure1<ITreeAppendable> _function = new Procedure1<ITreeAppendable>() {
              public void apply(final ITreeAppendable it) {
                StringConcatenation _builder = new StringConcatenation();
                _builder.append("new ");
                it.append(_builder);
                JvmParameterizedTypeReference _associatedClass = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedClass(e);
                JvmType _type = _associatedClass.getType();
                it.append(_type);
                it.append("(this)");
              }
            };
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setInitializer(it, _function);
        }
      };
    JvmField _field = this._jvmTypesBuilder.toField(e, _traitFieldName, _associatedClass, _function);
    return _field;
  }
  
  public JvmField toTraitFieldDeclaration(final TJTraitReference e) {
    String _traitFieldName = this.traitFieldName(e);
    JvmParameterizedTypeReference _associatedInterface = this._traitJJvmModelUtil.associatedInterface(e);
    JvmField _field = this._jvmTypesBuilder.toField(e, _traitFieldName, _associatedInterface);
    return _field;
  }
  
  public JvmGenericType inferTraitInterface(final TJTrait t, final IJvmDeclaredTypeAcceptor acceptor) {
    JvmGenericType _xblockexpression = null;
    {
      String _traitInterfaceName = this.traitInterfaceName(t);
      final Procedure1<JvmGenericType> _function = new Procedure1<JvmGenericType>() {
          public void apply(final JvmGenericType it) {
            Iterable<TJField> _fields = TraitJModelUtil.fields(t);
            final Procedure1<TJField> _function = new Procedure1<TJField>() {
                public void apply(final TJField field) {
                  EList<JvmMember> _members = it.getMembers();
                  JvmOperation _getterAbstract = XtraitjJvmModelInferrer.this.toGetterAbstract(field);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _getterAbstract);
                  EList<JvmMember> _members_1 = it.getMembers();
                  JvmOperation _setterAbstract = XtraitjJvmModelInferrer.this.toSetterAbstract(field);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _setterAbstract);
                }
              };
            IterableExtensions.<TJField>forEach(_fields, _function);
            Iterable<TJMethod> _methods = TraitJModelUtil.methods(t);
            final Procedure1<TJMethod> _function_1 = new Procedure1<TJMethod>() {
                public void apply(final TJMethod method) {
                  boolean _isPrivate = method.isPrivate();
                  boolean _not = (!_isPrivate);
                  if (_not) {
                    EList<JvmMember> _members = it.getMembers();
                    JvmOperation _abstractMethod = XtraitjJvmModelInferrer.this.toAbstractMethod(method);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _abstractMethod);
                  }
                }
              };
            IterableExtensions.<TJMethod>forEach(_methods, _function_1);
            Iterable<TJRequiredMethod> _requiredMethods = TraitJModelUtil.requiredMethods(t);
            final Procedure1<TJRequiredMethod> _function_2 = new Procedure1<TJRequiredMethod>() {
                public void apply(final TJRequiredMethod method) {
                  EList<JvmMember> _members = it.getMembers();
                  JvmOperation _abstractMethod = XtraitjJvmModelInferrer.this.toAbstractMethod(method);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _abstractMethod);
                }
              };
            IterableExtensions.<TJRequiredMethod>forEach(_requiredMethods, _function_2);
          }
        };
      final JvmGenericType traitInterface = this._jvmTypesBuilder.toInterface(t, _traitInterfaceName, _function);
      List<TJTraitReference> _traitOperationExpressions = TraitJModelUtil.traitOperationExpressions(t);
      final Procedure1<TJTraitReference> _function_1 = new Procedure1<TJTraitReference>() {
          public void apply(final TJTraitReference it) {
            XtraitjJvmModelInferrer.this.inferTraitExpressionInterface(it, acceptor);
          }
        };
      IterableExtensions.<TJTraitReference>forEach(_traitOperationExpressions, _function_1);
      List<TJTraitReference> _traitOperationExpressions_1 = TraitJModelUtil.traitOperationExpressions(t);
      final Procedure1<TJTraitReference> _function_2 = new Procedure1<TJTraitReference>() {
          public void apply(final TJTraitReference it) {
            XtraitjJvmModelInferrer.this.inferTraitExpressionClass(it, acceptor);
          }
        };
      IterableExtensions.<TJTraitReference>forEach(_traitOperationExpressions_1, _function_2);
      IPostIndexingInitializing<JvmGenericType> _accept = acceptor.<JvmGenericType>accept(traitInterface);
      final Procedure1<JvmGenericType> _function_3 = new Procedure1<JvmGenericType>() {
          public void apply(final JvmGenericType it) {
            TJTraitExpression _traitExpression = t.getTraitExpression();
            boolean _notEquals = (!Objects.equal(_traitExpression, null));
            if (_notEquals) {
              ArrayList<JvmTypeReference> _newArrayList = CollectionLiterals.<JvmTypeReference>newArrayList();
              final Procedure1<ArrayList<JvmTypeReference>> _function = new Procedure1<ArrayList<JvmTypeReference>>() {
                  public void apply(final ArrayList<JvmTypeReference> it) {
                    TJTraitExpression _traitExpression = t.getTraitExpression();
                    XtraitjJvmModelInferrer.this.collectSuperInterfaces(it, _traitExpression);
                  }
                };
              ArrayList<JvmTypeReference> _doubleArrow = ObjectExtensions.<ArrayList<JvmTypeReference>>operator_doubleArrow(_newArrayList, _function);
              final Procedure1<JvmTypeReference> _function_1 = new Procedure1<JvmTypeReference>() {
                  public void apply(final JvmTypeReference superInterface) {
                    EList<JvmTypeReference> _superTypes = it.getSuperTypes();
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmTypeReference>operator_add(_superTypes, superInterface);
                  }
                };
              IterableExtensions.<JvmTypeReference>forEach(_doubleArrow, _function_1);
            }
            List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(t);
            final Procedure1<TJTraitReference> _function_2 = new Procedure1<TJTraitReference>() {
                public void apply(final TJTraitReference traitExp) {
                  Iterable<JvmOperation> _jvmAllMethodOperations = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.jvmAllMethodOperations(traitExp);
                  final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
                      public void apply(final JvmOperation op) {
                        EList<JvmMember> _members = it.getMembers();
                        JvmOperation _abstractMethod = XtraitjJvmModelInferrer.this.toAbstractMethod(op);
                        XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _abstractMethod);
                      }
                    };
                  IterableExtensions.<JvmOperation>forEach(_jvmAllMethodOperations, _function);
                }
              };
            IterableExtensions.<TJTraitReference>forEach(_traitReferences, _function_2);
          }
        };
      _accept.initializeLater(_function_3);
      _xblockexpression = (traitInterface);
    }
    return _xblockexpression;
  }
  
  public void inferTraitExpressionInterface(final TJTraitReference t, final IJvmDeclaredTypeAcceptor acceptor) {
    String _traitExpressionInterfaceName = this.traitExpressionInterfaceName(t);
    final Procedure1<JvmGenericType> _function = new Procedure1<JvmGenericType>() {
        public void apply(final JvmGenericType it) {
        }
      };
    JvmGenericType _interface = this._jvmTypesBuilder.toInterface(t, _traitExpressionInterfaceName, _function);
    IPostIndexingInitializing<JvmGenericType> _accept = acceptor.<JvmGenericType>accept(_interface);
    final Procedure1<JvmGenericType> _function_1 = new Procedure1<JvmGenericType>() {
        public void apply(final JvmGenericType it) {
          TJTrait _trait = t.getTrait();
          Iterable<JvmOperation> _jvmAllOperations = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.jvmAllOperations(_trait);
          final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
              public void apply(final JvmOperation jvmOp) {
                final Iterable<TJTraitOperation> relatedOperations = XtraitjJvmModelInferrer.this.operationsForJvmOp(t, jvmOp);
                Iterable<TJRenameOperation> _filter = Iterables.<TJRenameOperation>filter(relatedOperations, TJRenameOperation.class);
                final TJRenameOperation renameOperation = IterableExtensions.<TJRenameOperation>head(_filter);
                Iterable<TJHideOperation> _filter_1 = Iterables.<TJHideOperation>filter(relatedOperations, TJHideOperation.class);
                final TJHideOperation hideOperation = IterableExtensions.<TJHideOperation>head(_filter_1);
                Iterable<TJAliasOperation> _filter_2 = Iterables.<TJAliasOperation>filter(relatedOperations, TJAliasOperation.class);
                final TJAliasOperation aliasOperation = IterableExtensions.<TJAliasOperation>head(_filter_2);
                Iterable<TJRestrictOperation> _filter_3 = Iterables.<TJRestrictOperation>filter(relatedOperations, TJRestrictOperation.class);
                final TJRestrictOperation restrictOperation = IterableExtensions.<TJRestrictOperation>head(_filter_3);
                boolean _isEmpty = IterableExtensions.isEmpty(relatedOperations);
                if (_isEmpty) {
                  EList<JvmMember> _members = it.getMembers();
                  String _simpleName = jvmOp.getSimpleName();
                  JvmOperation _abstractMethod = XtraitjJvmModelInferrer.this.toAbstractMethod(jvmOp, _simpleName);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _abstractMethod);
                } else {
                  boolean _notEquals = (!Objects.equal(renameOperation, null));
                  if (_notEquals) {
                    EList<JvmMember> _members_1 = it.getMembers();
                    String _simpleName_1 = jvmOp.getSimpleName();
                    String _newname = renameOperation.getNewname();
                    String _renameGetterOrSetter = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.renameGetterOrSetter(_simpleName_1, _newname);
                    JvmOperation _abstractMethod_1 = XtraitjJvmModelInferrer.this.toAbstractMethod(jvmOp, _renameGetterOrSetter);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _abstractMethod_1);
                  }
                  boolean _notEquals_1 = (!Objects.equal(aliasOperation, null));
                  if (_notEquals_1) {
                    EList<JvmMember> _members_2 = it.getMembers();
                    String _newname_1 = aliasOperation.getNewname();
                    JvmOperation _abstractMethod_2 = XtraitjJvmModelInferrer.this.toAbstractMethod(jvmOp, _newname_1);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_2, _abstractMethod_2);
                    boolean _and = false;
                    boolean _and_1 = false;
                    boolean _equals = Objects.equal(renameOperation, null);
                    if (!_equals) {
                      _and_1 = false;
                    } else {
                      boolean _equals_1 = Objects.equal(hideOperation, null);
                      _and_1 = (_equals && _equals_1);
                    }
                    if (!_and_1) {
                      _and = false;
                    } else {
                      boolean _equals_2 = Objects.equal(restrictOperation, null);
                      _and = (_and_1 && _equals_2);
                    }
                    if (_and) {
                      EList<JvmMember> _members_3 = it.getMembers();
                      JvmMember _member = aliasOperation.getMember();
                      String _simpleName_2 = _member.getSimpleName();
                      JvmOperation _abstractMethod_3 = XtraitjJvmModelInferrer.this.toAbstractMethod(jvmOp, _simpleName_2);
                      XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_3, _abstractMethod_3);
                    }
                  }
                  boolean _notEquals_2 = (!Objects.equal(restrictOperation, null));
                  if (_notEquals_2) {
                    EList<JvmMember> _members_4 = it.getMembers();
                    String _simpleName_3 = jvmOp.getSimpleName();
                    JvmOperation _abstractMethod_4 = XtraitjJvmModelInferrer.this.toAbstractMethod(restrictOperation, jvmOp, _simpleName_3);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_4, _abstractMethod_4);
                  }
                }
              }
            };
          IterableExtensions.<JvmOperation>forEach(_jvmAllOperations, _function);
        }
      };
    _accept.initializeLater(_function_1);
  }
  
  public Iterable<TJTraitOperation> operationsForJvmOp(final TJTraitReference t, final JvmOperation jvmOp) {
    EList<TJTraitOperation> _operations = t.getOperations();
    final Function1<TJTraitOperation,Boolean> _function = new Function1<TJTraitOperation,Boolean>() {
        public Boolean apply(final TJTraitOperation it) {
          boolean _or = false;
          JvmMember _member = it.getMember();
          String _simpleName = _member==null?(String)null:_member.getSimpleName();
          String _simpleName_1 = jvmOp.getSimpleName();
          boolean _equals = Objects.equal(_simpleName, _simpleName_1);
          if (_equals) {
            _or = true;
          } else {
            boolean _xblockexpression = false;
            {
              JvmMember _member_1 = it.getMember();
              final TJField memberSourceField = _member_1==null?(TJField)null:XtraitjJvmModelInferrer.this._traitJJvmModelUtil.sourceField(_member_1);
              final TJField jvmOpSourceField = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.sourceField(jvmOp);
              boolean _and = false;
              boolean _and_1 = false;
              boolean _notEquals = (!Objects.equal(memberSourceField, null));
              if (!_notEquals) {
                _and_1 = false;
              } else {
                boolean _notEquals_1 = (!Objects.equal(jvmOpSourceField, null));
                _and_1 = (_notEquals && _notEquals_1);
              }
              if (!_and_1) {
                _and = false;
              } else {
                boolean _equals_1 = Objects.equal(memberSourceField, jvmOpSourceField);
                _and = (_and_1 && _equals_1);
              }
              _xblockexpression = (_and);
            }
            _or = (_equals || _xblockexpression);
          }
          return Boolean.valueOf(_or);
        }
      };
    Iterable<TJTraitOperation> _filter = IterableExtensions.<TJTraitOperation>filter(_operations, _function);
    return _filter;
  }
  
  public void inferTraitExpressionClass(final TJTraitReference t, final IJvmDeclaredTypeAcceptor acceptor) {
    String _traitExpressionClassName = this.traitExpressionClassName(t);
    JvmGenericType _class = this._jvmTypesBuilder.toClass(t, _traitExpressionClassName);
    IPostIndexingInitializing<JvmGenericType> _accept = acceptor.<JvmGenericType>accept(_class);
    final Procedure1<JvmGenericType> _function = new Procedure1<JvmGenericType>() {
        public void apply(final JvmGenericType it) {
          EList<JvmTypeReference> _superTypes = it.getSuperTypes();
          JvmParameterizedTypeReference _associatedInterface = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedInterface(t);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmTypeReference>operator_add(_superTypes, _associatedInterface);
          EList<JvmTypeReference> _superTypes_1 = it.getSuperTypes();
          TJTrait _trait = t.getTrait();
          JvmParameterizedTypeReference _associatedInterface_1 = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedInterface(_trait);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmTypeReference>operator_add(_superTypes_1, _associatedInterface_1);
          final String traitFieldName = XtraitjJvmModelInferrer.this.traitFieldNameForOperations(t);
          EList<JvmMember> _members = it.getMembers();
          TJDeclaration _containingDeclaration = TraitJModelUtil.containingDeclaration(t);
          String _delegateFieldName = XtraitjJvmModelInferrer.this.delegateFieldName();
          JvmParameterizedTypeReference _associatedInterface_2 = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedInterface(t);
          JvmField _field = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toField(_containingDeclaration, _delegateFieldName, _associatedInterface_2);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _field);
          EList<JvmMember> _members_1 = it.getMembers();
          TJTrait _trait_1 = t.getTrait();
          JvmParameterizedTypeReference _associatedClass = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedClass(_trait_1);
          JvmField _field_1 = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toField(t, traitFieldName, _associatedClass);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _field_1);
          EList<JvmMember> _members_2 = it.getMembers();
          final Procedure1<JvmConstructor> _function = new Procedure1<JvmConstructor>() {
              public void apply(final JvmConstructor it) {
                EList<JvmFormalParameter> _parameters = it.getParameters();
                JvmParameterizedTypeReference _associatedInterface = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedInterface(t);
                JvmFormalParameter _parameter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toParameter(t, "delegate", _associatedInterface);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmFormalParameter>operator_add(_parameters, _parameter);
                final Procedure1<ITreeAppendable> _function = new Procedure1<ITreeAppendable>() {
                    public void apply(final ITreeAppendable it) {
                      StringConcatenation _builder = new StringConcatenation();
                      _builder.append("this.");
                      String _delegateFieldName = XtraitjJvmModelInferrer.this.delegateFieldName();
                      _builder.append(_delegateFieldName, "");
                      _builder.append(" = delegate;");
                      it.append(_builder);
                      ITreeAppendable _newLine = it.newLine();
                      StringConcatenation _builder_1 = new StringConcatenation();
                      _builder_1.append(traitFieldName, "");
                      _builder_1.append(" = ");
                      _newLine.append(_builder_1);
                      StringConcatenation _builder_2 = new StringConcatenation();
                      _builder_2.append("new ");
                      it.append(_builder_2);
                      TJTrait _trait = t.getTrait();
                      JvmParameterizedTypeReference _associatedClass = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedClass(_trait);
                      JvmType _type = _associatedClass.getType();
                      it.append(_type);
                      it.append("(this);");
                    }
                  };
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(it, _function);
              }
            };
          JvmConstructor _constructor = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toConstructor(t, _function);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_2, _constructor);
          TJTrait _trait_2 = t.getTrait();
          Iterable<JvmOperation> _jvmAllOperations = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.jvmAllOperations(_trait_2);
          final Procedure1<JvmOperation> _function_1 = new Procedure1<JvmOperation>() {
              public void apply(final JvmOperation jvmOp) {
                final Iterable<TJTraitOperation> relatedOperations = XtraitjJvmModelInferrer.this.operationsForJvmOp(t, jvmOp);
                Iterable<TJRenameOperation> _filter = Iterables.<TJRenameOperation>filter(relatedOperations, TJRenameOperation.class);
                final TJRenameOperation renameOperation = IterableExtensions.<TJRenameOperation>head(_filter);
                Iterable<TJHideOperation> _filter_1 = Iterables.<TJHideOperation>filter(relatedOperations, TJHideOperation.class);
                final TJHideOperation hideOperation = IterableExtensions.<TJHideOperation>head(_filter_1);
                Iterable<TJAliasOperation> _filter_2 = Iterables.<TJAliasOperation>filter(relatedOperations, TJAliasOperation.class);
                final TJAliasOperation aliasOperation = IterableExtensions.<TJAliasOperation>head(_filter_2);
                Iterable<TJRestrictOperation> _filter_3 = Iterables.<TJRestrictOperation>filter(relatedOperations, TJRestrictOperation.class);
                final TJRestrictOperation restrictOperation = IterableExtensions.<TJRestrictOperation>head(_filter_3);
                Iterable<TJRedirectOperation> _filter_4 = Iterables.<TJRedirectOperation>filter(relatedOperations, TJRedirectOperation.class);
                final TJRedirectOperation redirectOperation = IterableExtensions.<TJRedirectOperation>head(_filter_4);
                boolean _and = false;
                boolean _and_1 = false;
                boolean _equals = Objects.equal(renameOperation, null);
                if (!_equals) {
                  _and_1 = false;
                } else {
                  boolean _equals_1 = Objects.equal(hideOperation, null);
                  _and_1 = (_equals && _equals_1);
                }
                if (!_and_1) {
                  _and = false;
                } else {
                  boolean _equals_2 = Objects.equal(redirectOperation, null);
                  _and = (_and_1 && _equals_2);
                }
                if (_and) {
                  EList<JvmMember> _members = it.getMembers();
                  String _delegateFieldName = XtraitjJvmModelInferrer.this.delegateFieldName();
                  String _simpleName = jvmOp.getSimpleName();
                  String _simpleName_1 = jvmOp.getSimpleName();
                  JvmOperation _methodDelegate = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, _delegateFieldName, _simpleName, _simpleName_1);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _methodDelegate);
                  boolean _and_2 = false;
                  boolean _isRequired = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.isRequired(jvmOp);
                  boolean _not = (!_isRequired);
                  if (!_not) {
                    _and_2 = false;
                  } else {
                    boolean _equals_3 = Objects.equal(restrictOperation, null);
                    _and_2 = (_not && _equals_3);
                  }
                  if (_and_2) {
                    EList<JvmMember> _members_1 = it.getMembers();
                    String _simpleName_2 = jvmOp.getSimpleName();
                    String _underscoreName = XtraitjJvmModelInferrer.this.underscoreName(_simpleName_2);
                    String _simpleName_3 = jvmOp.getSimpleName();
                    String _underscoreName_1 = XtraitjJvmModelInferrer.this.underscoreName(_simpleName_3);
                    JvmOperation _methodDelegate_1 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, traitFieldName, _underscoreName, _underscoreName_1);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _methodDelegate_1);
                  }
                }
                boolean _notEquals = (!Objects.equal(renameOperation, null));
                if (_notEquals) {
                  boolean _isRequired_1 = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.isRequired(jvmOp);
                  if (_isRequired_1) {
                    String _simpleName_4 = jvmOp.getSimpleName();
                    String _newname = renameOperation.getNewname();
                    final String newname = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.renameGetterOrSetter(_simpleName_4, _newname);
                    EList<JvmMember> _members_2 = it.getMembers();
                    String _simpleName_5 = jvmOp.getSimpleName();
                    JvmOperation _methodDelegate_2 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, 
                      "this", _simpleName_5, newname);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_2, _methodDelegate_2);
                    EList<JvmMember> _members_3 = it.getMembers();
                    String _delegateFieldName_1 = XtraitjJvmModelInferrer.this.delegateFieldName();
                    JvmOperation _methodDelegate_3 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, _delegateFieldName_1, newname, newname);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_3, _methodDelegate_3);
                  } else {
                    EList<JvmMember> _members_4 = it.getMembers();
                    JvmMember _member = renameOperation.getMember();
                    String _simpleName_6 = _member.getSimpleName();
                    String _newname_1 = renameOperation.getNewname();
                    JvmOperation _methodDelegate_4 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, 
                      "this", _simpleName_6, _newname_1);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_4, _methodDelegate_4);
                    EList<JvmMember> _members_5 = it.getMembers();
                    String _delegateFieldName_2 = XtraitjJvmModelInferrer.this.delegateFieldName();
                    String _newname_2 = renameOperation.getNewname();
                    String _newname_3 = renameOperation.getNewname();
                    JvmOperation _methodDelegate_5 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, _delegateFieldName_2, _newname_2, _newname_3);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_5, _methodDelegate_5);
                    EList<JvmMember> _members_6 = it.getMembers();
                    String _newname_4 = renameOperation.getNewname();
                    String _underscoreName_2 = XtraitjJvmModelInferrer.this.underscoreName(_newname_4);
                    JvmMember _member_1 = renameOperation.getMember();
                    String _simpleName_7 = _member_1.getSimpleName();
                    String _underscoreName_3 = XtraitjJvmModelInferrer.this.underscoreName(_simpleName_7);
                    JvmOperation _methodDelegate_6 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, traitFieldName, _underscoreName_2, _underscoreName_3);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_6, _methodDelegate_6);
                  }
                }
                boolean _notEquals_1 = (!Objects.equal(hideOperation, null));
                if (_notEquals_1) {
                  EList<JvmMember> _members_7 = it.getMembers();
                  JvmMember _member_2 = hideOperation.getMember();
                  String _simpleName_8 = _member_2.getSimpleName();
                  JvmMember _member_3 = hideOperation.getMember();
                  String _simpleName_9 = _member_3.getSimpleName();
                  String _underscoreName_4 = XtraitjJvmModelInferrer.this.underscoreName(_simpleName_9);
                  JvmOperation _methodDelegate_7 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, traitFieldName, _simpleName_8, _underscoreName_4);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_7, _methodDelegate_7);
                }
                boolean _notEquals_2 = (!Objects.equal(aliasOperation, null));
                if (_notEquals_2) {
                  EList<JvmMember> _members_8 = it.getMembers();
                  String _delegateFieldName_3 = XtraitjJvmModelInferrer.this.delegateFieldName();
                  String _newname_5 = aliasOperation.getNewname();
                  String _newname_6 = aliasOperation.getNewname();
                  JvmOperation _methodDelegate_8 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, _delegateFieldName_3, _newname_5, _newname_6);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_8, _methodDelegate_8);
                  EList<JvmMember> _members_9 = it.getMembers();
                  String _newname_7 = aliasOperation.getNewname();
                  String _underscoreName_5 = XtraitjJvmModelInferrer.this.underscoreName(_newname_7);
                  JvmMember _member_4 = aliasOperation.getMember();
                  String _simpleName_10 = _member_4.getSimpleName();
                  String _underscoreName_6 = XtraitjJvmModelInferrer.this.underscoreName(_simpleName_10);
                  JvmOperation _methodDelegate_9 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, traitFieldName, _underscoreName_5, _underscoreName_6);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_9, _methodDelegate_9);
                }
                boolean _and_3 = false;
                boolean _notEquals_3 = (!Objects.equal(redirectOperation, null));
                if (!_notEquals_3) {
                  _and_3 = false;
                } else {
                  JvmMember _member2 = redirectOperation.getMember2();
                  boolean _notEquals_4 = (!Objects.equal(_member2, null));
                  _and_3 = (_notEquals_3 && _notEquals_4);
                }
                if (_and_3) {
                  boolean _isRequired_2 = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.isRequired(jvmOp);
                  if (_isRequired_2) {
                    EList<JvmMember> _members_10 = it.getMembers();
                    String _delegateFieldName_4 = XtraitjJvmModelInferrer.this.delegateFieldName();
                    String _simpleName_11 = jvmOp.getSimpleName();
                    String _simpleName_12 = jvmOp.getSimpleName();
                    JvmMember _member2_1 = redirectOperation.getMember2();
                    String _simpleName_13 = _member2_1.getSimpleName();
                    String _stripGetter = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.stripGetter(_simpleName_13);
                    String _renameGetterOrSetter = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.renameGetterOrSetter(_simpleName_12, _stripGetter);
                    JvmOperation _methodDelegate_10 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, _delegateFieldName_4, _simpleName_11, _renameGetterOrSetter);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_10, _methodDelegate_10);
                  } else {
                    EList<JvmMember> _members_11 = it.getMembers();
                    String _delegateFieldName_5 = XtraitjJvmModelInferrer.this.delegateFieldName();
                    JvmMember _member_5 = redirectOperation.getMember();
                    String _simpleName_14 = _member_5.getSimpleName();
                    JvmMember _member2_2 = redirectOperation.getMember2();
                    String _simpleName_15 = _member2_2.getSimpleName();
                    JvmOperation _methodDelegate_11 = XtraitjJvmModelInferrer.this.toMethodDelegate(jvmOp, _delegateFieldName_5, _simpleName_14, _simpleName_15);
                    XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_11, _methodDelegate_11);
                  }
                }
              }
            };
          IterableExtensions.<JvmOperation>forEach(_jvmAllOperations, _function_1);
        }
      };
    _accept.initializeLater(_function);
  }
  
  public void collectSuperInterfaces(final List<JvmTypeReference> typeRefs, final TJTraitExpression e) {
    List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(e);
    final Procedure1<TJTraitReference> _function = new Procedure1<TJTraitReference>() {
        public void apply(final TJTraitReference it) {
          final JvmParameterizedTypeReference i = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedInterface(it);
          boolean _notEquals = (!Objects.equal(i, null));
          if (_notEquals) {
            typeRefs.add(i);
          }
        }
      };
    IterableExtensions.<TJTraitReference>forEach(_traitReferences, _function);
  }
  
  public void inferTraitClass(final TJTrait t, final IJvmDeclaredTypeAcceptor acceptor) {
    String _traitClassName = this.traitClassName(t);
    JvmGenericType _class = this._jvmTypesBuilder.toClass(t, _traitClassName);
    IPostIndexingInitializing<JvmGenericType> _accept = acceptor.<JvmGenericType>accept(_class);
    final Procedure1<JvmGenericType> _function = new Procedure1<JvmGenericType>() {
        public void apply(final JvmGenericType it) {
          String _documentation = XtraitjJvmModelInferrer.this._jvmTypesBuilder.getDocumentation(t);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setDocumentation(it, _documentation);
          final JvmParameterizedTypeReference traitInterfaceTypeRef = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedInterface(t);
          EList<JvmTypeReference> _superTypes = it.getSuperTypes();
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmTypeReference>operator_add(_superTypes, traitInterfaceTypeRef);
          EList<JvmMember> _members = it.getMembers();
          String _delegateFieldName = XtraitjJvmModelInferrer.this.delegateFieldName();
          JvmField _field = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toField(t, _delegateFieldName, traitInterfaceTypeRef);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _field);
          List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(t);
          final Procedure1<TJTraitReference> _function = new Procedure1<TJTraitReference>() {
              public void apply(final TJTraitReference traitExp) {
                EList<JvmMember> _members = it.getMembers();
                String _traitFieldName = XtraitjJvmModelInferrer.this.traitFieldName(traitExp);
                JvmParameterizedTypeReference _associatedClass = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedClass(traitExp);
                JvmField _field = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toField(traitExp, _traitFieldName, _associatedClass);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _field);
              }
            };
          IterableExtensions.<TJTraitReference>forEach(_traitReferences, _function);
          EList<JvmMember> _members_1 = it.getMembers();
          final Procedure1<JvmConstructor> _function_1 = new Procedure1<JvmConstructor>() {
              public void apply(final JvmConstructor it) {
                EList<JvmFormalParameter> _parameters = it.getParameters();
                JvmFormalParameter _parameter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toParameter(t, "delegate", traitInterfaceTypeRef);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmFormalParameter>operator_add(_parameters, _parameter);
                final Procedure1<ITreeAppendable> _function = new Procedure1<ITreeAppendable>() {
                    public void apply(final ITreeAppendable it) {
                      StringConcatenation _builder = new StringConcatenation();
                      _builder.append("this.");
                      String _delegateFieldName = XtraitjJvmModelInferrer.this.delegateFieldName();
                      _builder.append(_delegateFieldName, "");
                      _builder.append(" = delegate;");
                      it.append(_builder);
                      TJTraitExpression _traitExpression = t.getTraitExpression();
                      List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
                      final Procedure1<TJTraitReference> _function = new Procedure1<TJTraitReference>() {
                          public void apply(final TJTraitReference traitExp) {
                            ITreeAppendable _newLine = it.newLine();
                            StringConcatenation _builder = new StringConcatenation();
                            String _traitFieldName = XtraitjJvmModelInferrer.this.traitFieldName(traitExp);
                            _builder.append(_traitFieldName, "");
                            _builder.append(" = ");
                            _newLine.append(_builder);
                            StringConcatenation _builder_1 = new StringConcatenation();
                            _builder_1.append("new ");
                            it.append(_builder_1);
                            JvmParameterizedTypeReference _associatedClass = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.associatedClass(traitExp);
                            JvmType _type = _associatedClass.getType();
                            it.append(_type);
                            it.append("(delegate);");
                          }
                        };
                      IterableExtensions.<TJTraitReference>forEach(_traitReferences, _function);
                    }
                  };
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(it, _function);
              }
            };
          JvmConstructor _constructor = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toConstructor(t, _function_1);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _constructor);
          Iterable<TJField> _fields = TraitJModelUtil.fields(t);
          final Procedure1<TJField> _function_2 = new Procedure1<TJField>() {
              public void apply(final TJField field) {
                EList<JvmMember> _members = it.getMembers();
                JvmOperation _getterDelegate = XtraitjJvmModelInferrer.this.toGetterDelegate(field);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _getterDelegate);
                EList<JvmMember> _members_1 = it.getMembers();
                JvmOperation _setterDelegate = XtraitjJvmModelInferrer.this.toSetterDelegate(field);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _setterDelegate);
              }
            };
          IterableExtensions.<TJField>forEach(_fields, _function_2);
          Iterable<TJRequiredMethod> _requiredMethods = TraitJModelUtil.requiredMethods(t);
          final Procedure1<TJRequiredMethod> _function_3 = new Procedure1<TJRequiredMethod>() {
              public void apply(final TJRequiredMethod aMethod) {
                EList<JvmMember> _members = it.getMembers();
                String _delegateFieldName = XtraitjJvmModelInferrer.this.delegateFieldName();
                JvmOperation _methodDelegate = XtraitjJvmModelInferrer.this.toMethodDelegate(aMethod, _delegateFieldName);
                XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _methodDelegate);
              }
            };
          IterableExtensions.<TJRequiredMethod>forEach(_requiredMethods, _function_3);
          Iterable<TJMethod> _methods = TraitJModelUtil.methods(t);
          final Procedure1<TJMethod> _function_4 = new Procedure1<TJMethod>() {
              public void apply(final TJMethod method) {
                boolean _isPrivate = method.isPrivate();
                if (_isPrivate) {
                  EList<JvmMember> _members = it.getMembers();
                  String _name = method.getName();
                  JvmOperation _traitMethod = XtraitjJvmModelInferrer.this.toTraitMethod(method, _name);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _traitMethod);
                } else {
                  EList<JvmMember> _members_1 = it.getMembers();
                  String _delegateFieldName = XtraitjJvmModelInferrer.this.delegateFieldName();
                  JvmOperation _methodDelegate = XtraitjJvmModelInferrer.this.toMethodDelegate(method, _delegateFieldName);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _methodDelegate);
                  EList<JvmMember> _members_2 = it.getMembers();
                  String _name_1 = method.getName();
                  String _underscoreName = XtraitjJvmModelInferrer.this.underscoreName(_name_1);
                  JvmOperation _traitMethod_1 = XtraitjJvmModelInferrer.this.toTraitMethod(method, _underscoreName);
                  XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_2, _traitMethod_1);
                }
              }
            };
          IterableExtensions.<TJMethod>forEach(_methods, _function_4);
          List<TJTraitReference> _traitReferences_1 = TraitJModelUtil.traitReferences(t);
          final Procedure1<TJTraitReference> _function_5 = new Procedure1<TJTraitReference>() {
              public void apply(final TJTraitReference traitExp) {
                Iterable<JvmOperation> _jvmAllMethodOperations = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.jvmAllMethodOperations(traitExp);
                final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
                    public void apply(final JvmOperation traitMethod) {
                      EList<JvmMember> _members = it.getMembers();
                      String _delegateFieldName = XtraitjJvmModelInferrer.this.delegateFieldName();
                      String _simpleName = traitMethod.getSimpleName();
                      String _simpleName_1 = traitMethod.getSimpleName();
                      JvmOperation _methodDelegate = XtraitjJvmModelInferrer.this.toMethodDelegate(traitMethod, _delegateFieldName, _simpleName, _simpleName_1);
                      XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members, _methodDelegate);
                      EList<JvmMember> _members_1 = it.getMembers();
                      String _traitFieldName = XtraitjJvmModelInferrer.this.traitFieldName(traitExp);
                      String _simpleName_2 = traitMethod.getSimpleName();
                      String _underscoreName = XtraitjJvmModelInferrer.this.underscoreName(_simpleName_2);
                      String _simpleName_3 = traitMethod.getSimpleName();
                      String _underscoreName_1 = XtraitjJvmModelInferrer.this.underscoreName(_simpleName_3);
                      JvmOperation _methodDelegate_1 = XtraitjJvmModelInferrer.this.toMethodDelegate(traitMethod, _traitFieldName, _underscoreName, _underscoreName_1);
                      XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _methodDelegate_1);
                    }
                  };
                IterableExtensions.<JvmOperation>forEach(_jvmAllMethodOperations, _function);
              }
            };
          IterableExtensions.<TJTraitReference>forEach(_traitReferences_1, _function_5);
          List<TJTraitReference> _traitReferences_2 = TraitJModelUtil.traitReferences(t);
          final Procedure1<TJTraitReference> _function_6 = new Procedure1<TJTraitReference>() {
              public void apply(final TJTraitReference traitExp) {
                Iterable<JvmOperation> _jvmAllOperations = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.jvmAllOperations(traitExp);
                final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
                    public Boolean apply(final JvmOperation it) {
                      boolean _isRequired = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.isRequired(it);
                      return Boolean.valueOf(_isRequired);
                    }
                  };
                Iterable<JvmOperation> _filter = IterableExtensions.<JvmOperation>filter(_jvmAllOperations, _function);
                final Procedure1<JvmOperation> _function_1 = new Procedure1<JvmOperation>() {
                    public void apply(final JvmOperation op) {
                      EList<JvmMember> _members = it.getMembers();
                      boolean _alreadyDefined = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.alreadyDefined(_members, op);
                      boolean _not = (!_alreadyDefined);
                      if (_not) {
                        TJField _sourceField = XtraitjJvmModelInferrer.this._traitJJvmModelUtil.sourceField(op);
                        boolean _notEquals = (!Objects.equal(_sourceField, null));
                        if (_notEquals) {
                          EList<JvmMember> _members_1 = it.getMembers();
                          String _delegateFieldName = XtraitjJvmModelInferrer.this.delegateFieldName();
                          String _simpleName = op.getSimpleName();
                          String _simpleName_1 = op.getSimpleName();
                          JvmOperation _methodDelegate = XtraitjJvmModelInferrer.this.toMethodDelegate(op, _delegateFieldName, _simpleName, _simpleName_1);
                          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_1, _methodDelegate);
                        } else {
                          EList<JvmMember> _members_2 = it.getMembers();
                          String _delegateFieldName_1 = XtraitjJvmModelInferrer.this.delegateFieldName();
                          String _simpleName_2 = op.getSimpleName();
                          String _simpleName_3 = op.getSimpleName();
                          JvmOperation _methodDelegate_1 = XtraitjJvmModelInferrer.this.toMethodDelegate(op, _delegateFieldName_1, _simpleName_2, _simpleName_3);
                          XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmMember>operator_add(_members_2, _methodDelegate_1);
                        }
                      }
                    }
                  };
                IterableExtensions.<JvmOperation>forEach(_filter, _function_1);
              }
            };
          IterableExtensions.<TJTraitReference>forEach(_traitReferences_2, _function_6);
        }
      };
    _accept.initializeLater(_function);
  }
  
  private String underscoreName(final String name) {
    String _plus = ("_" + name);
    return _plus;
  }
  
  public JvmOperation toGetterAbstract(final TJMember m) {
    String _name = m.getName();
    JvmTypeReference _type = m.getType();
    JvmOperation _getter = this._jvmTypesBuilder.toGetter(m, _name, _type);
    final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
        public void apply(final JvmOperation it) {
          it.setAbstract(true);
        }
      };
    JvmOperation _doubleArrow = ObjectExtensions.<JvmOperation>operator_doubleArrow(_getter, _function);
    return _doubleArrow;
  }
  
  public JvmOperation toSetterAbstract(final TJMember m) {
    String _name = m.getName();
    JvmTypeReference _type = m.getType();
    JvmOperation _setter = this._jvmTypesBuilder.toSetter(m, _name, _type);
    final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
        public void apply(final JvmOperation it) {
          it.setAbstract(true);
        }
      };
    JvmOperation _doubleArrow = ObjectExtensions.<JvmOperation>operator_doubleArrow(_setter, _function);
    return _doubleArrow;
  }
  
  public JvmOperation toGetterDelegate(final TJMember m) {
    String _delegateFieldName = this.delegateFieldName();
    JvmOperation _getterDelegate = this.toGetterDelegate(m, _delegateFieldName);
    return _getterDelegate;
  }
  
  public JvmOperation toSetterDelegate(final TJMember m) {
    String _delegateFieldName = this.delegateFieldName();
    JvmOperation _setterDelegate = this.toSetterDelegate(m, _delegateFieldName);
    return _setterDelegate;
  }
  
  public JvmOperation toGetterDelegate(final TJMember m, final String delegateFieldName) {
    String _name = m.getName();
    JvmTypeReference _type = m.getType();
    JvmOperation _getter = this._jvmTypesBuilder.toGetter(m, _name, _type);
    final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
        public void apply(final JvmOperation method) {
          final Procedure1<ITreeAppendable> _function = new Procedure1<ITreeAppendable>() {
              public void apply(final ITreeAppendable it) {
                StringConcatenation _builder = new StringConcatenation();
                _builder.append("return ");
                _builder.append(delegateFieldName, "");
                _builder.append(".");
                String _simpleName = method.getSimpleName();
                _builder.append(_simpleName, "");
                _builder.append("();");
                it.append(_builder);
              }
            };
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(method, _function);
        }
      };
    JvmOperation _doubleArrow = ObjectExtensions.<JvmOperation>operator_doubleArrow(_getter, _function);
    return _doubleArrow;
  }
  
  public JvmOperation toSetterDelegate(final TJMember m, final String delegateFieldName) {
    String _name = m.getName();
    JvmTypeReference _type = m.getType();
    JvmOperation _setter = this._jvmTypesBuilder.toSetter(m, _name, _type);
    final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
        public void apply(final JvmOperation method) {
          final Procedure1<ITreeAppendable> _function = new Procedure1<ITreeAppendable>() {
              public void apply(final ITreeAppendable it) {
                StringConcatenation _builder = new StringConcatenation();
                _builder.append(delegateFieldName, "");
                _builder.append(".");
                String _simpleName = method.getSimpleName();
                _builder.append(_simpleName, "");
                _builder.append("(");
                String _name = m.getName();
                _builder.append(_name, "");
                _builder.append(");");
                it.append(_builder);
              }
            };
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(method, _function);
        }
      };
    JvmOperation _doubleArrow = ObjectExtensions.<JvmOperation>operator_doubleArrow(_setter, _function);
    return _doubleArrow;
  }
  
  public JvmOperation toMethodDelegate(final JvmOperation op, final String delegateFieldName) {
    JvmOperation _xblockexpression = null;
    {
      EObject _elvis = null;
      TJMember _originalSource = this._traitJJvmModelUtil.originalSource(op);
      if (_originalSource != null) {
        _elvis = _originalSource;
      } else {
        _elvis = ObjectExtensions.<EObject>operator_elvis(_originalSource, op);
      }
      final EObject m = _elvis;
      String _simpleName = op.getSimpleName();
      JvmTypeReference _returnType = op.getReturnType();
      final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
          public void apply(final JvmOperation it) {
            String _documentation = XtraitjJvmModelInferrer.this._jvmTypesBuilder.getDocumentation(m);
            XtraitjJvmModelInferrer.this._jvmTypesBuilder.setDocumentation(it, _documentation);
            EList<JvmFormalParameter> _parameters = op.getParameters();
            for (final JvmFormalParameter p : _parameters) {
              EList<JvmFormalParameter> _parameters_1 = it.getParameters();
              String _name = p.getName();
              JvmTypeReference _parameterType = p.getParameterType();
              JvmFormalParameter _parameter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toParameter(p, _name, _parameterType);
              XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmFormalParameter>operator_add(_parameters_1, _parameter);
            }
            EList<JvmFormalParameter> _parameters_2 = op.getParameters();
            final Function1<JvmFormalParameter,String> _function = new Function1<JvmFormalParameter,String>() {
                public String apply(final JvmFormalParameter it) {
                  String _name = it.getName();
                  return _name;
                }
              };
            List<String> _map = ListExtensions.<JvmFormalParameter, String>map(_parameters_2, _function);
            final String args = IterableExtensions.join(_map, ", ");
            JvmTypeReference _returnType = op.getReturnType();
            String _simpleName = _returnType==null?(String)null:_returnType.getSimpleName();
            boolean _notEquals = (!Objects.equal(_simpleName, "void"));
            if (_notEquals) {
              final Procedure1<ITreeAppendable> _function_1 = new Procedure1<ITreeAppendable>() {
                  public void apply(final ITreeAppendable it) {
                    StringConcatenation _builder = new StringConcatenation();
                    _builder.append("return ");
                    _builder.append(delegateFieldName, "");
                    _builder.append("._");
                    String _simpleName = op.getSimpleName();
                    _builder.append(_simpleName, "");
                    _builder.append("(");
                    _builder.append(args, "");
                    _builder.append(");");
                    it.append(_builder);
                  }
                };
              XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(it, _function_1);
            } else {
              final Procedure1<ITreeAppendable> _function_2 = new Procedure1<ITreeAppendable>() {
                  public void apply(final ITreeAppendable it) {
                    StringConcatenation _builder = new StringConcatenation();
                    _builder.append(delegateFieldName, "");
                    _builder.append("._");
                    String _simpleName = op.getSimpleName();
                    _builder.append(_simpleName, "");
                    _builder.append("(");
                    _builder.append(args, "");
                    _builder.append(");");
                    it.append(_builder);
                  }
                };
              XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(it, _function_2);
            }
          }
        };
      JvmOperation _method = this._jvmTypesBuilder.toMethod(m, _simpleName, _returnType, _function);
      _xblockexpression = (_method);
    }
    return _xblockexpression;
  }
  
  public JvmOperation toMethodDelegate(final JvmOperation op, final String delegateFieldName, final String methodName, final String methodToDelegate) {
    JvmOperation _xblockexpression = null;
    {
      EObject _elvis = null;
      TJMember _originalSource = this._traitJJvmModelUtil.originalSource(op);
      if (_originalSource != null) {
        _elvis = _originalSource;
      } else {
        _elvis = ObjectExtensions.<EObject>operator_elvis(_originalSource, op);
      }
      final EObject m = _elvis;
      JvmTypeReference _returnType = op.getReturnType();
      final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
          public void apply(final JvmOperation it) {
            String _documentation = XtraitjJvmModelInferrer.this._jvmTypesBuilder.getDocumentation(m);
            XtraitjJvmModelInferrer.this._jvmTypesBuilder.setDocumentation(it, _documentation);
            EList<JvmFormalParameter> _parameters = op.getParameters();
            for (final JvmFormalParameter p : _parameters) {
              EList<JvmFormalParameter> _parameters_1 = it.getParameters();
              String _name = p.getName();
              JvmTypeReference _parameterType = p.getParameterType();
              JvmFormalParameter _parameter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toParameter(p, _name, _parameterType);
              XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmFormalParameter>operator_add(_parameters_1, _parameter);
            }
            EList<JvmFormalParameter> _parameters_2 = op.getParameters();
            final Function1<JvmFormalParameter,String> _function = new Function1<JvmFormalParameter,String>() {
                public String apply(final JvmFormalParameter it) {
                  String _name = it.getName();
                  return _name;
                }
              };
            List<String> _map = ListExtensions.<JvmFormalParameter, String>map(_parameters_2, _function);
            final String args = IterableExtensions.join(_map, ", ");
            JvmTypeReference _returnType = op.getReturnType();
            String _simpleName = _returnType==null?(String)null:_returnType.getSimpleName();
            boolean _notEquals = (!Objects.equal(_simpleName, "void"));
            if (_notEquals) {
              final Procedure1<ITreeAppendable> _function_1 = new Procedure1<ITreeAppendable>() {
                  public void apply(final ITreeAppendable it) {
                    StringConcatenation _builder = new StringConcatenation();
                    _builder.append("return ");
                    _builder.append(delegateFieldName, "");
                    _builder.append(".");
                    _builder.append(methodToDelegate, "");
                    _builder.append("(");
                    _builder.append(args, "");
                    _builder.append(");");
                    it.append(_builder);
                  }
                };
              XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(it, _function_1);
            } else {
              final Procedure1<ITreeAppendable> _function_2 = new Procedure1<ITreeAppendable>() {
                  public void apply(final ITreeAppendable it) {
                    StringConcatenation _builder = new StringConcatenation();
                    _builder.append(delegateFieldName, "");
                    _builder.append(".");
                    _builder.append(methodToDelegate, "");
                    _builder.append("(");
                    _builder.append(args, "");
                    _builder.append(");");
                    it.append(_builder);
                  }
                };
              XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(it, _function_2);
            }
          }
        };
      JvmOperation _method = this._jvmTypesBuilder.toMethod(m, methodName, _returnType, _function);
      _xblockexpression = (_method);
    }
    return _xblockexpression;
  }
  
  public JvmOperation toMethodDelegate(final TJMethodDeclaration m, final String delegateFieldName) {
    String _name = m.getName();
    JvmTypeReference _type = m.getType();
    final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
        public void apply(final JvmOperation it) {
          String _documentation = XtraitjJvmModelInferrer.this._jvmTypesBuilder.getDocumentation(m);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setDocumentation(it, _documentation);
          EList<JvmFormalParameter> _params = m.getParams();
          for (final JvmFormalParameter p : _params) {
            EList<JvmFormalParameter> _parameters = it.getParameters();
            String _name = p.getName();
            JvmTypeReference _parameterType = p.getParameterType();
            JvmFormalParameter _parameter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toParameter(p, _name, _parameterType);
            XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmFormalParameter>operator_add(_parameters, _parameter);
          }
          EList<JvmFormalParameter> _params_1 = m.getParams();
          final Function1<JvmFormalParameter,String> _function = new Function1<JvmFormalParameter,String>() {
              public String apply(final JvmFormalParameter it) {
                String _name = it.getName();
                return _name;
              }
            };
          List<String> _map = ListExtensions.<JvmFormalParameter, String>map(_params_1, _function);
          final String args = IterableExtensions.join(_map, ", ");
          JvmTypeReference _type = m.getType();
          String _simpleName = _type==null?(String)null:_type.getSimpleName();
          boolean _notEquals = (!Objects.equal(_simpleName, "void"));
          if (_notEquals) {
            final Procedure1<ITreeAppendable> _function_1 = new Procedure1<ITreeAppendable>() {
                public void apply(final ITreeAppendable it) {
                  StringConcatenation _builder = new StringConcatenation();
                  _builder.append("return ");
                  _builder.append(delegateFieldName, "");
                  _builder.append(".");
                  String _name = m.getName();
                  _builder.append(_name, "");
                  _builder.append("(");
                  _builder.append(args, "");
                  _builder.append(");");
                  it.append(_builder);
                }
              };
            XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(it, _function_1);
          } else {
            final Procedure1<ITreeAppendable> _function_2 = new Procedure1<ITreeAppendable>() {
                public void apply(final ITreeAppendable it) {
                  StringConcatenation _builder = new StringConcatenation();
                  _builder.append(delegateFieldName, "");
                  _builder.append(".");
                  String _name = m.getName();
                  _builder.append(_name, "");
                  _builder.append("(");
                  _builder.append(args, "");
                  _builder.append(");");
                  it.append(_builder);
                }
              };
            XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(it, _function_2);
          }
        }
      };
    JvmOperation _method = this._jvmTypesBuilder.toMethod(m, _name, _type, _function);
    return _method;
  }
  
  public JvmOperation toAbstractMethod(final TJMethodDeclaration m) {
    String _name = m.getName();
    JvmTypeReference _type = m.getType();
    final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
        public void apply(final JvmOperation it) {
          String _documentation = XtraitjJvmModelInferrer.this._jvmTypesBuilder.getDocumentation(m);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setDocumentation(it, _documentation);
          EList<JvmFormalParameter> _params = m.getParams();
          for (final JvmFormalParameter p : _params) {
            EList<JvmFormalParameter> _parameters = it.getParameters();
            String _name = p.getName();
            JvmTypeReference _parameterType = p.getParameterType();
            JvmFormalParameter _parameter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toParameter(p, _name, _parameterType);
            XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmFormalParameter>operator_add(_parameters, _parameter);
          }
          it.setAbstract(true);
        }
      };
    JvmOperation _method = this._jvmTypesBuilder.toMethod(m, _name, _type, _function);
    return _method;
  }
  
  public JvmOperation toAbstractMethod(final JvmOperation m) {
    String _simpleName = m.getSimpleName();
    JvmOperation _abstractMethod = this.toAbstractMethod(m, _simpleName);
    return _abstractMethod;
  }
  
  public JvmOperation toAbstractMethod(final JvmOperation m, final String name) {
    TJMember _originalSource = this._traitJJvmModelUtil.originalSource(m);
    JvmOperation _abstractMethod = this.toAbstractMethod(_originalSource, m, name);
    return _abstractMethod;
  }
  
  public JvmOperation toAbstractMethod(final EObject source, final JvmOperation m, final String name) {
    JvmTypeReference _returnType = m.getReturnType();
    final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
        public void apply(final JvmOperation it) {
          String _documentation = XtraitjJvmModelInferrer.this._jvmTypesBuilder.getDocumentation(m);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setDocumentation(it, _documentation);
          EList<JvmFormalParameter> _parameters = m.getParameters();
          for (final JvmFormalParameter p : _parameters) {
            EList<JvmFormalParameter> _parameters_1 = it.getParameters();
            String _name = p.getName();
            JvmTypeReference _parameterType = p.getParameterType();
            JvmFormalParameter _parameter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toParameter(p, _name, _parameterType);
            XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmFormalParameter>operator_add(_parameters_1, _parameter);
          }
          it.setAbstract(true);
        }
      };
    JvmOperation _method = this._jvmTypesBuilder.toMethod(source, name, _returnType, _function);
    return _method;
  }
  
  public JvmOperation toTraitMethod(final TJMethod method, final String name) {
    JvmTypeReference _type = method.getType();
    final Procedure1<JvmOperation> _function = new Procedure1<JvmOperation>() {
        public void apply(final JvmOperation it) {
          String _documentation = XtraitjJvmModelInferrer.this._jvmTypesBuilder.getDocumentation(method);
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setDocumentation(it, _documentation);
          EList<JvmFormalParameter> _params = method.getParams();
          for (final JvmFormalParameter p : _params) {
            EList<JvmFormalParameter> _parameters = it.getParameters();
            String _name = p.getName();
            JvmTypeReference _parameterType = p.getParameterType();
            JvmFormalParameter _parameter = XtraitjJvmModelInferrer.this._jvmTypesBuilder.toParameter(p, _name, _parameterType);
            XtraitjJvmModelInferrer.this._jvmTypesBuilder.<JvmFormalParameter>operator_add(_parameters, _parameter);
          }
          XExpression _body = method.getBody();
          XtraitjJvmModelInferrer.this._jvmTypesBuilder.setBody(it, _body);
        }
      };
    JvmOperation _method = this._jvmTypesBuilder.toMethod(method, name, _type, _function);
    return _method;
  }
  
  public String traitInterfaceName(final TJTraitReference e) {
    TJTrait _trait = e.getTrait();
    String _traitInterfaceName = _trait==null?(String)null:this.traitInterfaceName(_trait);
    return _traitInterfaceName;
  }
  
  public String traitClassName(final TJTraitReference e) {
    TJTrait _trait = e.getTrait();
    String _traitClassName = _trait==null?(String)null:this.traitClassName(_trait);
    return _traitClassName;
  }
  
  public String traitInterfaceName(final TJTrait t) {
    String _xblockexpression = null;
    {
      final QualifiedName n = this._iQualifiedNameProvider.getFullyQualifiedName(t);
      QualifiedName _skipLast = n.skipLast(1);
      QualifiedName _append = _skipLast.append("traits");
      String _lastSegment = n.getLastSegment();
      QualifiedName _append_1 = _append.append(_lastSegment);
      String _string = _append_1.toString();
      _xblockexpression = (_string);
    }
    return _xblockexpression;
  }
  
  public String traitExpressionInterfaceName(final TJTraitReference t) {
    String _xblockexpression = null;
    {
      TJDeclaration _containingDeclaration = TraitJModelUtil.containingDeclaration(t);
      final QualifiedName n = this._iQualifiedNameProvider.getFullyQualifiedName(_containingDeclaration);
      QualifiedName _skipLast = n.skipLast(1);
      QualifiedName _append = _skipLast.append("traits");
      String _adapterName = this.adapterName(t);
      QualifiedName _append_1 = _append.append(_adapterName);
      String _string = _append_1.toString();
      _xblockexpression = (_string);
    }
    return _xblockexpression;
  }
  
  public String traitExpressionClassName(final TJTraitReference t) {
    String _xblockexpression = null;
    {
      TJDeclaration _containingDeclaration = TraitJModelUtil.containingDeclaration(t);
      final QualifiedName n = this._iQualifiedNameProvider.getFullyQualifiedName(_containingDeclaration);
      QualifiedName _skipLast = n.skipLast(1);
      QualifiedName _append = _skipLast.append("traits");
      QualifiedName _append_1 = _append.append("impl");
      String _adapterName = this.adapterName(t);
      QualifiedName _append_2 = _append_1.append(_adapterName);
      String _string = _append_2.toString();
      String _plus = (_string + "Impl");
      _xblockexpression = (_plus);
    }
    return _xblockexpression;
  }
  
  public String adapterName(final TJTraitReference t) {
    String _syntheticName = this.syntheticName(t);
    String _plus = (_syntheticName + "_Adapter");
    return _plus;
  }
  
  public String syntheticName(final TJTraitReference t) {
    TJDeclaration _containingDeclaration = TraitJModelUtil.containingDeclaration(t);
    String _name = _containingDeclaration.getName();
    String _plus = (_name + "_");
    TJTrait _trait = t.getTrait();
    String _name_1 = _trait.getName();
    String _plus_1 = (_plus + _name_1);
    String _plus_2 = (_plus_1 + "_");
    TJDeclaration _containingDeclaration_1 = TraitJModelUtil.containingDeclaration(t);
    List<TJTraitReference> _traitOperationExpressions = TraitJModelUtil.traitOperationExpressions(_containingDeclaration_1);
    int _indexOf = _traitOperationExpressions.indexOf(t);
    String _plus_3 = (_plus_2 + Integer.valueOf(_indexOf));
    return _plus_3;
  }
  
  public String traitClassName(final TJTrait t) {
    String _xblockexpression = null;
    {
      final QualifiedName n = this._iQualifiedNameProvider.getFullyQualifiedName(t);
      QualifiedName _skipLast = n.skipLast(1);
      QualifiedName _append = _skipLast.append("traits");
      QualifiedName _append_1 = _append.append("impl");
      String _lastSegment = n.getLastSegment();
      QualifiedName _append_2 = _append_1.append(_lastSegment);
      String _string = _append_2.toString();
      String _plus = (_string + "Impl");
      _xblockexpression = (_plus);
    }
    return _xblockexpression;
  }
  
  public String delegateFieldName() {
    return "_delegate";
  }
  
  public String traitFieldName(final TJTraitReference e) {
    EList<TJTraitOperation> _operations = e.getOperations();
    boolean _isEmpty = _operations.isEmpty();
    if (_isEmpty) {
      TJTrait _trait = e.getTrait();
      return _trait==null?(String)null:this.traitFieldName(_trait);
    }
    String _syntheticName = this.syntheticName(e);
    return ("_" + _syntheticName);
  }
  
  public String traitFieldNameForOperations(final TJTraitReference e) {
    TJTrait _trait = e.getTrait();
    String _traitFieldName = _trait==null?(String)null:this.traitFieldName(_trait);
    String _plus = (_traitFieldName + "_");
    TJDeclaration _containingDeclaration = TraitJModelUtil.containingDeclaration(e);
    List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_containingDeclaration);
    int _indexOf = _traitReferences.indexOf(e);
    return (_plus + Integer.valueOf(_indexOf));
  }
  
  public String traitFieldName(final TJTrait t) {
    String _name = t.getName();
    String _plus = ("_" + _name);
    return _plus;
  }
  
  public void infer(final EObject p, final IJvmDeclaredTypeAcceptor acceptor, final boolean isPreIndexingPhase) {
    if (p instanceof TJProgram) {
      _infer((TJProgram)p, acceptor, isPreIndexingPhase);
      return;
    } else if (p != null) {
      _infer(p, acceptor, isPreIndexingPhase);
      return;
    } else {
      throw new IllegalArgumentException("Unhandled parameter types: " +
        Arrays.<Object>asList(p, acceptor, isPreIndexingPhase).toString());
    }
  }
}

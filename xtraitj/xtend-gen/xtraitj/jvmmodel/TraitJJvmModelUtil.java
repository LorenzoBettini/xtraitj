package xtraitj.jvmmodel;

import com.google.common.base.Objects;
import com.google.common.collect.Iterables;
import com.google.inject.Inject;
import java.beans.Introspector;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.common.types.JvmDeclaredType;
import org.eclipse.xtext.common.types.JvmFeature;
import org.eclipse.xtext.common.types.JvmFormalParameter;
import org.eclipse.xtext.common.types.JvmGenericType;
import org.eclipse.xtext.common.types.JvmMember;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference;
import org.eclipse.xtext.common.types.JvmType;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.common.types.util.TypeReferences;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociations;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Exceptions;
import org.eclipse.xtext.xbase.lib.Extension;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.eclipse.xtext.xbase.lib.IterableExtensions;
import org.eclipse.xtext.xbase.lib.ListExtensions;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.StringExtensions;
import xtraitj.typing.TraitJTypingUtil;
import xtraitj.util.TraitJModelUtil;
import xtraitj.xtraitj.TJClass;
import xtraitj.xtraitj.TJDeclaration;
import xtraitj.xtraitj.TJField;
import xtraitj.xtraitj.TJMember;
import xtraitj.xtraitj.TJMethod;
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
public class TraitJJvmModelUtil {
  @Inject
  @Extension
  private TypeReferences _typeReferences;
  
  @Inject
  @Extension
  private IJvmModelAssociations _iJvmModelAssociations;
  
  @Inject
  @Extension
  private TraitJTypingUtil _traitJTypingUtil;
  
  public JvmParameterizedTypeReference associatedInterface(final TJTraitReference t) {
    JvmParameterizedTypeReference _createTypeRef = null;
    JvmGenericType _associatedInterfaceType = this.associatedInterfaceType(t);
    if (_associatedInterfaceType!=null) {
      _createTypeRef=this._typeReferences.createTypeRef(_associatedInterfaceType);
    }
    return _createTypeRef;
  }
  
  public JvmGenericType associatedInterfaceType(final TJTraitReference t) {
    EList<TJTraitOperation> _operations = t.getOperations();
    boolean _isEmpty = _operations.isEmpty();
    if (_isEmpty) {
      TJTrait _trait = t.getTrait();
      return this.associatedInterfaceType(_trait);
    }
    return this._associatedInterfaceType(t);
  }
  
  public JvmParameterizedTypeReference associatedInterface(final TJTrait t) {
    JvmParameterizedTypeReference _createTypeRef = null;
    JvmGenericType _associatedInterfaceType = this.associatedInterfaceType(t);
    if (_associatedInterfaceType!=null) {
      _createTypeRef=this._typeReferences.createTypeRef(_associatedInterfaceType);
    }
    return _createTypeRef;
  }
  
  public JvmGenericType associatedInterfaceType(final TJTrait t) {
    JvmGenericType __associatedInterfaceType = this._associatedInterfaceType(t);
    return __associatedInterfaceType;
  }
  
  public JvmGenericType _associatedInterfaceType(final EObject t) {
    Set<EObject> _jvmElements = this._iJvmModelAssociations.getJvmElements(t);
    Iterable<JvmGenericType> _filter = Iterables.<JvmGenericType>filter(_jvmElements, JvmGenericType.class);
    final Function1<JvmGenericType,Boolean> _function = new Function1<JvmGenericType,Boolean>() {
        public Boolean apply(final JvmGenericType it) {
          boolean _isInterface = it.isInterface();
          return Boolean.valueOf(_isInterface);
        }
      };
    Iterable<JvmGenericType> _filter_1 = IterableExtensions.<JvmGenericType>filter(_filter, _function);
    JvmGenericType _head = IterableExtensions.<JvmGenericType>head(_filter_1);
    return _head;
  }
  
  public JvmParameterizedTypeReference associatedClass(final TJTraitReference t) {
    JvmParameterizedTypeReference _createTypeRef = null;
    JvmGenericType _associatedClassType = this.associatedClassType(t);
    if (_associatedClassType!=null) {
      _createTypeRef=this._typeReferences.createTypeRef(_associatedClassType);
    }
    return _createTypeRef;
  }
  
  public JvmGenericType associatedClassType(final TJTraitReference t) {
    EList<TJTraitOperation> _operations = t.getOperations();
    boolean _isEmpty = _operations.isEmpty();
    if (_isEmpty) {
      TJTrait _trait = t.getTrait();
      return this.associatedClassType(_trait);
    }
    return this._associatedClassType(t);
  }
  
  public JvmParameterizedTypeReference associatedClass(final TJTrait t) {
    JvmParameterizedTypeReference _createTypeRef = null;
    JvmGenericType _associatedClassType = this.associatedClassType(t);
    if (_associatedClassType!=null) {
      _createTypeRef=this._typeReferences.createTypeRef(_associatedClassType);
    }
    return _createTypeRef;
  }
  
  public JvmGenericType associatedClassType(final TJTrait t) {
    JvmGenericType __associatedClassType = this._associatedClassType(t);
    return __associatedClassType;
  }
  
  public JvmGenericType _associatedClassType(final EObject t) {
    Set<EObject> _jvmElements = this._iJvmModelAssociations.getJvmElements(t);
    Iterable<JvmGenericType> _filter = Iterables.<JvmGenericType>filter(_jvmElements, JvmGenericType.class);
    final Function1<JvmGenericType,Boolean> _function = new Function1<JvmGenericType,Boolean>() {
        public Boolean apply(final JvmGenericType it) {
          boolean _isInterface = it.isInterface();
          boolean _not = (!_isInterface);
          return Boolean.valueOf(_not);
        }
      };
    Iterable<JvmGenericType> _filter_1 = IterableExtensions.<JvmGenericType>filter(_filter, _function);
    JvmGenericType _head = IterableExtensions.<JvmGenericType>head(_filter_1);
    return _head;
  }
  
  public Iterable<JvmFeature> jvmAllFeatures(final TJTrait t) {
    Iterable<JvmFeature> __jvmAllFeatures = this._jvmAllFeatures(t);
    final Function1<JvmFeature,Boolean> _function = new Function1<JvmFeature,Boolean>() {
        public Boolean apply(final JvmFeature it) {
          Set<EObject> _sourceElements = TraitJJvmModelUtil.this._iJvmModelAssociations.getSourceElements(it);
          boolean _isEmpty = _sourceElements.isEmpty();
          boolean _not = (!_isEmpty);
          return Boolean.valueOf(_not);
        }
      };
    Iterable<JvmFeature> _filter = IterableExtensions.<JvmFeature>filter(__jvmAllFeatures, _function);
    return _filter;
  }
  
  public Iterable<JvmFeature> _jvmAllFeatures(final TJTrait t) {
    Iterable<JvmFeature> _elvis = null;
    JvmGenericType _associatedInterfaceType = this.associatedInterfaceType(t);
    Iterable<JvmFeature> _allFeatures = null;
    if (_associatedInterfaceType!=null) {
      _allFeatures=_associatedInterfaceType.getAllFeatures();
    }
    if (_allFeatures != null) {
      _elvis = _allFeatures;
    } else {
      List<JvmFeature> _emptyList = CollectionLiterals.<JvmFeature>emptyList();
      _elvis = ObjectExtensions.<Iterable<JvmFeature>>operator_elvis(_allFeatures, _emptyList);
    }
    return _elvis;
  }
  
  public Iterable<JvmFeature> _jvmAllFeatures(final TJTraitReference t) {
    Iterable<JvmFeature> _elvis = null;
    JvmGenericType _associatedInterfaceType = this.associatedInterfaceType(t);
    Iterable<JvmFeature> _allFeatures = null;
    if (_associatedInterfaceType!=null) {
      _allFeatures=_associatedInterfaceType.getAllFeatures();
    }
    if (_allFeatures != null) {
      _elvis = _allFeatures;
    } else {
      List<JvmFeature> _emptyList = CollectionLiterals.<JvmFeature>emptyList();
      _elvis = ObjectExtensions.<Iterable<JvmFeature>>operator_elvis(_allFeatures, _emptyList);
    }
    return _elvis;
  }
  
  public Iterable<JvmOperation> jvmAllOperations(final TJTrait t) {
    Iterable<JvmFeature> _jvmAllFeatures = this.jvmAllFeatures(t);
    Iterable<JvmOperation> _filter = Iterables.<JvmOperation>filter(_jvmAllFeatures, JvmOperation.class);
    return _filter;
  }
  
  public Iterable<JvmOperation> jvmAllOperations(final TJTraitReference t) {
    Iterable<JvmFeature> _jvmAllFeatures = this.jvmAllFeatures(t);
    Iterable<JvmOperation> _filter = Iterables.<JvmOperation>filter(_jvmAllFeatures, JvmOperation.class);
    return _filter;
  }
  
  public TJField sourceField(final JvmMember f) {
    Set<EObject> _sourceElements = this._iJvmModelAssociations.getSourceElements(f);
    final Function1<EObject,Boolean> _function = new Function1<EObject,Boolean>() {
        public Boolean apply(final EObject it) {
          return Boolean.valueOf((it instanceof TJField));
        }
      };
    EObject _findFirst = IterableExtensions.<EObject>findFirst(_sourceElements, _function);
    return ((TJField) _findFirst);
  }
  
  public TJMethod sourceMethod(final JvmFeature f) {
    Set<EObject> _sourceElements = this._iJvmModelAssociations.getSourceElements(f);
    final Function1<EObject,Boolean> _function = new Function1<EObject,Boolean>() {
        public Boolean apply(final EObject it) {
          return Boolean.valueOf((it instanceof TJMethod));
        }
      };
    EObject _findFirst = IterableExtensions.<EObject>findFirst(_sourceElements, _function);
    return ((TJMethod) _findFirst);
  }
  
  public TJRequiredMethod sourceRequiredMethod(final JvmFeature f) {
    Set<EObject> _sourceElements = this._iJvmModelAssociations.getSourceElements(f);
    final Function1<EObject,Boolean> _function = new Function1<EObject,Boolean>() {
        public Boolean apply(final EObject it) {
          return Boolean.valueOf((it instanceof TJRequiredMethod));
        }
      };
    EObject _findFirst = IterableExtensions.<EObject>findFirst(_sourceElements, _function);
    return ((TJRequiredMethod) _findFirst);
  }
  
  public TJRestrictOperation sourceRestricted(final JvmFeature f) {
    Set<EObject> _sourceElements = this._iJvmModelAssociations.getSourceElements(f);
    final Function1<EObject,Boolean> _function = new Function1<EObject,Boolean>() {
        public Boolean apply(final EObject it) {
          return Boolean.valueOf((it instanceof TJRestrictOperation));
        }
      };
    EObject _findFirst = IterableExtensions.<EObject>findFirst(_sourceElements, _function);
    return ((TJRestrictOperation) _findFirst);
  }
  
  public Iterable<JvmFeature> jvmAllFeatures(final TJTraitReference t) {
    Iterable<JvmFeature> __jvmAllFeatures = this._jvmAllFeatures(t);
    final Function1<JvmFeature,Boolean> _function = new Function1<JvmFeature,Boolean>() {
        public Boolean apply(final JvmFeature it) {
          Set<EObject> _sourceElements = TraitJJvmModelUtil.this._iJvmModelAssociations.getSourceElements(it);
          boolean _isEmpty = _sourceElements.isEmpty();
          boolean _not = (!_isEmpty);
          return Boolean.valueOf(_not);
        }
      };
    Iterable<JvmFeature> _filter = IterableExtensions.<JvmFeature>filter(__jvmAllFeatures, _function);
    return _filter;
  }
  
  public Iterable<JvmFeature> _jvmAllOperations(final TJTraitReference t) {
    Iterable<JvmFeature> _elvis = null;
    JvmGenericType _associatedInterfaceType = this.associatedInterfaceType(t);
    Iterable<JvmFeature> _allFeatures = null;
    if (_associatedInterfaceType!=null) {
      _allFeatures=_associatedInterfaceType.getAllFeatures();
    }
    if (_allFeatures != null) {
      _elvis = _allFeatures;
    } else {
      List<JvmFeature> _emptyList = CollectionLiterals.<JvmFeature>emptyList();
      _elvis = ObjectExtensions.<Iterable<JvmFeature>>operator_elvis(_allFeatures, _emptyList);
    }
    return _elvis;
  }
  
  public Iterable<JvmOperation> jvmAllMethodOperations(final TJTraitReference e) {
    Iterable<JvmFeature> __jvmAllOperations = this._jvmAllOperations(e);
    Iterable<JvmOperation> _filter = Iterables.<JvmOperation>filter(__jvmAllOperations, JvmOperation.class);
    final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
        public Boolean apply(final JvmOperation it) {
          TJMethod _sourceMethod = TraitJJvmModelUtil.this.sourceMethod(it);
          boolean _notEquals = (!Objects.equal(_sourceMethod, null));
          return Boolean.valueOf(_notEquals);
        }
      };
    Iterable<JvmOperation> _filter_1 = IterableExtensions.<JvmOperation>filter(_filter, _function);
    return _filter_1;
  }
  
  public Iterable<JvmOperation> jvmAllMethodOperations(final TJClass e) {
    TJTraitExpression _traitExpression = e.getTraitExpression();
    List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
    final Function1<TJTraitReference,Iterable<JvmOperation>> _function = new Function1<TJTraitReference,Iterable<JvmOperation>>() {
        public Iterable<JvmOperation> apply(final TJTraitReference it) {
          Iterable<JvmOperation> _jvmAllMethodOperations = TraitJJvmModelUtil.this.jvmAllMethodOperations(it);
          return _jvmAllMethodOperations;
        }
      };
    List<Iterable<JvmOperation>> _map = ListExtensions.<TJTraitReference, Iterable<JvmOperation>>map(_traitReferences, _function);
    Iterable<JvmOperation> _flatten = Iterables.<JvmOperation>concat(_map);
    return _flatten;
  }
  
  public Iterable<JvmOperation> jvmAllMethods(final TJClass e) {
    Iterable<JvmOperation> _elvis = null;
    JvmGenericType __associatedClassType = this._associatedClassType(e);
    Iterable<JvmFeature> _allFeatures = null;
    if (__associatedClassType!=null) {
      _allFeatures=__associatedClassType.getAllFeatures();
    }
    Iterable<JvmOperation> _filter = Iterables.<JvmOperation>filter(_allFeatures, JvmOperation.class);
    if (_filter != null) {
      _elvis = _filter;
    } else {
      List<JvmOperation> _emptyList = CollectionLiterals.<JvmOperation>emptyList();
      _elvis = ObjectExtensions.<Iterable<JvmOperation>>operator_elvis(_filter, _emptyList);
    }
    return _elvis;
  }
  
  public Iterable<JvmOperation> jvmAllInterfaceMethods(final TJClass e) {
    EList<JvmParameterizedTypeReference> _interfaces = e.getInterfaces();
    final Function1<JvmParameterizedTypeReference,JvmType> _function = new Function1<JvmParameterizedTypeReference,JvmType>() {
        public JvmType apply(final JvmParameterizedTypeReference it) {
          JvmType _type = it.getType();
          return _type;
        }
      };
    List<JvmType> _map = ListExtensions.<JvmParameterizedTypeReference, JvmType>map(_interfaces, _function);
    Iterable<JvmGenericType> _filter = Iterables.<JvmGenericType>filter(_map, JvmGenericType.class);
    final Function1<JvmGenericType,Iterable<JvmFeature>> _function_1 = new Function1<JvmGenericType,Iterable<JvmFeature>>() {
        public Iterable<JvmFeature> apply(final JvmGenericType it) {
          Iterable<JvmFeature> _allFeatures = it.getAllFeatures();
          return _allFeatures;
        }
      };
    Iterable<Iterable<JvmFeature>> _map_1 = IterableExtensions.<JvmGenericType, Iterable<JvmFeature>>map(_filter, _function_1);
    Iterable<JvmFeature> _flatten = Iterables.<JvmFeature>concat(_map_1);
    Iterable<JvmOperation> _filter_1 = Iterables.<JvmOperation>filter(_flatten, JvmOperation.class);
    final Function1<JvmOperation,Boolean> _function_2 = new Function1<JvmOperation,Boolean>() {
        public Boolean apply(final JvmOperation it) {
          JvmDeclaredType _declaringType = it.getDeclaringType();
          String _identifier = _declaringType.getIdentifier();
          boolean _notEquals = (!Objects.equal(_identifier, "java.lang.Object"));
          return Boolean.valueOf(_notEquals);
        }
      };
    Iterable<JvmOperation> _filter_2 = IterableExtensions.<JvmOperation>filter(_filter_1, _function_2);
    return _filter_2;
  }
  
  public Iterable<JvmOperation> jvmAllRequiredMethodOperations(final TJTraitReference e) {
    Iterable<JvmFeature> __jvmAllOperations = this._jvmAllOperations(e);
    Iterable<JvmOperation> _filter = Iterables.<JvmOperation>filter(__jvmAllOperations, JvmOperation.class);
    final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
        public Boolean apply(final JvmOperation it) {
          boolean _isRequiredMethod = TraitJJvmModelUtil.this.isRequiredMethod(it);
          return Boolean.valueOf(_isRequiredMethod);
        }
      };
    Iterable<JvmOperation> _filter_1 = IterableExtensions.<JvmOperation>filter(_filter, _function);
    return _filter_1;
  }
  
  public Iterable<JvmOperation> jvmAllRequiredMethodOperations(final TJTrait e) {
    Iterable<JvmOperation> _jvmAllOperations = this.jvmAllOperations(e);
    Iterable<JvmOperation> _filter = Iterables.<JvmOperation>filter(_jvmAllOperations, JvmOperation.class);
    final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
        public Boolean apply(final JvmOperation it) {
          boolean _isRequiredMethod = TraitJJvmModelUtil.this.isRequiredMethod(it);
          return Boolean.valueOf(_isRequiredMethod);
        }
      };
    Iterable<JvmOperation> _filter_1 = IterableExtensions.<JvmOperation>filter(_filter, _function);
    return _filter_1;
  }
  
  public Iterable<JvmOperation> jvmAllRequiredMethodOperations(final TJClass e) {
    Iterable<JvmOperation> _jvmAllRequiredMethodOperationsFromReferences = this.jvmAllRequiredMethodOperationsFromReferences(e);
    return _jvmAllRequiredMethodOperationsFromReferences;
  }
  
  public Iterable<JvmOperation> jvmAllRequiredMethodOperationsFromReferences(final TJDeclaration e) {
    TJTraitExpression _traitExpression = e.getTraitExpression();
    List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
    final Function1<TJTraitReference,Iterable<JvmOperation>> _function = new Function1<TJTraitReference,Iterable<JvmOperation>>() {
        public Iterable<JvmOperation> apply(final TJTraitReference it) {
          Iterable<JvmOperation> _jvmAllRequiredMethodOperations = TraitJJvmModelUtil.this.jvmAllRequiredMethodOperations(it);
          return _jvmAllRequiredMethodOperations;
        }
      };
    List<Iterable<JvmOperation>> _map = ListExtensions.<TJTraitReference, Iterable<JvmOperation>>map(_traitReferences, _function);
    Iterable<JvmOperation> _flatten = Iterables.<JvmOperation>concat(_map);
    return _flatten;
  }
  
  public Iterable<JvmOperation> jvmAllFieldOperations(final TJTrait e) {
    Iterable<JvmOperation> _jvmAllOperations = this.jvmAllOperations(e);
    Iterable<JvmOperation> _filter = Iterables.<JvmOperation>filter(_jvmAllOperations, JvmOperation.class);
    final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
        public Boolean apply(final JvmOperation it) {
          TJField _sourceField = TraitJJvmModelUtil.this.sourceField(it);
          boolean _notEquals = (!Objects.equal(_sourceField, null));
          return Boolean.valueOf(_notEquals);
        }
      };
    Iterable<JvmOperation> _filter_1 = IterableExtensions.<JvmOperation>filter(_filter, _function);
    return _filter_1;
  }
  
  public Iterable<JvmOperation> jvmAllFieldOperations(final TJTraitReference e) {
    Iterable<JvmFeature> __jvmAllOperations = this._jvmAllOperations(e);
    Iterable<JvmOperation> _filter = Iterables.<JvmOperation>filter(__jvmAllOperations, JvmOperation.class);
    final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
        public Boolean apply(final JvmOperation it) {
          TJField _sourceField = TraitJJvmModelUtil.this.sourceField(it);
          boolean _notEquals = (!Objects.equal(_sourceField, null));
          return Boolean.valueOf(_notEquals);
        }
      };
    Iterable<JvmOperation> _filter_1 = IterableExtensions.<JvmOperation>filter(_filter, _function);
    return _filter_1;
  }
  
  /**
   * Do not put the operations corresponding to set methods
   * since we want a single operation for each field (while
   * in Java there will be both getter and setter)
   */
  public Iterable<JvmOperation> jvmAllRequiredFieldOperations(final TJTraitReference e) {
    Iterable<JvmOperation> _jvmAllFieldOperations = this.jvmAllFieldOperations(e);
    final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
        public Boolean apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          boolean _startsWith = _simpleName.startsWith("set");
          boolean _not = (!_startsWith);
          return Boolean.valueOf(_not);
        }
      };
    Iterable<JvmOperation> _filter = IterableExtensions.<JvmOperation>filter(_jvmAllFieldOperations, _function);
    return _filter;
  }
  
  public Iterable<JvmOperation> jvmAllRequiredFieldOperations(final TJDeclaration e) {
    TJTraitExpression _traitExpression = e.getTraitExpression();
    List<TJTraitReference> _traitReferences = TraitJModelUtil.traitReferences(_traitExpression);
    final Function1<TJTraitReference,Iterable<JvmOperation>> _function = new Function1<TJTraitReference,Iterable<JvmOperation>>() {
        public Iterable<JvmOperation> apply(final TJTraitReference it) {
          Iterable<JvmOperation> _jvmAllRequiredFieldOperations = TraitJJvmModelUtil.this.jvmAllRequiredFieldOperations(it);
          return _jvmAllRequiredFieldOperations;
        }
      };
    List<Iterable<JvmOperation>> _map = ListExtensions.<TJTraitReference, Iterable<JvmOperation>>map(_traitReferences, _function);
    Iterable<JvmOperation> _flatten = Iterables.<JvmOperation>concat(_map);
    return _flatten;
  }
  
  public TJMember originalSource(final JvmMember o) {
    Set<EObject> _sourceElements = this._iJvmModelAssociations.getSourceElements(o);
    final Function1<EObject,Boolean> _function = new Function1<EObject,Boolean>() {
        public Boolean apply(final EObject it) {
          return Boolean.valueOf((it instanceof TJMember));
        }
      };
    EObject _findFirst = IterableExtensions.<EObject>findFirst(_sourceElements, _function);
    return ((TJMember) _findFirst);
  }
  
  public boolean defines(final TJTrait t, final JvmMember m) {
    EList<TJMember> _members = t.getMembers();
    final Function1<TJMember,Boolean> _function = new Function1<TJMember,Boolean>() {
        public Boolean apply(final TJMember it) {
          String _name = it.getName();
          String _simpleName = m.getSimpleName();
          boolean _equals = Objects.equal(_name, _simpleName);
          return Boolean.valueOf(_equals);
        }
      };
    boolean _exists = IterableExtensions.<TJMember>exists(_members, _function);
    return _exists;
  }
  
  public JvmOperation memberByName(final Iterable<JvmOperation> members, final String name) {
    final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
        public Boolean apply(final JvmOperation it) {
          String _simpleName = it.getSimpleName();
          boolean _equals = Objects.equal(name, _simpleName);
          return Boolean.valueOf(_equals);
        }
      };
    JvmOperation _findFirst = IterableExtensions.<JvmOperation>findFirst(members, _function);
    return _findFirst;
  }
  
  public boolean alreadyDefined(final Iterable<JvmMember> members, final JvmMember m) {
    final Function1<JvmMember,Boolean> _function = new Function1<JvmMember,Boolean>() {
        public Boolean apply(final JvmMember it) {
          String _simpleName = it.getSimpleName();
          String _simpleName_1 = m.getSimpleName();
          boolean _equals = Objects.equal(_simpleName, _simpleName_1);
          return Boolean.valueOf(_equals);
        }
      };
    boolean _exists = IterableExtensions.<JvmMember>exists(members, _function);
    return _exists;
  }
  
  public boolean isRequired(final JvmMember m) {
    Set<EObject> _sourceElements = this._iJvmModelAssociations.getSourceElements(m);
    final Function1<EObject,Boolean> _function = new Function1<EObject,Boolean>() {
        public Boolean apply(final EObject it) {
          boolean _or = false;
          boolean _or_1 = false;
          if ((it instanceof TJRequiredMethod)) {
            _or_1 = true;
          } else {
            _or_1 = ((it instanceof TJRequiredMethod) || (it instanceof TJField));
          }
          if (_or_1) {
            _or = true;
          } else {
            _or = (_or_1 || (it instanceof TJRestrictOperation));
          }
          return Boolean.valueOf(_or);
        }
      };
    boolean _exists = IterableExtensions.<EObject>exists(_sourceElements, _function);
    return _exists;
  }
  
  public boolean isRequiredMethod(final JvmMember m) {
    Set<EObject> _sourceElements = this._iJvmModelAssociations.getSourceElements(m);
    final Function1<EObject,Boolean> _function = new Function1<EObject,Boolean>() {
        public Boolean apply(final EObject it) {
          boolean _or = false;
          if ((it instanceof TJRequiredMethod)) {
            _or = true;
          } else {
            _or = ((it instanceof TJRequiredMethod) || (it instanceof TJRestrictOperation));
          }
          return Boolean.valueOf(_or);
        }
      };
    boolean _exists = IterableExtensions.<EObject>exists(_sourceElements, _function);
    return _exists;
  }
  
  public String memberRepresentation(final JvmMember m) {
    if ((m instanceof JvmOperation)) {
      final JvmOperation op = ((JvmOperation) m);
      TJField _sourceField = this.sourceField(op);
      boolean _notEquals = (!Objects.equal(_sourceField, null));
      if (_notEquals) {
        return this.fieldRepresentation(op);
      } else {
        return this.methodRepresentation(op);
      }
    } else {
      return m.getSimpleName();
    }
  }
  
  public String fieldRepresentation(final JvmOperation f) {
    JvmTypeReference _returnType = f.getReturnType();
    String _simpleName = null;
    if (_returnType!=null) {
      _simpleName=_returnType.getSimpleName();
    }
    String _plus = (_simpleName + " ");
    String _fieldName = this.fieldName(f);
    String _plus_1 = (_plus + _fieldName);
    return _plus_1;
  }
  
  public String methodRepresentation(final JvmOperation m) {
    JvmTypeReference _returnType = m.getReturnType();
    String _simpleName = null;
    if (_returnType!=null) {
      _simpleName=_returnType.getSimpleName();
    }
    String _plus = (_simpleName + " ");
    String _simpleName_1 = m.getSimpleName();
    String _plus_1 = (_plus + _simpleName_1);
    String _plus_2 = (_plus_1 + 
      "(");
    EList<JvmFormalParameter> _parameters = m.getParameters();
    final Function1<JvmFormalParameter,String> _function = new Function1<JvmFormalParameter,String>() {
        public String apply(final JvmFormalParameter it) {
          JvmTypeReference _parameterType = it.getParameterType();
          String _simpleName = null;
          if (_parameterType!=null) {
            _simpleName=_parameterType.getSimpleName();
          }
          return _simpleName;
        }
      };
    List<String> _map = ListExtensions.<JvmFormalParameter, String>map(_parameters, _function);
    String _join = IterableExtensions.join(_map, ", ");
    String _plus_3 = (_plus_2 + _join);
    String _plus_4 = (_plus_3 + ")");
    return _plus_4;
  }
  
  /**
   * To each field a JvmOperation will correspond in the Java model
   * which is the getter method, thus, we need to recover the
   * original field name.
   */
  public String fieldName(final JvmOperation f) {
    String _simpleName = f.getSimpleName();
    String _replaceFirst = _simpleName.replaceFirst("get", "");
    String _replaceFirst_1 = _replaceFirst.replaceFirst("is", "");
    String _firstLower = StringExtensions.toFirstLower(_replaceFirst_1);
    return _firstLower;
  }
  
  public TJField findMatchingField(final Iterable<? extends TJField> candidates, final JvmOperation member) {
    final Function1<TJField,Boolean> _function = new Function1<TJField,Boolean>() {
        public Boolean apply(final TJField it) {
          boolean _and = false;
          String _name = it.getName();
          String _fieldName = TraitJJvmModelUtil.this.fieldName(member);
          boolean _equals = Objects.equal(_name, _fieldName);
          if (!_equals) {
            _and = false;
          } else {
            JvmTypeReference _type = it.getType();
            JvmTypeReference _returnType = member.getReturnType();
            boolean _sameType = TraitJJvmModelUtil.this._traitJTypingUtil.sameType(_type, _returnType);
            _and = (_equals && _sameType);
          }
          return Boolean.valueOf(_and);
        }
      };
    TJField _findFirst = IterableExtensions.findFirst(candidates, _function);
    return _findFirst;
  }
  
  public JvmOperation findMatchingMethod(final Iterable<? extends JvmOperation> candidates, final JvmOperation member) {
    final Function1<JvmOperation,Boolean> _function = new Function1<JvmOperation,Boolean>() {
        public Boolean apply(final JvmOperation it) {
          boolean _and = false;
          String _simpleName = it.getSimpleName();
          String _simpleName_1 = member.getSimpleName();
          boolean _equals = Objects.equal(_simpleName, _simpleName_1);
          if (!_equals) {
            _and = false;
          } else {
            boolean _compliant = TraitJJvmModelUtil.this.compliant(it, member);
            _and = (_equals && _compliant);
          }
          return Boolean.valueOf(_and);
        }
      };
    JvmOperation _findFirst = IterableExtensions.findFirst(candidates, _function);
    return _findFirst;
  }
  
  /**
   * it's return type must be subtype of member's return type
   * and parameters' types must be the same
   */
  public boolean compliant(final JvmOperation it, final JvmOperation member) {
    boolean _and = false;
    boolean _and_1 = false;
    JvmTypeReference _returnType = it.getReturnType();
    JvmTypeReference _returnType_1 = member.getReturnType();
    boolean _isSubtype = this._traitJTypingUtil.isSubtype(_returnType, _returnType_1);
    if (!_isSubtype) {
      _and_1 = false;
    } else {
      EList<JvmFormalParameter> _parameters = it.getParameters();
      int _size = _parameters.size();
      EList<JvmFormalParameter> _parameters_1 = member.getParameters();
      int _size_1 = _parameters_1.size();
      boolean _equals = (_size == _size_1);
      _and_1 = (_isSubtype && _equals);
    }
    if (!_and_1) {
      _and = false;
    } else {
      boolean _xblockexpression = false;
      {
        boolean ok = true;
        EList<JvmFormalParameter> _parameters_2 = it.getParameters();
        final Iterator<JvmFormalParameter> paramIterator = _parameters_2.iterator();
        EList<JvmFormalParameter> _parameters_3 = member.getParameters();
        final Iterator<JvmFormalParameter> memberParamIterator = _parameters_3.iterator();
        boolean _and_2 = false;
        boolean _hasNext = paramIterator.hasNext();
        if (!_hasNext) {
          _and_2 = false;
        } else {
          _and_2 = (_hasNext && ok);
        }
        boolean _while = _and_2;
        while (_while) {
          JvmFormalParameter _next = paramIterator.next();
          JvmTypeReference _parameterType = _next.getParameterType();
          JvmFormalParameter _next_1 = memberParamIterator.next();
          JvmTypeReference _parameterType_1 = _next_1.getParameterType();
          boolean _sameType = this._traitJTypingUtil.sameType(_parameterType, _parameterType_1);
          boolean _not = (!_sameType);
          if (_not) {
            ok = false;
          }
          boolean _and_3 = false;
          boolean _hasNext_1 = paramIterator.hasNext();
          if (!_hasNext_1) {
            _and_3 = false;
          } else {
            _and_3 = (_hasNext_1 && ok);
          }
          _while = _and_3;
        }
        _xblockexpression = (ok);
      }
      _and = (_and_1 && _xblockexpression);
    }
    return _and;
  }
  
  public boolean compliant(final JvmMember m1, final JvmMember m2) {
    try {
      return this.compliant(((JvmOperation) m1), ((JvmOperation) m2));
    } catch (final Throwable _t) {
      if (_t instanceof Throwable) {
        final Throwable t = (Throwable)_t;
        return false;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
  }
  
  public String renameGetterOrSetter(final String opName, final String newname) {
    boolean _and = false;
    boolean _and_1 = false;
    boolean _startsWith = opName.startsWith("get");
    if (!_startsWith) {
      _and_1 = false;
    } else {
      int _length = opName.length();
      boolean _greaterThan = (_length > 3);
      _and_1 = (_startsWith && _greaterThan);
    }
    if (!_and_1) {
      _and = false;
    } else {
      char _charAt = opName.charAt(3);
      boolean _isUpperCase = Character.isUpperCase(_charAt);
      _and = (_and_1 && _isUpperCase);
    }
    if (_and) {
      String _firstUpper = StringExtensions.toFirstUpper(newname);
      return ("get" + _firstUpper);
    }
    boolean _and_2 = false;
    boolean _and_3 = false;
    boolean _startsWith_1 = opName.startsWith("is");
    if (!_startsWith_1) {
      _and_3 = false;
    } else {
      int _length_1 = opName.length();
      boolean _greaterThan_1 = (_length_1 > 2);
      _and_3 = (_startsWith_1 && _greaterThan_1);
    }
    if (!_and_3) {
      _and_2 = false;
    } else {
      char _charAt_1 = opName.charAt(2);
      boolean _isUpperCase_1 = Character.isUpperCase(_charAt_1);
      _and_2 = (_and_3 && _isUpperCase_1);
    }
    if (_and_2) {
      String _firstUpper_1 = StringExtensions.toFirstUpper(newname);
      return ("is" + _firstUpper_1);
    }
    boolean _and_4 = false;
    boolean _and_5 = false;
    boolean _startsWith_2 = opName.startsWith("set");
    if (!_startsWith_2) {
      _and_5 = false;
    } else {
      int _length_2 = opName.length();
      boolean _greaterThan_2 = (_length_2 > 3);
      _and_5 = (_startsWith_2 && _greaterThan_2);
    }
    if (!_and_5) {
      _and_4 = false;
    } else {
      char _charAt_2 = opName.charAt(3);
      boolean _isUpperCase_2 = Character.isUpperCase(_charAt_2);
      _and_4 = (_and_5 && _isUpperCase_2);
    }
    if (_and_4) {
      String _firstUpper_2 = StringExtensions.toFirstUpper(newname);
      return ("set" + _firstUpper_2);
    }
    return newname;
  }
  
  public String stripGetter(final String opName) {
    boolean _and = false;
    boolean _and_1 = false;
    boolean _startsWith = opName.startsWith("get");
    if (!_startsWith) {
      _and_1 = false;
    } else {
      int _length = opName.length();
      boolean _greaterThan = (_length > 3);
      _and_1 = (_startsWith && _greaterThan);
    }
    if (!_and_1) {
      _and = false;
    } else {
      char _charAt = opName.charAt(3);
      boolean _isUpperCase = Character.isUpperCase(_charAt);
      _and = (_and_1 && _isUpperCase);
    }
    if (_and) {
      String _substring = opName.substring(3);
      return Introspector.decapitalize(_substring);
    }
    boolean _and_2 = false;
    boolean _and_3 = false;
    boolean _startsWith_1 = opName.startsWith("is");
    if (!_startsWith_1) {
      _and_3 = false;
    } else {
      int _length_1 = opName.length();
      boolean _greaterThan_1 = (_length_1 > 2);
      _and_3 = (_startsWith_1 && _greaterThan_1);
    }
    if (!_and_3) {
      _and_2 = false;
    } else {
      char _charAt_1 = opName.charAt(2);
      boolean _isUpperCase_1 = Character.isUpperCase(_charAt_1);
      _and_2 = (_and_3 && _isUpperCase_1);
    }
    if (_and_2) {
      String _substring_1 = opName.substring(2);
      return Introspector.decapitalize(_substring_1);
    }
    return opName;
  }
  
  public boolean isValidInterface(final JvmParameterizedTypeReference t) {
    boolean _xtrycatchfinallyexpression = false;
    try {
      JvmType _type = t.getType();
      boolean _isInterface = ((JvmGenericType) _type).isInterface();
      _xtrycatchfinallyexpression = _isInterface;
    } catch (final Throwable _t) {
      if (_t instanceof Throwable) {
        final Throwable e = (Throwable)_t;
        return false;
      } else {
        throw Exceptions.sneakyThrow(_t);
      }
    }
    return _xtrycatchfinallyexpression;
  }
  
  public boolean conflictsWith(final JvmOperation f1, final JvmOperation f2) {
    boolean _and = false;
    boolean _and_1 = false;
    boolean _notEquals = (!Objects.equal(f1, f2));
    if (!_notEquals) {
      _and_1 = false;
    } else {
      String _simpleName = f1.getSimpleName();
      String _simpleName_1 = f2.getSimpleName();
      boolean _equals = Objects.equal(_simpleName, _simpleName_1);
      _and_1 = (_notEquals && _equals);
    }
    if (!_and_1) {
      _and = false;
    } else {
      boolean _compliant = this.compliant(f1, f2);
      boolean _not = (!_compliant);
      _and = (_and_1 && _not);
    }
    return _and;
  }
}

/**
 */
package xtraitj.xtraitj.impl;

import java.util.Collection;

import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;

import org.eclipse.xtext.common.types.JvmParameterizedTypeReference;

import xtraitj.xtraitj.TJClass;
import xtraitj.xtraitj.TJConstructor;
import xtraitj.xtraitj.TJField;
import xtraitj.xtraitj.XtraitjPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>TJ Class</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.impl.TJClassImpl#getInterfaces <em>Interfaces</em>}</li>
 *   <li>{@link xtraitj.xtraitj.impl.TJClassImpl#getFields <em>Fields</em>}</li>
 *   <li>{@link xtraitj.xtraitj.impl.TJClassImpl#getConstructors <em>Constructors</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class TJClassImpl extends TJDeclarationImpl implements TJClass
{
  /**
   * The cached value of the '{@link #getInterfaces() <em>Interfaces</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getInterfaces()
   * @generated
   * @ordered
   */
  protected EList<JvmParameterizedTypeReference> interfaces;

  /**
   * The cached value of the '{@link #getFields() <em>Fields</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getFields()
   * @generated
   * @ordered
   */
  protected EList<TJField> fields;

  /**
   * The cached value of the '{@link #getConstructors() <em>Constructors</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getConstructors()
   * @generated
   * @ordered
   */
  protected EList<TJConstructor> constructors;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected TJClassImpl()
  {
    super();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  protected EClass eStaticClass()
  {
    return XtraitjPackage.Literals.TJ_CLASS;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<JvmParameterizedTypeReference> getInterfaces()
  {
    if (interfaces == null)
    {
      interfaces = new EObjectContainmentEList<JvmParameterizedTypeReference>(JvmParameterizedTypeReference.class, this, XtraitjPackage.TJ_CLASS__INTERFACES);
    }
    return interfaces;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<TJField> getFields()
  {
    if (fields == null)
    {
      fields = new EObjectContainmentEList<TJField>(TJField.class, this, XtraitjPackage.TJ_CLASS__FIELDS);
    }
    return fields;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<TJConstructor> getConstructors()
  {
    if (constructors == null)
    {
      constructors = new EObjectContainmentEList<TJConstructor>(TJConstructor.class, this, XtraitjPackage.TJ_CLASS__CONSTRUCTORS);
    }
    return constructors;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public NotificationChain eInverseRemove(InternalEObject otherEnd, int featureID, NotificationChain msgs)
  {
    switch (featureID)
    {
      case XtraitjPackage.TJ_CLASS__INTERFACES:
        return ((InternalEList<?>)getInterfaces()).basicRemove(otherEnd, msgs);
      case XtraitjPackage.TJ_CLASS__FIELDS:
        return ((InternalEList<?>)getFields()).basicRemove(otherEnd, msgs);
      case XtraitjPackage.TJ_CLASS__CONSTRUCTORS:
        return ((InternalEList<?>)getConstructors()).basicRemove(otherEnd, msgs);
    }
    return super.eInverseRemove(otherEnd, featureID, msgs);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public Object eGet(int featureID, boolean resolve, boolean coreType)
  {
    switch (featureID)
    {
      case XtraitjPackage.TJ_CLASS__INTERFACES:
        return getInterfaces();
      case XtraitjPackage.TJ_CLASS__FIELDS:
        return getFields();
      case XtraitjPackage.TJ_CLASS__CONSTRUCTORS:
        return getConstructors();
    }
    return super.eGet(featureID, resolve, coreType);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @SuppressWarnings("unchecked")
  @Override
  public void eSet(int featureID, Object newValue)
  {
    switch (featureID)
    {
      case XtraitjPackage.TJ_CLASS__INTERFACES:
        getInterfaces().clear();
        getInterfaces().addAll((Collection<? extends JvmParameterizedTypeReference>)newValue);
        return;
      case XtraitjPackage.TJ_CLASS__FIELDS:
        getFields().clear();
        getFields().addAll((Collection<? extends TJField>)newValue);
        return;
      case XtraitjPackage.TJ_CLASS__CONSTRUCTORS:
        getConstructors().clear();
        getConstructors().addAll((Collection<? extends TJConstructor>)newValue);
        return;
    }
    super.eSet(featureID, newValue);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eUnset(int featureID)
  {
    switch (featureID)
    {
      case XtraitjPackage.TJ_CLASS__INTERFACES:
        getInterfaces().clear();
        return;
      case XtraitjPackage.TJ_CLASS__FIELDS:
        getFields().clear();
        return;
      case XtraitjPackage.TJ_CLASS__CONSTRUCTORS:
        getConstructors().clear();
        return;
    }
    super.eUnset(featureID);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public boolean eIsSet(int featureID)
  {
    switch (featureID)
    {
      case XtraitjPackage.TJ_CLASS__INTERFACES:
        return interfaces != null && !interfaces.isEmpty();
      case XtraitjPackage.TJ_CLASS__FIELDS:
        return fields != null && !fields.isEmpty();
      case XtraitjPackage.TJ_CLASS__CONSTRUCTORS:
        return constructors != null && !constructors.isEmpty();
    }
    return super.eIsSet(featureID);
  }

} //TJClassImpl

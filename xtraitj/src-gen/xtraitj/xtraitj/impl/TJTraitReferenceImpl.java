/**
 */
package xtraitj.xtraitj.impl;

import java.util.Collection;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import org.eclipse.emf.ecore.util.EObjectContainmentEList;
import org.eclipse.emf.ecore.util.InternalEList;

import xtraitj.xtraitj.TJTrait;
import xtraitj.xtraitj.TJTraitOperation;
import xtraitj.xtraitj.TJTraitReference;
import xtraitj.xtraitj.XtraitjPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>TJ Trait Reference</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.impl.TJTraitReferenceImpl#getTrait <em>Trait</em>}</li>
 *   <li>{@link xtraitj.xtraitj.impl.TJTraitReferenceImpl#getOperations <em>Operations</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class TJTraitReferenceImpl extends MinimalEObjectImpl.Container implements TJTraitReference
{
  /**
   * The cached value of the '{@link #getTrait() <em>Trait</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getTrait()
   * @generated
   * @ordered
   */
  protected TJTrait trait;

  /**
   * The cached value of the '{@link #getOperations() <em>Operations</em>}' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getOperations()
   * @generated
   * @ordered
   */
  protected EList<TJTraitOperation> operations;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected TJTraitReferenceImpl()
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
    return XtraitjPackage.Literals.TJ_TRAIT_REFERENCE;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJTrait getTrait()
  {
    if (trait != null && trait.eIsProxy())
    {
      InternalEObject oldTrait = (InternalEObject)trait;
      trait = (TJTrait)eResolveProxy(oldTrait);
      if (trait != oldTrait)
      {
        if (eNotificationRequired())
          eNotify(new ENotificationImpl(this, Notification.RESOLVE, XtraitjPackage.TJ_TRAIT_REFERENCE__TRAIT, oldTrait, trait));
      }
    }
    return trait;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJTrait basicGetTrait()
  {
    return trait;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setTrait(TJTrait newTrait)
  {
    TJTrait oldTrait = trait;
    trait = newTrait;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, XtraitjPackage.TJ_TRAIT_REFERENCE__TRAIT, oldTrait, trait));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EList<TJTraitOperation> getOperations()
  {
    if (operations == null)
    {
      operations = new EObjectContainmentEList<TJTraitOperation>(TJTraitOperation.class, this, XtraitjPackage.TJ_TRAIT_REFERENCE__OPERATIONS);
    }
    return operations;
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
      case XtraitjPackage.TJ_TRAIT_REFERENCE__OPERATIONS:
        return ((InternalEList<?>)getOperations()).basicRemove(otherEnd, msgs);
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
      case XtraitjPackage.TJ_TRAIT_REFERENCE__TRAIT:
        if (resolve) return getTrait();
        return basicGetTrait();
      case XtraitjPackage.TJ_TRAIT_REFERENCE__OPERATIONS:
        return getOperations();
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
      case XtraitjPackage.TJ_TRAIT_REFERENCE__TRAIT:
        setTrait((TJTrait)newValue);
        return;
      case XtraitjPackage.TJ_TRAIT_REFERENCE__OPERATIONS:
        getOperations().clear();
        getOperations().addAll((Collection<? extends TJTraitOperation>)newValue);
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
      case XtraitjPackage.TJ_TRAIT_REFERENCE__TRAIT:
        setTrait((TJTrait)null);
        return;
      case XtraitjPackage.TJ_TRAIT_REFERENCE__OPERATIONS:
        getOperations().clear();
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
      case XtraitjPackage.TJ_TRAIT_REFERENCE__TRAIT:
        return trait != null;
      case XtraitjPackage.TJ_TRAIT_REFERENCE__OPERATIONS:
        return operations != null && !operations.isEmpty();
    }
    return super.eIsSet(featureID);
  }

} //TJTraitReferenceImpl

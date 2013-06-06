/**
 */
package xtraitj.xtraitj.impl;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import org.eclipse.xtext.common.types.JvmMember;

import xtraitj.xtraitj.TJRedirectOperation;
import xtraitj.xtraitj.XtraitjPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>TJ Redirect Operation</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.impl.TJRedirectOperationImpl#getMember2 <em>Member2</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class TJRedirectOperationImpl extends TJTraitOperationImpl implements TJRedirectOperation
{
  /**
   * The cached value of the '{@link #getMember2() <em>Member2</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getMember2()
   * @generated
   * @ordered
   */
  protected JvmMember member2;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected TJRedirectOperationImpl()
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
    return XtraitjPackage.Literals.TJ_REDIRECT_OPERATION;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public JvmMember getMember2()
  {
    if (member2 != null && member2.eIsProxy())
    {
      InternalEObject oldMember2 = (InternalEObject)member2;
      member2 = (JvmMember)eResolveProxy(oldMember2);
      if (member2 != oldMember2)
      {
        if (eNotificationRequired())
          eNotify(new ENotificationImpl(this, Notification.RESOLVE, XtraitjPackage.TJ_REDIRECT_OPERATION__MEMBER2, oldMember2, member2));
      }
    }
    return member2;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public JvmMember basicGetMember2()
  {
    return member2;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setMember2(JvmMember newMember2)
  {
    JvmMember oldMember2 = member2;
    member2 = newMember2;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, XtraitjPackage.TJ_REDIRECT_OPERATION__MEMBER2, oldMember2, member2));
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
      case XtraitjPackage.TJ_REDIRECT_OPERATION__MEMBER2:
        if (resolve) return getMember2();
        return basicGetMember2();
    }
    return super.eGet(featureID, resolve, coreType);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public void eSet(int featureID, Object newValue)
  {
    switch (featureID)
    {
      case XtraitjPackage.TJ_REDIRECT_OPERATION__MEMBER2:
        setMember2((JvmMember)newValue);
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
      case XtraitjPackage.TJ_REDIRECT_OPERATION__MEMBER2:
        setMember2((JvmMember)null);
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
      case XtraitjPackage.TJ_REDIRECT_OPERATION__MEMBER2:
        return member2 != null;
    }
    return super.eIsSet(featureID);
  }

} //TJRedirectOperationImpl

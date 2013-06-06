/**
 */
package xtraitj.xtraitj.impl;

import org.eclipse.emf.common.notify.Notification;

import org.eclipse.emf.ecore.EClass;

import org.eclipse.emf.ecore.impl.ENotificationImpl;

import xtraitj.xtraitj.TJAliasOperation;
import xtraitj.xtraitj.XtraitjPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>TJ Alias Operation</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.impl.TJAliasOperationImpl#getNewname <em>Newname</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class TJAliasOperationImpl extends TjTraitOperationForProvidedImpl implements TJAliasOperation
{
  /**
   * The default value of the '{@link #getNewname() <em>Newname</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getNewname()
   * @generated
   * @ordered
   */
  protected static final String NEWNAME_EDEFAULT = null;

  /**
   * The cached value of the '{@link #getNewname() <em>Newname</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getNewname()
   * @generated
   * @ordered
   */
  protected String newname = NEWNAME_EDEFAULT;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected TJAliasOperationImpl()
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
    return XtraitjPackage.Literals.TJ_ALIAS_OPERATION;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public String getNewname()
  {
    return newname;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setNewname(String newNewname)
  {
    String oldNewname = newname;
    newname = newNewname;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, XtraitjPackage.TJ_ALIAS_OPERATION__NEWNAME, oldNewname, newname));
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
      case XtraitjPackage.TJ_ALIAS_OPERATION__NEWNAME:
        return getNewname();
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
      case XtraitjPackage.TJ_ALIAS_OPERATION__NEWNAME:
        setNewname((String)newValue);
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
      case XtraitjPackage.TJ_ALIAS_OPERATION__NEWNAME:
        setNewname(NEWNAME_EDEFAULT);
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
      case XtraitjPackage.TJ_ALIAS_OPERATION__NEWNAME:
        return NEWNAME_EDEFAULT == null ? newname != null : !NEWNAME_EDEFAULT.equals(newname);
    }
    return super.eIsSet(featureID);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public String toString()
  {
    if (eIsProxy()) return super.toString();

    StringBuffer result = new StringBuffer(super.toString());
    result.append(" (newname: ");
    result.append(newname);
    result.append(')');
    return result.toString();
  }

} //TJAliasOperationImpl

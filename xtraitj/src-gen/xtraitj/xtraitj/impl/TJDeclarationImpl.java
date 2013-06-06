/**
 */
package xtraitj.xtraitj.impl;

import org.eclipse.emf.common.notify.Notification;
import org.eclipse.emf.common.notify.NotificationChain;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.InternalEObject;

import org.eclipse.emf.ecore.impl.ENotificationImpl;
import org.eclipse.emf.ecore.impl.MinimalEObjectImpl;

import xtraitj.xtraitj.TJDeclaration;
import xtraitj.xtraitj.TJTraitExpression;
import xtraitj.xtraitj.XtraitjPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model object '<em><b>TJ Declaration</b></em>'.
 * <!-- end-user-doc -->
 * <p>
 * The following features are implemented:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.impl.TJDeclarationImpl#getName <em>Name</em>}</li>
 *   <li>{@link xtraitj.xtraitj.impl.TJDeclarationImpl#getTraitExpression <em>Trait Expression</em>}</li>
 * </ul>
 * </p>
 *
 * @generated
 */
public class TJDeclarationImpl extends MinimalEObjectImpl.Container implements TJDeclaration
{
  /**
   * The default value of the '{@link #getName() <em>Name</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getName()
   * @generated
   * @ordered
   */
  protected static final String NAME_EDEFAULT = null;

  /**
   * The cached value of the '{@link #getName() <em>Name</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getName()
   * @generated
   * @ordered
   */
  protected String name = NAME_EDEFAULT;

  /**
   * The cached value of the '{@link #getTraitExpression() <em>Trait Expression</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #getTraitExpression()
   * @generated
   * @ordered
   */
  protected TJTraitExpression traitExpression;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected TJDeclarationImpl()
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
    return XtraitjPackage.Literals.TJ_DECLARATION;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public String getName()
  {
    return name;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setName(String newName)
  {
    String oldName = name;
    name = newName;
    if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, XtraitjPackage.TJ_DECLARATION__NAME, oldName, name));
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJTraitExpression getTraitExpression()
  {
    return traitExpression;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public NotificationChain basicSetTraitExpression(TJTraitExpression newTraitExpression, NotificationChain msgs)
  {
    TJTraitExpression oldTraitExpression = traitExpression;
    traitExpression = newTraitExpression;
    if (eNotificationRequired())
    {
      ENotificationImpl notification = new ENotificationImpl(this, Notification.SET, XtraitjPackage.TJ_DECLARATION__TRAIT_EXPRESSION, oldTraitExpression, newTraitExpression);
      if (msgs == null) msgs = notification; else msgs.add(notification);
    }
    return msgs;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void setTraitExpression(TJTraitExpression newTraitExpression)
  {
    if (newTraitExpression != traitExpression)
    {
      NotificationChain msgs = null;
      if (traitExpression != null)
        msgs = ((InternalEObject)traitExpression).eInverseRemove(this, EOPPOSITE_FEATURE_BASE - XtraitjPackage.TJ_DECLARATION__TRAIT_EXPRESSION, null, msgs);
      if (newTraitExpression != null)
        msgs = ((InternalEObject)newTraitExpression).eInverseAdd(this, EOPPOSITE_FEATURE_BASE - XtraitjPackage.TJ_DECLARATION__TRAIT_EXPRESSION, null, msgs);
      msgs = basicSetTraitExpression(newTraitExpression, msgs);
      if (msgs != null) msgs.dispatch();
    }
    else if (eNotificationRequired())
      eNotify(new ENotificationImpl(this, Notification.SET, XtraitjPackage.TJ_DECLARATION__TRAIT_EXPRESSION, newTraitExpression, newTraitExpression));
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
      case XtraitjPackage.TJ_DECLARATION__TRAIT_EXPRESSION:
        return basicSetTraitExpression(null, msgs);
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
      case XtraitjPackage.TJ_DECLARATION__NAME:
        return getName();
      case XtraitjPackage.TJ_DECLARATION__TRAIT_EXPRESSION:
        return getTraitExpression();
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
      case XtraitjPackage.TJ_DECLARATION__NAME:
        setName((String)newValue);
        return;
      case XtraitjPackage.TJ_DECLARATION__TRAIT_EXPRESSION:
        setTraitExpression((TJTraitExpression)newValue);
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
      case XtraitjPackage.TJ_DECLARATION__NAME:
        setName(NAME_EDEFAULT);
        return;
      case XtraitjPackage.TJ_DECLARATION__TRAIT_EXPRESSION:
        setTraitExpression((TJTraitExpression)null);
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
      case XtraitjPackage.TJ_DECLARATION__NAME:
        return NAME_EDEFAULT == null ? name != null : !NAME_EDEFAULT.equals(name);
      case XtraitjPackage.TJ_DECLARATION__TRAIT_EXPRESSION:
        return traitExpression != null;
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
    result.append(" (name: ");
    result.append(name);
    result.append(')');
    return result.toString();
  }

} //TJDeclarationImpl

/**
 */
package xtraitj.xtraitj;

import org.eclipse.emf.ecore.EObject;

import org.eclipse.xtext.common.types.JvmMember;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>TJ Trait Operation</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.TJTraitOperation#getMember <em>Member</em>}</li>
 * </ul>
 * </p>
 *
 * @see xtraitj.xtraitj.XtraitjPackage#getTJTraitOperation()
 * @model
 * @generated
 */
public interface TJTraitOperation extends EObject
{
  /**
   * Returns the value of the '<em><b>Member</b></em>' reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Member</em>' reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Member</em>' reference.
   * @see #setMember(JvmMember)
   * @see xtraitj.xtraitj.XtraitjPackage#getTJTraitOperation_Member()
   * @model
   * @generated
   */
  JvmMember getMember();

  /**
   * Sets the value of the '{@link xtraitj.xtraitj.TJTraitOperation#getMember <em>Member</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Member</em>' reference.
   * @see #getMember()
   * @generated
   */
  void setMember(JvmMember value);

} // TJTraitOperation

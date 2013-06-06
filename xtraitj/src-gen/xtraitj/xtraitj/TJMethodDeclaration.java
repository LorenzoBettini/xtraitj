/**
 */
package xtraitj.xtraitj;

import org.eclipse.emf.common.util.EList;

import org.eclipse.xtext.common.types.JvmFormalParameter;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>TJ Method Declaration</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.TJMethodDeclaration#getParams <em>Params</em>}</li>
 * </ul>
 * </p>
 *
 * @see xtraitj.xtraitj.XtraitjPackage#getTJMethodDeclaration()
 * @model
 * @generated
 */
public interface TJMethodDeclaration extends TJMember
{
  /**
   * Returns the value of the '<em><b>Params</b></em>' containment reference list.
   * The list contents are of type {@link org.eclipse.xtext.common.types.JvmFormalParameter}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Params</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Params</em>' containment reference list.
   * @see xtraitj.xtraitj.XtraitjPackage#getTJMethodDeclaration_Params()
   * @model containment="true"
   * @generated
   */
  EList<JvmFormalParameter> getParams();

} // TJMethodDeclaration

/**
 */
package xtraitj.xtraitj;

import org.eclipse.emf.common.util.EList;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>TJ Trait</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.TJTrait#getMembers <em>Members</em>}</li>
 * </ul>
 * </p>
 *
 * @see xtraitj.xtraitj.XtraitjPackage#getTJTrait()
 * @model
 * @generated
 */
public interface TJTrait extends TJDeclaration
{
  /**
   * Returns the value of the '<em><b>Members</b></em>' containment reference list.
   * The list contents are of type {@link xtraitj.xtraitj.TJMember}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Members</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Members</em>' containment reference list.
   * @see xtraitj.xtraitj.XtraitjPackage#getTJTrait_Members()
   * @model containment="true"
   * @generated
   */
  EList<TJMember> getMembers();

} // TJTrait

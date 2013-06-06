/**
 */
package xtraitj.xtraitj;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>TJ Trait Expression</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.TJTraitExpression#getReferences <em>References</em>}</li>
 * </ul>
 * </p>
 *
 * @see xtraitj.xtraitj.XtraitjPackage#getTJTraitExpression()
 * @model
 * @generated
 */
public interface TJTraitExpression extends EObject
{
  /**
   * Returns the value of the '<em><b>References</b></em>' containment reference list.
   * The list contents are of type {@link xtraitj.xtraitj.TJTraitReference}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>References</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>References</em>' containment reference list.
   * @see xtraitj.xtraitj.XtraitjPackage#getTJTraitExpression_References()
   * @model containment="true"
   * @generated
   */
  EList<TJTraitReference> getReferences();

} // TJTraitExpression

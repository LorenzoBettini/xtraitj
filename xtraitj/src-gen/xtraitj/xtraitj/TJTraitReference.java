/**
 */
package xtraitj.xtraitj;

import org.eclipse.emf.common.util.EList;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>TJ Trait Reference</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.TJTraitReference#getTrait <em>Trait</em>}</li>
 *   <li>{@link xtraitj.xtraitj.TJTraitReference#getOperations <em>Operations</em>}</li>
 * </ul>
 * </p>
 *
 * @see xtraitj.xtraitj.XtraitjPackage#getTJTraitReference()
 * @model
 * @generated
 */
public interface TJTraitReference extends EObject
{
  /**
   * Returns the value of the '<em><b>Trait</b></em>' reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Trait</em>' reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Trait</em>' reference.
   * @see #setTrait(TJTrait)
   * @see xtraitj.xtraitj.XtraitjPackage#getTJTraitReference_Trait()
   * @model
   * @generated
   */
  TJTrait getTrait();

  /**
   * Sets the value of the '{@link xtraitj.xtraitj.TJTraitReference#getTrait <em>Trait</em>}' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Trait</em>' reference.
   * @see #getTrait()
   * @generated
   */
  void setTrait(TJTrait value);

  /**
   * Returns the value of the '<em><b>Operations</b></em>' containment reference list.
   * The list contents are of type {@link xtraitj.xtraitj.TJTraitOperation}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Operations</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Operations</em>' containment reference list.
   * @see xtraitj.xtraitj.XtraitjPackage#getTJTraitReference_Operations()
   * @model containment="true"
   * @generated
   */
  EList<TJTraitOperation> getOperations();

} // TJTraitReference

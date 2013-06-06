/**
 */
package xtraitj.xtraitj;

import org.eclipse.emf.ecore.EObject;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>TJ Declaration</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.TJDeclaration#getName <em>Name</em>}</li>
 *   <li>{@link xtraitj.xtraitj.TJDeclaration#getTraitExpression <em>Trait Expression</em>}</li>
 * </ul>
 * </p>
 *
 * @see xtraitj.xtraitj.XtraitjPackage#getTJDeclaration()
 * @model
 * @generated
 */
public interface TJDeclaration extends EObject
{
  /**
   * Returns the value of the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Name</em>' attribute isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Name</em>' attribute.
   * @see #setName(String)
   * @see xtraitj.xtraitj.XtraitjPackage#getTJDeclaration_Name()
   * @model
   * @generated
   */
  String getName();

  /**
   * Sets the value of the '{@link xtraitj.xtraitj.TJDeclaration#getName <em>Name</em>}' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Name</em>' attribute.
   * @see #getName()
   * @generated
   */
  void setName(String value);

  /**
   * Returns the value of the '<em><b>Trait Expression</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Trait Expression</em>' containment reference isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Trait Expression</em>' containment reference.
   * @see #setTraitExpression(TJTraitExpression)
   * @see xtraitj.xtraitj.XtraitjPackage#getTJDeclaration_TraitExpression()
   * @model containment="true"
   * @generated
   */
  TJTraitExpression getTraitExpression();

  /**
   * Sets the value of the '{@link xtraitj.xtraitj.TJDeclaration#getTraitExpression <em>Trait Expression</em>}' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param value the new value of the '<em>Trait Expression</em>' containment reference.
   * @see #getTraitExpression()
   * @generated
   */
  void setTraitExpression(TJTraitExpression value);

} // TJDeclaration

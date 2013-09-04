/**
 */
package xtraitj.xtraitj;

import org.eclipse.emf.common.util.EList;

import org.eclipse.xtext.common.types.JvmParameterizedTypeReference;

/**
 * <!-- begin-user-doc -->
 * A representation of the model object '<em><b>TJ Class</b></em>'.
 * <!-- end-user-doc -->
 *
 * <p>
 * The following features are supported:
 * <ul>
 *   <li>{@link xtraitj.xtraitj.TJClass#getInterfaces <em>Interfaces</em>}</li>
 *   <li>{@link xtraitj.xtraitj.TJClass#getFields <em>Fields</em>}</li>
 *   <li>{@link xtraitj.xtraitj.TJClass#getConstructors <em>Constructors</em>}</li>
 * </ul>
 * </p>
 *
 * @see xtraitj.xtraitj.XtraitjPackage#getTJClass()
 * @model
 * @generated
 */
public interface TJClass extends TJDeclaration
{
  /**
   * Returns the value of the '<em><b>Interfaces</b></em>' containment reference list.
   * The list contents are of type {@link org.eclipse.xtext.common.types.JvmParameterizedTypeReference}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Interfaces</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Interfaces</em>' containment reference list.
   * @see xtraitj.xtraitj.XtraitjPackage#getTJClass_Interfaces()
   * @model containment="true"
   * @generated
   */
  EList<JvmParameterizedTypeReference> getInterfaces();

  /**
   * Returns the value of the '<em><b>Fields</b></em>' containment reference list.
   * The list contents are of type {@link xtraitj.xtraitj.TJField}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Fields</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Fields</em>' containment reference list.
   * @see xtraitj.xtraitj.XtraitjPackage#getTJClass_Fields()
   * @model containment="true"
   * @generated
   */
  EList<TJField> getFields();

  /**
   * Returns the value of the '<em><b>Constructors</b></em>' containment reference list.
   * The list contents are of type {@link xtraitj.xtraitj.TJConstructor}.
   * <!-- begin-user-doc -->
   * <p>
   * If the meaning of the '<em>Constructors</em>' containment reference list isn't clear,
   * there really should be more of a description here...
   * </p>
   * <!-- end-user-doc -->
   * @return the value of the '<em>Constructors</em>' containment reference list.
   * @see xtraitj.xtraitj.XtraitjPackage#getTJClass_Constructors()
   * @model containment="true"
   * @generated
   */
  EList<TJConstructor> getConstructors();

} // TJClass

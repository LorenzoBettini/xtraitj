/**
 */
package xtraitj.xtraitj;

import org.eclipse.emf.ecore.EFactory;

/**
 * <!-- begin-user-doc -->
 * The <b>Factory</b> for the model.
 * It provides a create method for each non-abstract class of the model.
 * <!-- end-user-doc -->
 * @see xtraitj.xtraitj.XtraitjPackage
 * @generated
 */
public interface XtraitjFactory extends EFactory
{
  /**
   * The singleton instance of the factory.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  XtraitjFactory eINSTANCE = xtraitj.xtraitj.impl.XtraitjFactoryImpl.init();

  /**
   * Returns a new object of class '<em>TJ Program</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Program</em>'.
   * @generated
   */
  TJProgram createTJProgram();

  /**
   * Returns a new object of class '<em>TJ Declaration</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Declaration</em>'.
   * @generated
   */
  TJDeclaration createTJDeclaration();

  /**
   * Returns a new object of class '<em>TJ Trait</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Trait</em>'.
   * @generated
   */
  TJTrait createTJTrait();

  /**
   * Returns a new object of class '<em>TJ Class</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Class</em>'.
   * @generated
   */
  TJClass createTJClass();

  /**
   * Returns a new object of class '<em>TJ Trait Expression</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Trait Expression</em>'.
   * @generated
   */
  TJTraitExpression createTJTraitExpression();

  /**
   * Returns a new object of class '<em>TJ Trait Reference</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Trait Reference</em>'.
   * @generated
   */
  TJTraitReference createTJTraitReference();

  /**
   * Returns a new object of class '<em>TJ Trait Operation</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Trait Operation</em>'.
   * @generated
   */
  TJTraitOperation createTJTraitOperation();

  /**
   * Returns a new object of class '<em>Tj Trait Operation For Provided</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>Tj Trait Operation For Provided</em>'.
   * @generated
   */
  TjTraitOperationForProvided createTjTraitOperationForProvided();

  /**
   * Returns a new object of class '<em>TJ Hide Operation</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Hide Operation</em>'.
   * @generated
   */
  TJHideOperation createTJHideOperation();

  /**
   * Returns a new object of class '<em>TJ Restrict Operation</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Restrict Operation</em>'.
   * @generated
   */
  TJRestrictOperation createTJRestrictOperation();

  /**
   * Returns a new object of class '<em>TJ Alias Operation</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Alias Operation</em>'.
   * @generated
   */
  TJAliasOperation createTJAliasOperation();

  /**
   * Returns a new object of class '<em>TJ Rename Operation</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Rename Operation</em>'.
   * @generated
   */
  TJRenameOperation createTJRenameOperation();

  /**
   * Returns a new object of class '<em>TJ Redirect Operation</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Redirect Operation</em>'.
   * @generated
   */
  TJRedirectOperation createTJRedirectOperation();

  /**
   * Returns a new object of class '<em>TJ Member</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Member</em>'.
   * @generated
   */
  TJMember createTJMember();

  /**
   * Returns a new object of class '<em>TJ Field</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Field</em>'.
   * @generated
   */
  TJField createTJField();

  /**
   * Returns a new object of class '<em>TJ Method Declaration</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Method Declaration</em>'.
   * @generated
   */
  TJMethodDeclaration createTJMethodDeclaration();

  /**
   * Returns a new object of class '<em>TJ Required Method</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Required Method</em>'.
   * @generated
   */
  TJRequiredMethod createTJRequiredMethod();

  /**
   * Returns a new object of class '<em>TJ Method</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Method</em>'.
   * @generated
   */
  TJMethod createTJMethod();

  /**
   * Returns a new object of class '<em>TJ Constructor</em>'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return a new object of class '<em>TJ Constructor</em>'.
   * @generated
   */
  TJConstructor createTJConstructor();

  /**
   * Returns the package supported by this factory.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the package supported by this factory.
   * @generated
   */
  XtraitjPackage getXtraitjPackage();

} //XtraitjFactory

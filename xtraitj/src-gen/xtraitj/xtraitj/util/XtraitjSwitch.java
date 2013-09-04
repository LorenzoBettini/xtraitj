/**
 */
package xtraitj.xtraitj.util;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;

import org.eclipse.emf.ecore.util.Switch;

import xtraitj.xtraitj.*;

/**
 * <!-- begin-user-doc -->
 * The <b>Switch</b> for the model's inheritance hierarchy.
 * It supports the call {@link #doSwitch(EObject) doSwitch(object)}
 * to invoke the <code>caseXXX</code> method for each class of the model,
 * starting with the actual class of the object
 * and proceeding up the inheritance hierarchy
 * until a non-null result is returned,
 * which is the result of the switch.
 * <!-- end-user-doc -->
 * @see xtraitj.xtraitj.XtraitjPackage
 * @generated
 */
public class XtraitjSwitch<T> extends Switch<T>
{
  /**
   * The cached model package
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected static XtraitjPackage modelPackage;

  /**
   * Creates an instance of the switch.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public XtraitjSwitch()
  {
    if (modelPackage == null)
    {
      modelPackage = XtraitjPackage.eINSTANCE;
    }
  }

  /**
   * Checks whether this is a switch for the given package.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @parameter ePackage the package in question.
   * @return whether this is a switch for the given package.
   * @generated
   */
  @Override
  protected boolean isSwitchFor(EPackage ePackage)
  {
    return ePackage == modelPackage;
  }

  /**
   * Calls <code>caseXXX</code> for each class of the model until one returns a non null result; it yields that result.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the first non-null result returned by a <code>caseXXX</code> call.
   * @generated
   */
  @Override
  protected T doSwitch(int classifierID, EObject theEObject)
  {
    switch (classifierID)
    {
      case XtraitjPackage.TJ_PROGRAM:
      {
        TJProgram tjProgram = (TJProgram)theEObject;
        T result = caseTJProgram(tjProgram);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_DECLARATION:
      {
        TJDeclaration tjDeclaration = (TJDeclaration)theEObject;
        T result = caseTJDeclaration(tjDeclaration);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_TRAIT:
      {
        TJTrait tjTrait = (TJTrait)theEObject;
        T result = caseTJTrait(tjTrait);
        if (result == null) result = caseTJDeclaration(tjTrait);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_CLASS:
      {
        TJClass tjClass = (TJClass)theEObject;
        T result = caseTJClass(tjClass);
        if (result == null) result = caseTJDeclaration(tjClass);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_TRAIT_EXPRESSION:
      {
        TJTraitExpression tjTraitExpression = (TJTraitExpression)theEObject;
        T result = caseTJTraitExpression(tjTraitExpression);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_TRAIT_REFERENCE:
      {
        TJTraitReference tjTraitReference = (TJTraitReference)theEObject;
        T result = caseTJTraitReference(tjTraitReference);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_TRAIT_OPERATION:
      {
        TJTraitOperation tjTraitOperation = (TJTraitOperation)theEObject;
        T result = caseTJTraitOperation(tjTraitOperation);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_TRAIT_OPERATION_FOR_PROVIDED:
      {
        TjTraitOperationForProvided tjTraitOperationForProvided = (TjTraitOperationForProvided)theEObject;
        T result = caseTjTraitOperationForProvided(tjTraitOperationForProvided);
        if (result == null) result = caseTJTraitOperation(tjTraitOperationForProvided);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_HIDE_OPERATION:
      {
        TJHideOperation tjHideOperation = (TJHideOperation)theEObject;
        T result = caseTJHideOperation(tjHideOperation);
        if (result == null) result = caseTjTraitOperationForProvided(tjHideOperation);
        if (result == null) result = caseTJTraitOperation(tjHideOperation);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_RESTRICT_OPERATION:
      {
        TJRestrictOperation tjRestrictOperation = (TJRestrictOperation)theEObject;
        T result = caseTJRestrictOperation(tjRestrictOperation);
        if (result == null) result = caseTjTraitOperationForProvided(tjRestrictOperation);
        if (result == null) result = caseTJTraitOperation(tjRestrictOperation);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_ALIAS_OPERATION:
      {
        TJAliasOperation tjAliasOperation = (TJAliasOperation)theEObject;
        T result = caseTJAliasOperation(tjAliasOperation);
        if (result == null) result = caseTjTraitOperationForProvided(tjAliasOperation);
        if (result == null) result = caseTJTraitOperation(tjAliasOperation);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_RENAME_OPERATION:
      {
        TJRenameOperation tjRenameOperation = (TJRenameOperation)theEObject;
        T result = caseTJRenameOperation(tjRenameOperation);
        if (result == null) result = caseTJTraitOperation(tjRenameOperation);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_REDIRECT_OPERATION:
      {
        TJRedirectOperation tjRedirectOperation = (TJRedirectOperation)theEObject;
        T result = caseTJRedirectOperation(tjRedirectOperation);
        if (result == null) result = caseTJTraitOperation(tjRedirectOperation);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_MEMBER:
      {
        TJMember tjMember = (TJMember)theEObject;
        T result = caseTJMember(tjMember);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_FIELD:
      {
        TJField tjField = (TJField)theEObject;
        T result = caseTJField(tjField);
        if (result == null) result = caseTJMember(tjField);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_METHOD_DECLARATION:
      {
        TJMethodDeclaration tjMethodDeclaration = (TJMethodDeclaration)theEObject;
        T result = caseTJMethodDeclaration(tjMethodDeclaration);
        if (result == null) result = caseTJMember(tjMethodDeclaration);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_REQUIRED_METHOD:
      {
        TJRequiredMethod tjRequiredMethod = (TJRequiredMethod)theEObject;
        T result = caseTJRequiredMethod(tjRequiredMethod);
        if (result == null) result = caseTJMethodDeclaration(tjRequiredMethod);
        if (result == null) result = caseTJMember(tjRequiredMethod);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_METHOD:
      {
        TJMethod tjMethod = (TJMethod)theEObject;
        T result = caseTJMethod(tjMethod);
        if (result == null) result = caseTJMethodDeclaration(tjMethod);
        if (result == null) result = caseTJMember(tjMethod);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      case XtraitjPackage.TJ_CONSTRUCTOR:
      {
        TJConstructor tjConstructor = (TJConstructor)theEObject;
        T result = caseTJConstructor(tjConstructor);
        if (result == null) result = defaultCase(theEObject);
        return result;
      }
      default: return defaultCase(theEObject);
    }
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Program</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Program</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJProgram(TJProgram object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Declaration</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Declaration</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJDeclaration(TJDeclaration object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Trait</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Trait</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJTrait(TJTrait object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Class</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Class</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJClass(TJClass object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Trait Expression</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Trait Expression</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJTraitExpression(TJTraitExpression object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Trait Reference</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Trait Reference</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJTraitReference(TJTraitReference object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Trait Operation</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Trait Operation</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJTraitOperation(TJTraitOperation object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>Tj Trait Operation For Provided</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>Tj Trait Operation For Provided</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTjTraitOperationForProvided(TjTraitOperationForProvided object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Hide Operation</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Hide Operation</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJHideOperation(TJHideOperation object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Restrict Operation</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Restrict Operation</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJRestrictOperation(TJRestrictOperation object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Alias Operation</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Alias Operation</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJAliasOperation(TJAliasOperation object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Rename Operation</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Rename Operation</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJRenameOperation(TJRenameOperation object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Redirect Operation</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Redirect Operation</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJRedirectOperation(TJRedirectOperation object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Member</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Member</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJMember(TJMember object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Field</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Field</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJField(TJField object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Method Declaration</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Method Declaration</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJMethodDeclaration(TJMethodDeclaration object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Required Method</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Required Method</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJRequiredMethod(TJRequiredMethod object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Method</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Method</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJMethod(TJMethod object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>TJ Constructor</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>TJ Constructor</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject) doSwitch(EObject)
   * @generated
   */
  public T caseTJConstructor(TJConstructor object)
  {
    return null;
  }

  /**
   * Returns the result of interpreting the object as an instance of '<em>EObject</em>'.
   * <!-- begin-user-doc -->
   * This implementation returns null;
   * returning a non-null result will terminate the switch, but this is the last case anyway.
   * <!-- end-user-doc -->
   * @param object the target of the switch.
   * @return the result of interpreting the object as an instance of '<em>EObject</em>'.
   * @see #doSwitch(org.eclipse.emf.ecore.EObject)
   * @generated
   */
  @Override
  public T defaultCase(EObject object)
  {
    return null;
  }

} //XtraitjSwitch

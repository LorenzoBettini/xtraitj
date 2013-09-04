/**
 */
package xtraitj.xtraitj.impl;

import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EPackage;

import org.eclipse.emf.ecore.impl.EFactoryImpl;

import org.eclipse.emf.ecore.plugin.EcorePlugin;

import xtraitj.xtraitj.*;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model <b>Factory</b>.
 * <!-- end-user-doc -->
 * @generated
 */
public class XtraitjFactoryImpl extends EFactoryImpl implements XtraitjFactory
{
  /**
   * Creates the default factory implementation.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public static XtraitjFactory init()
  {
    try
    {
      XtraitjFactory theXtraitjFactory = (XtraitjFactory)EPackage.Registry.INSTANCE.getEFactory(XtraitjPackage.eNS_URI);
      if (theXtraitjFactory != null)
      {
        return theXtraitjFactory;
      }
    }
    catch (Exception exception)
    {
      EcorePlugin.INSTANCE.log(exception);
    }
    return new XtraitjFactoryImpl();
  }

  /**
   * Creates an instance of the factory.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public XtraitjFactoryImpl()
  {
    super();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  @Override
  public EObject create(EClass eClass)
  {
    switch (eClass.getClassifierID())
    {
      case XtraitjPackage.TJ_PROGRAM: return createTJProgram();
      case XtraitjPackage.TJ_DECLARATION: return createTJDeclaration();
      case XtraitjPackage.TJ_TRAIT: return createTJTrait();
      case XtraitjPackage.TJ_CLASS: return createTJClass();
      case XtraitjPackage.TJ_TRAIT_EXPRESSION: return createTJTraitExpression();
      case XtraitjPackage.TJ_TRAIT_REFERENCE: return createTJTraitReference();
      case XtraitjPackage.TJ_TRAIT_OPERATION: return createTJTraitOperation();
      case XtraitjPackage.TJ_TRAIT_OPERATION_FOR_PROVIDED: return createTjTraitOperationForProvided();
      case XtraitjPackage.TJ_HIDE_OPERATION: return createTJHideOperation();
      case XtraitjPackage.TJ_RESTRICT_OPERATION: return createTJRestrictOperation();
      case XtraitjPackage.TJ_ALIAS_OPERATION: return createTJAliasOperation();
      case XtraitjPackage.TJ_RENAME_OPERATION: return createTJRenameOperation();
      case XtraitjPackage.TJ_REDIRECT_OPERATION: return createTJRedirectOperation();
      case XtraitjPackage.TJ_MEMBER: return createTJMember();
      case XtraitjPackage.TJ_FIELD: return createTJField();
      case XtraitjPackage.TJ_METHOD_DECLARATION: return createTJMethodDeclaration();
      case XtraitjPackage.TJ_REQUIRED_METHOD: return createTJRequiredMethod();
      case XtraitjPackage.TJ_METHOD: return createTJMethod();
      case XtraitjPackage.TJ_CONSTRUCTOR: return createTJConstructor();
      default:
        throw new IllegalArgumentException("The class '" + eClass.getName() + "' is not a valid classifier");
    }
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJProgram createTJProgram()
  {
    TJProgramImpl tjProgram = new TJProgramImpl();
    return tjProgram;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJDeclaration createTJDeclaration()
  {
    TJDeclarationImpl tjDeclaration = new TJDeclarationImpl();
    return tjDeclaration;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJTrait createTJTrait()
  {
    TJTraitImpl tjTrait = new TJTraitImpl();
    return tjTrait;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJClass createTJClass()
  {
    TJClassImpl tjClass = new TJClassImpl();
    return tjClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJTraitExpression createTJTraitExpression()
  {
    TJTraitExpressionImpl tjTraitExpression = new TJTraitExpressionImpl();
    return tjTraitExpression;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJTraitReference createTJTraitReference()
  {
    TJTraitReferenceImpl tjTraitReference = new TJTraitReferenceImpl();
    return tjTraitReference;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJTraitOperation createTJTraitOperation()
  {
    TJTraitOperationImpl tjTraitOperation = new TJTraitOperationImpl();
    return tjTraitOperation;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TjTraitOperationForProvided createTjTraitOperationForProvided()
  {
    TjTraitOperationForProvidedImpl tjTraitOperationForProvided = new TjTraitOperationForProvidedImpl();
    return tjTraitOperationForProvided;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJHideOperation createTJHideOperation()
  {
    TJHideOperationImpl tjHideOperation = new TJHideOperationImpl();
    return tjHideOperation;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJRestrictOperation createTJRestrictOperation()
  {
    TJRestrictOperationImpl tjRestrictOperation = new TJRestrictOperationImpl();
    return tjRestrictOperation;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJAliasOperation createTJAliasOperation()
  {
    TJAliasOperationImpl tjAliasOperation = new TJAliasOperationImpl();
    return tjAliasOperation;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJRenameOperation createTJRenameOperation()
  {
    TJRenameOperationImpl tjRenameOperation = new TJRenameOperationImpl();
    return tjRenameOperation;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJRedirectOperation createTJRedirectOperation()
  {
    TJRedirectOperationImpl tjRedirectOperation = new TJRedirectOperationImpl();
    return tjRedirectOperation;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJMember createTJMember()
  {
    TJMemberImpl tjMember = new TJMemberImpl();
    return tjMember;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJField createTJField()
  {
    TJFieldImpl tjField = new TJFieldImpl();
    return tjField;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJMethodDeclaration createTJMethodDeclaration()
  {
    TJMethodDeclarationImpl tjMethodDeclaration = new TJMethodDeclarationImpl();
    return tjMethodDeclaration;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJRequiredMethod createTJRequiredMethod()
  {
    TJRequiredMethodImpl tjRequiredMethod = new TJRequiredMethodImpl();
    return tjRequiredMethod;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJMethod createTJMethod()
  {
    TJMethodImpl tjMethod = new TJMethodImpl();
    return tjMethod;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public TJConstructor createTJConstructor()
  {
    TJConstructorImpl tjConstructor = new TJConstructorImpl();
    return tjConstructor;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public XtraitjPackage getXtraitjPackage()
  {
    return (XtraitjPackage)getEPackage();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @deprecated
   * @generated
   */
  @Deprecated
  public static XtraitjPackage getPackage()
  {
    return XtraitjPackage.eINSTANCE;
  }

} //XtraitjFactoryImpl

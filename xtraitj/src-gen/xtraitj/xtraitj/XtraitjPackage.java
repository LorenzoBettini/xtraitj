/**
 */
package xtraitj.xtraitj;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;

/**
 * <!-- begin-user-doc -->
 * The <b>Package</b> for the model.
 * It contains accessors for the meta objects to represent
 * <ul>
 *   <li>each class,</li>
 *   <li>each feature of each class,</li>
 *   <li>each enum,</li>
 *   <li>and each data type</li>
 * </ul>
 * <!-- end-user-doc -->
 * @see xtraitj.xtraitj.XtraitjFactory
 * @model kind="package"
 * @generated
 */
public interface XtraitjPackage extends EPackage
{
  /**
   * The package name.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  String eNAME = "xtraitj";

  /**
   * The package namespace URI.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  String eNS_URI = "http://www.Xtraitj.xtraitj";

  /**
   * The package namespace name.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  String eNS_PREFIX = "xtraitj";

  /**
   * The singleton instance of the package.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  XtraitjPackage eINSTANCE = xtraitj.xtraitj.impl.XtraitjPackageImpl.init();

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJProgramImpl <em>TJ Program</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJProgramImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJProgram()
   * @generated
   */
  int TJ_PROGRAM = 0;

  /**
   * The feature id for the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_PROGRAM__NAME = 0;

  /**
   * The feature id for the '<em><b>Import Section</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_PROGRAM__IMPORT_SECTION = 1;

  /**
   * The feature id for the '<em><b>Elements</b></em>' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_PROGRAM__ELEMENTS = 2;

  /**
   * The number of structural features of the '<em>TJ Program</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_PROGRAM_FEATURE_COUNT = 3;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJDeclarationImpl <em>TJ Declaration</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJDeclarationImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJDeclaration()
   * @generated
   */
  int TJ_DECLARATION = 1;

  /**
   * The feature id for the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_DECLARATION__NAME = 0;

  /**
   * The feature id for the '<em><b>Trait Expression</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_DECLARATION__TRAIT_EXPRESSION = 1;

  /**
   * The number of structural features of the '<em>TJ Declaration</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_DECLARATION_FEATURE_COUNT = 2;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJTraitImpl <em>TJ Trait</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJTraitImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJTrait()
   * @generated
   */
  int TJ_TRAIT = 2;

  /**
   * The feature id for the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT__NAME = TJ_DECLARATION__NAME;

  /**
   * The feature id for the '<em><b>Trait Expression</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT__TRAIT_EXPRESSION = TJ_DECLARATION__TRAIT_EXPRESSION;

  /**
   * The feature id for the '<em><b>Members</b></em>' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT__MEMBERS = TJ_DECLARATION_FEATURE_COUNT + 0;

  /**
   * The number of structural features of the '<em>TJ Trait</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_FEATURE_COUNT = TJ_DECLARATION_FEATURE_COUNT + 1;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJClassImpl <em>TJ Class</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJClassImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJClass()
   * @generated
   */
  int TJ_CLASS = 3;

  /**
   * The feature id for the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_CLASS__NAME = TJ_DECLARATION__NAME;

  /**
   * The feature id for the '<em><b>Trait Expression</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_CLASS__TRAIT_EXPRESSION = TJ_DECLARATION__TRAIT_EXPRESSION;

  /**
   * The feature id for the '<em><b>Interfaces</b></em>' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_CLASS__INTERFACES = TJ_DECLARATION_FEATURE_COUNT + 0;

  /**
   * The feature id for the '<em><b>Fields</b></em>' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_CLASS__FIELDS = TJ_DECLARATION_FEATURE_COUNT + 1;

  /**
   * The number of structural features of the '<em>TJ Class</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_CLASS_FEATURE_COUNT = TJ_DECLARATION_FEATURE_COUNT + 2;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJTraitExpressionImpl <em>TJ Trait Expression</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJTraitExpressionImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJTraitExpression()
   * @generated
   */
  int TJ_TRAIT_EXPRESSION = 4;

  /**
   * The feature id for the '<em><b>References</b></em>' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_EXPRESSION__REFERENCES = 0;

  /**
   * The number of structural features of the '<em>TJ Trait Expression</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_EXPRESSION_FEATURE_COUNT = 1;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJTraitReferenceImpl <em>TJ Trait Reference</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJTraitReferenceImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJTraitReference()
   * @generated
   */
  int TJ_TRAIT_REFERENCE = 5;

  /**
   * The feature id for the '<em><b>Trait</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_REFERENCE__TRAIT = 0;

  /**
   * The feature id for the '<em><b>Operations</b></em>' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_REFERENCE__OPERATIONS = 1;

  /**
   * The number of structural features of the '<em>TJ Trait Reference</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_REFERENCE_FEATURE_COUNT = 2;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJTraitOperationImpl <em>TJ Trait Operation</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJTraitOperationImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJTraitOperation()
   * @generated
   */
  int TJ_TRAIT_OPERATION = 6;

  /**
   * The feature id for the '<em><b>Member</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_OPERATION__MEMBER = 0;

  /**
   * The number of structural features of the '<em>TJ Trait Operation</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_OPERATION_FEATURE_COUNT = 1;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TjTraitOperationForProvidedImpl <em>Tj Trait Operation For Provided</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TjTraitOperationForProvidedImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTjTraitOperationForProvided()
   * @generated
   */
  int TJ_TRAIT_OPERATION_FOR_PROVIDED = 7;

  /**
   * The feature id for the '<em><b>Member</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_OPERATION_FOR_PROVIDED__MEMBER = TJ_TRAIT_OPERATION__MEMBER;

  /**
   * The number of structural features of the '<em>Tj Trait Operation For Provided</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_TRAIT_OPERATION_FOR_PROVIDED_FEATURE_COUNT = TJ_TRAIT_OPERATION_FEATURE_COUNT + 0;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJHideOperationImpl <em>TJ Hide Operation</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJHideOperationImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJHideOperation()
   * @generated
   */
  int TJ_HIDE_OPERATION = 8;

  /**
   * The feature id for the '<em><b>Member</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_HIDE_OPERATION__MEMBER = TJ_TRAIT_OPERATION_FOR_PROVIDED__MEMBER;

  /**
   * The number of structural features of the '<em>TJ Hide Operation</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_HIDE_OPERATION_FEATURE_COUNT = TJ_TRAIT_OPERATION_FOR_PROVIDED_FEATURE_COUNT + 0;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJRestrictOperationImpl <em>TJ Restrict Operation</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJRestrictOperationImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJRestrictOperation()
   * @generated
   */
  int TJ_RESTRICT_OPERATION = 9;

  /**
   * The feature id for the '<em><b>Member</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_RESTRICT_OPERATION__MEMBER = TJ_TRAIT_OPERATION_FOR_PROVIDED__MEMBER;

  /**
   * The number of structural features of the '<em>TJ Restrict Operation</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_RESTRICT_OPERATION_FEATURE_COUNT = TJ_TRAIT_OPERATION_FOR_PROVIDED_FEATURE_COUNT + 0;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJAliasOperationImpl <em>TJ Alias Operation</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJAliasOperationImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJAliasOperation()
   * @generated
   */
  int TJ_ALIAS_OPERATION = 10;

  /**
   * The feature id for the '<em><b>Member</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_ALIAS_OPERATION__MEMBER = TJ_TRAIT_OPERATION_FOR_PROVIDED__MEMBER;

  /**
   * The feature id for the '<em><b>Newname</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_ALIAS_OPERATION__NEWNAME = TJ_TRAIT_OPERATION_FOR_PROVIDED_FEATURE_COUNT + 0;

  /**
   * The number of structural features of the '<em>TJ Alias Operation</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_ALIAS_OPERATION_FEATURE_COUNT = TJ_TRAIT_OPERATION_FOR_PROVIDED_FEATURE_COUNT + 1;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJRenameOperationImpl <em>TJ Rename Operation</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJRenameOperationImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJRenameOperation()
   * @generated
   */
  int TJ_RENAME_OPERATION = 11;

  /**
   * The feature id for the '<em><b>Member</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_RENAME_OPERATION__MEMBER = TJ_TRAIT_OPERATION__MEMBER;

  /**
   * The feature id for the '<em><b>Newname</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_RENAME_OPERATION__NEWNAME = TJ_TRAIT_OPERATION_FEATURE_COUNT + 0;

  /**
   * The number of structural features of the '<em>TJ Rename Operation</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_RENAME_OPERATION_FEATURE_COUNT = TJ_TRAIT_OPERATION_FEATURE_COUNT + 1;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJRedirectOperationImpl <em>TJ Redirect Operation</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJRedirectOperationImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJRedirectOperation()
   * @generated
   */
  int TJ_REDIRECT_OPERATION = 12;

  /**
   * The feature id for the '<em><b>Member</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_REDIRECT_OPERATION__MEMBER = TJ_TRAIT_OPERATION__MEMBER;

  /**
   * The feature id for the '<em><b>Member2</b></em>' reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_REDIRECT_OPERATION__MEMBER2 = TJ_TRAIT_OPERATION_FEATURE_COUNT + 0;

  /**
   * The number of structural features of the '<em>TJ Redirect Operation</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_REDIRECT_OPERATION_FEATURE_COUNT = TJ_TRAIT_OPERATION_FEATURE_COUNT + 1;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJMemberImpl <em>TJ Member</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJMemberImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJMember()
   * @generated
   */
  int TJ_MEMBER = 13;

  /**
   * The feature id for the '<em><b>Type</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_MEMBER__TYPE = 0;

  /**
   * The feature id for the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_MEMBER__NAME = 1;

  /**
   * The number of structural features of the '<em>TJ Member</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_MEMBER_FEATURE_COUNT = 2;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJFieldImpl <em>TJ Field</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJFieldImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJField()
   * @generated
   */
  int TJ_FIELD = 14;

  /**
   * The feature id for the '<em><b>Type</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_FIELD__TYPE = TJ_MEMBER__TYPE;

  /**
   * The feature id for the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_FIELD__NAME = TJ_MEMBER__NAME;

  /**
   * The feature id for the '<em><b>Init</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_FIELD__INIT = TJ_MEMBER_FEATURE_COUNT + 0;

  /**
   * The number of structural features of the '<em>TJ Field</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_FIELD_FEATURE_COUNT = TJ_MEMBER_FEATURE_COUNT + 1;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJMethodDeclarationImpl <em>TJ Method Declaration</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJMethodDeclarationImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJMethodDeclaration()
   * @generated
   */
  int TJ_METHOD_DECLARATION = 15;

  /**
   * The feature id for the '<em><b>Type</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD_DECLARATION__TYPE = TJ_MEMBER__TYPE;

  /**
   * The feature id for the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD_DECLARATION__NAME = TJ_MEMBER__NAME;

  /**
   * The feature id for the '<em><b>Params</b></em>' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD_DECLARATION__PARAMS = TJ_MEMBER_FEATURE_COUNT + 0;

  /**
   * The number of structural features of the '<em>TJ Method Declaration</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD_DECLARATION_FEATURE_COUNT = TJ_MEMBER_FEATURE_COUNT + 1;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJRequiredMethodImpl <em>TJ Required Method</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJRequiredMethodImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJRequiredMethod()
   * @generated
   */
  int TJ_REQUIRED_METHOD = 16;

  /**
   * The feature id for the '<em><b>Type</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_REQUIRED_METHOD__TYPE = TJ_METHOD_DECLARATION__TYPE;

  /**
   * The feature id for the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_REQUIRED_METHOD__NAME = TJ_METHOD_DECLARATION__NAME;

  /**
   * The feature id for the '<em><b>Params</b></em>' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_REQUIRED_METHOD__PARAMS = TJ_METHOD_DECLARATION__PARAMS;

  /**
   * The number of structural features of the '<em>TJ Required Method</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_REQUIRED_METHOD_FEATURE_COUNT = TJ_METHOD_DECLARATION_FEATURE_COUNT + 0;

  /**
   * The meta object id for the '{@link xtraitj.xtraitj.impl.TJMethodImpl <em>TJ Method</em>}' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see xtraitj.xtraitj.impl.TJMethodImpl
   * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJMethod()
   * @generated
   */
  int TJ_METHOD = 17;

  /**
   * The feature id for the '<em><b>Type</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD__TYPE = TJ_METHOD_DECLARATION__TYPE;

  /**
   * The feature id for the '<em><b>Name</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD__NAME = TJ_METHOD_DECLARATION__NAME;

  /**
   * The feature id for the '<em><b>Params</b></em>' containment reference list.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD__PARAMS = TJ_METHOD_DECLARATION__PARAMS;

  /**
   * The feature id for the '<em><b>Private</b></em>' attribute.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD__PRIVATE = TJ_METHOD_DECLARATION_FEATURE_COUNT + 0;

  /**
   * The feature id for the '<em><b>Body</b></em>' containment reference.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD__BODY = TJ_METHOD_DECLARATION_FEATURE_COUNT + 1;

  /**
   * The number of structural features of the '<em>TJ Method</em>' class.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   * @ordered
   */
  int TJ_METHOD_FEATURE_COUNT = TJ_METHOD_DECLARATION_FEATURE_COUNT + 2;


  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJProgram <em>TJ Program</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Program</em>'.
   * @see xtraitj.xtraitj.TJProgram
   * @generated
   */
  EClass getTJProgram();

  /**
   * Returns the meta object for the attribute '{@link xtraitj.xtraitj.TJProgram#getName <em>Name</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the attribute '<em>Name</em>'.
   * @see xtraitj.xtraitj.TJProgram#getName()
   * @see #getTJProgram()
   * @generated
   */
  EAttribute getTJProgram_Name();

  /**
   * Returns the meta object for the containment reference '{@link xtraitj.xtraitj.TJProgram#getImportSection <em>Import Section</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference '<em>Import Section</em>'.
   * @see xtraitj.xtraitj.TJProgram#getImportSection()
   * @see #getTJProgram()
   * @generated
   */
  EReference getTJProgram_ImportSection();

  /**
   * Returns the meta object for the containment reference list '{@link xtraitj.xtraitj.TJProgram#getElements <em>Elements</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference list '<em>Elements</em>'.
   * @see xtraitj.xtraitj.TJProgram#getElements()
   * @see #getTJProgram()
   * @generated
   */
  EReference getTJProgram_Elements();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJDeclaration <em>TJ Declaration</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Declaration</em>'.
   * @see xtraitj.xtraitj.TJDeclaration
   * @generated
   */
  EClass getTJDeclaration();

  /**
   * Returns the meta object for the attribute '{@link xtraitj.xtraitj.TJDeclaration#getName <em>Name</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the attribute '<em>Name</em>'.
   * @see xtraitj.xtraitj.TJDeclaration#getName()
   * @see #getTJDeclaration()
   * @generated
   */
  EAttribute getTJDeclaration_Name();

  /**
   * Returns the meta object for the containment reference '{@link xtraitj.xtraitj.TJDeclaration#getTraitExpression <em>Trait Expression</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference '<em>Trait Expression</em>'.
   * @see xtraitj.xtraitj.TJDeclaration#getTraitExpression()
   * @see #getTJDeclaration()
   * @generated
   */
  EReference getTJDeclaration_TraitExpression();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJTrait <em>TJ Trait</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Trait</em>'.
   * @see xtraitj.xtraitj.TJTrait
   * @generated
   */
  EClass getTJTrait();

  /**
   * Returns the meta object for the containment reference list '{@link xtraitj.xtraitj.TJTrait#getMembers <em>Members</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference list '<em>Members</em>'.
   * @see xtraitj.xtraitj.TJTrait#getMembers()
   * @see #getTJTrait()
   * @generated
   */
  EReference getTJTrait_Members();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJClass <em>TJ Class</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Class</em>'.
   * @see xtraitj.xtraitj.TJClass
   * @generated
   */
  EClass getTJClass();

  /**
   * Returns the meta object for the containment reference list '{@link xtraitj.xtraitj.TJClass#getInterfaces <em>Interfaces</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference list '<em>Interfaces</em>'.
   * @see xtraitj.xtraitj.TJClass#getInterfaces()
   * @see #getTJClass()
   * @generated
   */
  EReference getTJClass_Interfaces();

  /**
   * Returns the meta object for the containment reference list '{@link xtraitj.xtraitj.TJClass#getFields <em>Fields</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference list '<em>Fields</em>'.
   * @see xtraitj.xtraitj.TJClass#getFields()
   * @see #getTJClass()
   * @generated
   */
  EReference getTJClass_Fields();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJTraitExpression <em>TJ Trait Expression</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Trait Expression</em>'.
   * @see xtraitj.xtraitj.TJTraitExpression
   * @generated
   */
  EClass getTJTraitExpression();

  /**
   * Returns the meta object for the containment reference list '{@link xtraitj.xtraitj.TJTraitExpression#getReferences <em>References</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference list '<em>References</em>'.
   * @see xtraitj.xtraitj.TJTraitExpression#getReferences()
   * @see #getTJTraitExpression()
   * @generated
   */
  EReference getTJTraitExpression_References();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJTraitReference <em>TJ Trait Reference</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Trait Reference</em>'.
   * @see xtraitj.xtraitj.TJTraitReference
   * @generated
   */
  EClass getTJTraitReference();

  /**
   * Returns the meta object for the reference '{@link xtraitj.xtraitj.TJTraitReference#getTrait <em>Trait</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the reference '<em>Trait</em>'.
   * @see xtraitj.xtraitj.TJTraitReference#getTrait()
   * @see #getTJTraitReference()
   * @generated
   */
  EReference getTJTraitReference_Trait();

  /**
   * Returns the meta object for the containment reference list '{@link xtraitj.xtraitj.TJTraitReference#getOperations <em>Operations</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference list '<em>Operations</em>'.
   * @see xtraitj.xtraitj.TJTraitReference#getOperations()
   * @see #getTJTraitReference()
   * @generated
   */
  EReference getTJTraitReference_Operations();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJTraitOperation <em>TJ Trait Operation</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Trait Operation</em>'.
   * @see xtraitj.xtraitj.TJTraitOperation
   * @generated
   */
  EClass getTJTraitOperation();

  /**
   * Returns the meta object for the reference '{@link xtraitj.xtraitj.TJTraitOperation#getMember <em>Member</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the reference '<em>Member</em>'.
   * @see xtraitj.xtraitj.TJTraitOperation#getMember()
   * @see #getTJTraitOperation()
   * @generated
   */
  EReference getTJTraitOperation_Member();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TjTraitOperationForProvided <em>Tj Trait Operation For Provided</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>Tj Trait Operation For Provided</em>'.
   * @see xtraitj.xtraitj.TjTraitOperationForProvided
   * @generated
   */
  EClass getTjTraitOperationForProvided();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJHideOperation <em>TJ Hide Operation</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Hide Operation</em>'.
   * @see xtraitj.xtraitj.TJHideOperation
   * @generated
   */
  EClass getTJHideOperation();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJRestrictOperation <em>TJ Restrict Operation</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Restrict Operation</em>'.
   * @see xtraitj.xtraitj.TJRestrictOperation
   * @generated
   */
  EClass getTJRestrictOperation();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJAliasOperation <em>TJ Alias Operation</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Alias Operation</em>'.
   * @see xtraitj.xtraitj.TJAliasOperation
   * @generated
   */
  EClass getTJAliasOperation();

  /**
   * Returns the meta object for the attribute '{@link xtraitj.xtraitj.TJAliasOperation#getNewname <em>Newname</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the attribute '<em>Newname</em>'.
   * @see xtraitj.xtraitj.TJAliasOperation#getNewname()
   * @see #getTJAliasOperation()
   * @generated
   */
  EAttribute getTJAliasOperation_Newname();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJRenameOperation <em>TJ Rename Operation</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Rename Operation</em>'.
   * @see xtraitj.xtraitj.TJRenameOperation
   * @generated
   */
  EClass getTJRenameOperation();

  /**
   * Returns the meta object for the attribute '{@link xtraitj.xtraitj.TJRenameOperation#getNewname <em>Newname</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the attribute '<em>Newname</em>'.
   * @see xtraitj.xtraitj.TJRenameOperation#getNewname()
   * @see #getTJRenameOperation()
   * @generated
   */
  EAttribute getTJRenameOperation_Newname();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJRedirectOperation <em>TJ Redirect Operation</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Redirect Operation</em>'.
   * @see xtraitj.xtraitj.TJRedirectOperation
   * @generated
   */
  EClass getTJRedirectOperation();

  /**
   * Returns the meta object for the reference '{@link xtraitj.xtraitj.TJRedirectOperation#getMember2 <em>Member2</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the reference '<em>Member2</em>'.
   * @see xtraitj.xtraitj.TJRedirectOperation#getMember2()
   * @see #getTJRedirectOperation()
   * @generated
   */
  EReference getTJRedirectOperation_Member2();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJMember <em>TJ Member</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Member</em>'.
   * @see xtraitj.xtraitj.TJMember
   * @generated
   */
  EClass getTJMember();

  /**
   * Returns the meta object for the containment reference '{@link xtraitj.xtraitj.TJMember#getType <em>Type</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference '<em>Type</em>'.
   * @see xtraitj.xtraitj.TJMember#getType()
   * @see #getTJMember()
   * @generated
   */
  EReference getTJMember_Type();

  /**
   * Returns the meta object for the attribute '{@link xtraitj.xtraitj.TJMember#getName <em>Name</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the attribute '<em>Name</em>'.
   * @see xtraitj.xtraitj.TJMember#getName()
   * @see #getTJMember()
   * @generated
   */
  EAttribute getTJMember_Name();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJField <em>TJ Field</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Field</em>'.
   * @see xtraitj.xtraitj.TJField
   * @generated
   */
  EClass getTJField();

  /**
   * Returns the meta object for the containment reference '{@link xtraitj.xtraitj.TJField#getInit <em>Init</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference '<em>Init</em>'.
   * @see xtraitj.xtraitj.TJField#getInit()
   * @see #getTJField()
   * @generated
   */
  EReference getTJField_Init();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJMethodDeclaration <em>TJ Method Declaration</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Method Declaration</em>'.
   * @see xtraitj.xtraitj.TJMethodDeclaration
   * @generated
   */
  EClass getTJMethodDeclaration();

  /**
   * Returns the meta object for the containment reference list '{@link xtraitj.xtraitj.TJMethodDeclaration#getParams <em>Params</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference list '<em>Params</em>'.
   * @see xtraitj.xtraitj.TJMethodDeclaration#getParams()
   * @see #getTJMethodDeclaration()
   * @generated
   */
  EReference getTJMethodDeclaration_Params();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJRequiredMethod <em>TJ Required Method</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Required Method</em>'.
   * @see xtraitj.xtraitj.TJRequiredMethod
   * @generated
   */
  EClass getTJRequiredMethod();

  /**
   * Returns the meta object for class '{@link xtraitj.xtraitj.TJMethod <em>TJ Method</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for class '<em>TJ Method</em>'.
   * @see xtraitj.xtraitj.TJMethod
   * @generated
   */
  EClass getTJMethod();

  /**
   * Returns the meta object for the attribute '{@link xtraitj.xtraitj.TJMethod#isPrivate <em>Private</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the attribute '<em>Private</em>'.
   * @see xtraitj.xtraitj.TJMethod#isPrivate()
   * @see #getTJMethod()
   * @generated
   */
  EAttribute getTJMethod_Private();

  /**
   * Returns the meta object for the containment reference '{@link xtraitj.xtraitj.TJMethod#getBody <em>Body</em>}'.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the meta object for the containment reference '<em>Body</em>'.
   * @see xtraitj.xtraitj.TJMethod#getBody()
   * @see #getTJMethod()
   * @generated
   */
  EReference getTJMethod_Body();

  /**
   * Returns the factory that creates the instances of the model.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @return the factory that creates the instances of the model.
   * @generated
   */
  XtraitjFactory getXtraitjFactory();

  /**
   * <!-- begin-user-doc -->
   * Defines literals for the meta objects that represent
   * <ul>
   *   <li>each class,</li>
   *   <li>each feature of each class,</li>
   *   <li>each enum,</li>
   *   <li>and each data type</li>
   * </ul>
   * <!-- end-user-doc -->
   * @generated
   */
  interface Literals
  {
    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJProgramImpl <em>TJ Program</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJProgramImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJProgram()
     * @generated
     */
    EClass TJ_PROGRAM = eINSTANCE.getTJProgram();

    /**
     * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EAttribute TJ_PROGRAM__NAME = eINSTANCE.getTJProgram_Name();

    /**
     * The meta object literal for the '<em><b>Import Section</b></em>' containment reference feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_PROGRAM__IMPORT_SECTION = eINSTANCE.getTJProgram_ImportSection();

    /**
     * The meta object literal for the '<em><b>Elements</b></em>' containment reference list feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_PROGRAM__ELEMENTS = eINSTANCE.getTJProgram_Elements();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJDeclarationImpl <em>TJ Declaration</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJDeclarationImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJDeclaration()
     * @generated
     */
    EClass TJ_DECLARATION = eINSTANCE.getTJDeclaration();

    /**
     * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EAttribute TJ_DECLARATION__NAME = eINSTANCE.getTJDeclaration_Name();

    /**
     * The meta object literal for the '<em><b>Trait Expression</b></em>' containment reference feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_DECLARATION__TRAIT_EXPRESSION = eINSTANCE.getTJDeclaration_TraitExpression();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJTraitImpl <em>TJ Trait</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJTraitImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJTrait()
     * @generated
     */
    EClass TJ_TRAIT = eINSTANCE.getTJTrait();

    /**
     * The meta object literal for the '<em><b>Members</b></em>' containment reference list feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_TRAIT__MEMBERS = eINSTANCE.getTJTrait_Members();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJClassImpl <em>TJ Class</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJClassImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJClass()
     * @generated
     */
    EClass TJ_CLASS = eINSTANCE.getTJClass();

    /**
     * The meta object literal for the '<em><b>Interfaces</b></em>' containment reference list feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_CLASS__INTERFACES = eINSTANCE.getTJClass_Interfaces();

    /**
     * The meta object literal for the '<em><b>Fields</b></em>' containment reference list feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_CLASS__FIELDS = eINSTANCE.getTJClass_Fields();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJTraitExpressionImpl <em>TJ Trait Expression</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJTraitExpressionImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJTraitExpression()
     * @generated
     */
    EClass TJ_TRAIT_EXPRESSION = eINSTANCE.getTJTraitExpression();

    /**
     * The meta object literal for the '<em><b>References</b></em>' containment reference list feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_TRAIT_EXPRESSION__REFERENCES = eINSTANCE.getTJTraitExpression_References();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJTraitReferenceImpl <em>TJ Trait Reference</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJTraitReferenceImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJTraitReference()
     * @generated
     */
    EClass TJ_TRAIT_REFERENCE = eINSTANCE.getTJTraitReference();

    /**
     * The meta object literal for the '<em><b>Trait</b></em>' reference feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_TRAIT_REFERENCE__TRAIT = eINSTANCE.getTJTraitReference_Trait();

    /**
     * The meta object literal for the '<em><b>Operations</b></em>' containment reference list feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_TRAIT_REFERENCE__OPERATIONS = eINSTANCE.getTJTraitReference_Operations();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJTraitOperationImpl <em>TJ Trait Operation</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJTraitOperationImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJTraitOperation()
     * @generated
     */
    EClass TJ_TRAIT_OPERATION = eINSTANCE.getTJTraitOperation();

    /**
     * The meta object literal for the '<em><b>Member</b></em>' reference feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_TRAIT_OPERATION__MEMBER = eINSTANCE.getTJTraitOperation_Member();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TjTraitOperationForProvidedImpl <em>Tj Trait Operation For Provided</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TjTraitOperationForProvidedImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTjTraitOperationForProvided()
     * @generated
     */
    EClass TJ_TRAIT_OPERATION_FOR_PROVIDED = eINSTANCE.getTjTraitOperationForProvided();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJHideOperationImpl <em>TJ Hide Operation</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJHideOperationImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJHideOperation()
     * @generated
     */
    EClass TJ_HIDE_OPERATION = eINSTANCE.getTJHideOperation();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJRestrictOperationImpl <em>TJ Restrict Operation</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJRestrictOperationImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJRestrictOperation()
     * @generated
     */
    EClass TJ_RESTRICT_OPERATION = eINSTANCE.getTJRestrictOperation();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJAliasOperationImpl <em>TJ Alias Operation</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJAliasOperationImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJAliasOperation()
     * @generated
     */
    EClass TJ_ALIAS_OPERATION = eINSTANCE.getTJAliasOperation();

    /**
     * The meta object literal for the '<em><b>Newname</b></em>' attribute feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EAttribute TJ_ALIAS_OPERATION__NEWNAME = eINSTANCE.getTJAliasOperation_Newname();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJRenameOperationImpl <em>TJ Rename Operation</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJRenameOperationImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJRenameOperation()
     * @generated
     */
    EClass TJ_RENAME_OPERATION = eINSTANCE.getTJRenameOperation();

    /**
     * The meta object literal for the '<em><b>Newname</b></em>' attribute feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EAttribute TJ_RENAME_OPERATION__NEWNAME = eINSTANCE.getTJRenameOperation_Newname();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJRedirectOperationImpl <em>TJ Redirect Operation</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJRedirectOperationImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJRedirectOperation()
     * @generated
     */
    EClass TJ_REDIRECT_OPERATION = eINSTANCE.getTJRedirectOperation();

    /**
     * The meta object literal for the '<em><b>Member2</b></em>' reference feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_REDIRECT_OPERATION__MEMBER2 = eINSTANCE.getTJRedirectOperation_Member2();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJMemberImpl <em>TJ Member</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJMemberImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJMember()
     * @generated
     */
    EClass TJ_MEMBER = eINSTANCE.getTJMember();

    /**
     * The meta object literal for the '<em><b>Type</b></em>' containment reference feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_MEMBER__TYPE = eINSTANCE.getTJMember_Type();

    /**
     * The meta object literal for the '<em><b>Name</b></em>' attribute feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EAttribute TJ_MEMBER__NAME = eINSTANCE.getTJMember_Name();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJFieldImpl <em>TJ Field</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJFieldImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJField()
     * @generated
     */
    EClass TJ_FIELD = eINSTANCE.getTJField();

    /**
     * The meta object literal for the '<em><b>Init</b></em>' containment reference feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_FIELD__INIT = eINSTANCE.getTJField_Init();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJMethodDeclarationImpl <em>TJ Method Declaration</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJMethodDeclarationImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJMethodDeclaration()
     * @generated
     */
    EClass TJ_METHOD_DECLARATION = eINSTANCE.getTJMethodDeclaration();

    /**
     * The meta object literal for the '<em><b>Params</b></em>' containment reference list feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_METHOD_DECLARATION__PARAMS = eINSTANCE.getTJMethodDeclaration_Params();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJRequiredMethodImpl <em>TJ Required Method</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJRequiredMethodImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJRequiredMethod()
     * @generated
     */
    EClass TJ_REQUIRED_METHOD = eINSTANCE.getTJRequiredMethod();

    /**
     * The meta object literal for the '{@link xtraitj.xtraitj.impl.TJMethodImpl <em>TJ Method</em>}' class.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @see xtraitj.xtraitj.impl.TJMethodImpl
     * @see xtraitj.xtraitj.impl.XtraitjPackageImpl#getTJMethod()
     * @generated
     */
    EClass TJ_METHOD = eINSTANCE.getTJMethod();

    /**
     * The meta object literal for the '<em><b>Private</b></em>' attribute feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EAttribute TJ_METHOD__PRIVATE = eINSTANCE.getTJMethod_Private();

    /**
     * The meta object literal for the '<em><b>Body</b></em>' containment reference feature.
     * <!-- begin-user-doc -->
     * <!-- end-user-doc -->
     * @generated
     */
    EReference TJ_METHOD__BODY = eINSTANCE.getTJMethod_Body();

  }

} //XtraitjPackage

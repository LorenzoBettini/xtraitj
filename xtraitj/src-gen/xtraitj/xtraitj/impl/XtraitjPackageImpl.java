/**
 */
package xtraitj.xtraitj.impl;

import org.eclipse.emf.ecore.EAttribute;
import org.eclipse.emf.ecore.EClass;
import org.eclipse.emf.ecore.EPackage;
import org.eclipse.emf.ecore.EReference;

import org.eclipse.emf.ecore.impl.EPackageImpl;

import org.eclipse.xtext.common.types.TypesPackage;

import org.eclipse.xtext.xbase.XbasePackage;

import org.eclipse.xtext.xtype.XtypePackage;

import xtraitj.xtraitj.TJAliasOperation;
import xtraitj.xtraitj.TJClass;
import xtraitj.xtraitj.TJDeclaration;
import xtraitj.xtraitj.TJField;
import xtraitj.xtraitj.TJHideOperation;
import xtraitj.xtraitj.TJMember;
import xtraitj.xtraitj.TJMethod;
import xtraitj.xtraitj.TJMethodDeclaration;
import xtraitj.xtraitj.TJProgram;
import xtraitj.xtraitj.TJRedirectOperation;
import xtraitj.xtraitj.TJRenameOperation;
import xtraitj.xtraitj.TJRequiredMethod;
import xtraitj.xtraitj.TJRestrictOperation;
import xtraitj.xtraitj.TJTrait;
import xtraitj.xtraitj.TJTraitExpression;
import xtraitj.xtraitj.TJTraitOperation;
import xtraitj.xtraitj.TJTraitReference;
import xtraitj.xtraitj.TjTraitOperationForProvided;
import xtraitj.xtraitj.XtraitjFactory;
import xtraitj.xtraitj.XtraitjPackage;

/**
 * <!-- begin-user-doc -->
 * An implementation of the model <b>Package</b>.
 * <!-- end-user-doc -->
 * @generated
 */
public class XtraitjPackageImpl extends EPackageImpl implements XtraitjPackage
{
  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjProgramEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjDeclarationEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjTraitEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjClassEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjTraitExpressionEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjTraitReferenceEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjTraitOperationEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjTraitOperationForProvidedEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjHideOperationEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjRestrictOperationEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjAliasOperationEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjRenameOperationEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjRedirectOperationEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjMemberEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjFieldEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjMethodDeclarationEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjRequiredMethodEClass = null;

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private EClass tjMethodEClass = null;

  /**
   * Creates an instance of the model <b>Package</b>, registered with
   * {@link org.eclipse.emf.ecore.EPackage.Registry EPackage.Registry} by the package
   * package URI value.
   * <p>Note: the correct way to create the package is via the static
   * factory method {@link #init init()}, which also performs
   * initialization of the package, or returns the registered package,
   * if one already exists.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see org.eclipse.emf.ecore.EPackage.Registry
   * @see xtraitj.xtraitj.XtraitjPackage#eNS_URI
   * @see #init()
   * @generated
   */
  private XtraitjPackageImpl()
  {
    super(eNS_URI, XtraitjFactory.eINSTANCE);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private static boolean isInited = false;

  /**
   * Creates, registers, and initializes the <b>Package</b> for this model, and for any others upon which it depends.
   * 
   * <p>This method is used to initialize {@link XtraitjPackage#eINSTANCE} when that field is accessed.
   * Clients should not invoke it directly. Instead, they should simply access that field to obtain the package.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @see #eNS_URI
   * @see #createPackageContents()
   * @see #initializePackageContents()
   * @generated
   */
  public static XtraitjPackage init()
  {
    if (isInited) return (XtraitjPackage)EPackage.Registry.INSTANCE.getEPackage(XtraitjPackage.eNS_URI);

    // Obtain or create and register package
    XtraitjPackageImpl theXtraitjPackage = (XtraitjPackageImpl)(EPackage.Registry.INSTANCE.get(eNS_URI) instanceof XtraitjPackageImpl ? EPackage.Registry.INSTANCE.get(eNS_URI) : new XtraitjPackageImpl());

    isInited = true;

    // Initialize simple dependencies
    XbasePackage.eINSTANCE.eClass();
    XtypePackage.eINSTANCE.eClass();

    // Create package meta-data objects
    theXtraitjPackage.createPackageContents();

    // Initialize created meta-data
    theXtraitjPackage.initializePackageContents();

    // Mark meta-data to indicate it can't be changed
    theXtraitjPackage.freeze();

  
    // Update the registry and return the package
    EPackage.Registry.INSTANCE.put(XtraitjPackage.eNS_URI, theXtraitjPackage);
    return theXtraitjPackage;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJProgram()
  {
    return tjProgramEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EAttribute getTJProgram_Name()
  {
    return (EAttribute)tjProgramEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJProgram_ImportSection()
  {
    return (EReference)tjProgramEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJProgram_Elements()
  {
    return (EReference)tjProgramEClass.getEStructuralFeatures().get(2);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJDeclaration()
  {
    return tjDeclarationEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EAttribute getTJDeclaration_Name()
  {
    return (EAttribute)tjDeclarationEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJDeclaration_TraitExpression()
  {
    return (EReference)tjDeclarationEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJTrait()
  {
    return tjTraitEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJTrait_Members()
  {
    return (EReference)tjTraitEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJClass()
  {
    return tjClassEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJClass_Interfaces()
  {
    return (EReference)tjClassEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJClass_Fields()
  {
    return (EReference)tjClassEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJTraitExpression()
  {
    return tjTraitExpressionEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJTraitExpression_References()
  {
    return (EReference)tjTraitExpressionEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJTraitReference()
  {
    return tjTraitReferenceEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJTraitReference_Trait()
  {
    return (EReference)tjTraitReferenceEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJTraitReference_Operations()
  {
    return (EReference)tjTraitReferenceEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJTraitOperation()
  {
    return tjTraitOperationEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJTraitOperation_Member()
  {
    return (EReference)tjTraitOperationEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTjTraitOperationForProvided()
  {
    return tjTraitOperationForProvidedEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJHideOperation()
  {
    return tjHideOperationEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJRestrictOperation()
  {
    return tjRestrictOperationEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJAliasOperation()
  {
    return tjAliasOperationEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EAttribute getTJAliasOperation_Newname()
  {
    return (EAttribute)tjAliasOperationEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJRenameOperation()
  {
    return tjRenameOperationEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EAttribute getTJRenameOperation_Newname()
  {
    return (EAttribute)tjRenameOperationEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJRedirectOperation()
  {
    return tjRedirectOperationEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJRedirectOperation_Member2()
  {
    return (EReference)tjRedirectOperationEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJMember()
  {
    return tjMemberEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJMember_Type()
  {
    return (EReference)tjMemberEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EAttribute getTJMember_Name()
  {
    return (EAttribute)tjMemberEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJField()
  {
    return tjFieldEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJField_Init()
  {
    return (EReference)tjFieldEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJMethodDeclaration()
  {
    return tjMethodDeclarationEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJMethodDeclaration_Params()
  {
    return (EReference)tjMethodDeclarationEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJRequiredMethod()
  {
    return tjRequiredMethodEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EClass getTJMethod()
  {
    return tjMethodEClass;
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EAttribute getTJMethod_Private()
  {
    return (EAttribute)tjMethodEClass.getEStructuralFeatures().get(0);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public EReference getTJMethod_Body()
  {
    return (EReference)tjMethodEClass.getEStructuralFeatures().get(1);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public XtraitjFactory getXtraitjFactory()
  {
    return (XtraitjFactory)getEFactoryInstance();
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private boolean isCreated = false;

  /**
   * Creates the meta-model objects for the package.  This method is
   * guarded to have no affect on any invocation but its first.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void createPackageContents()
  {
    if (isCreated) return;
    isCreated = true;

    // Create classes and their features
    tjProgramEClass = createEClass(TJ_PROGRAM);
    createEAttribute(tjProgramEClass, TJ_PROGRAM__NAME);
    createEReference(tjProgramEClass, TJ_PROGRAM__IMPORT_SECTION);
    createEReference(tjProgramEClass, TJ_PROGRAM__ELEMENTS);

    tjDeclarationEClass = createEClass(TJ_DECLARATION);
    createEAttribute(tjDeclarationEClass, TJ_DECLARATION__NAME);
    createEReference(tjDeclarationEClass, TJ_DECLARATION__TRAIT_EXPRESSION);

    tjTraitEClass = createEClass(TJ_TRAIT);
    createEReference(tjTraitEClass, TJ_TRAIT__MEMBERS);

    tjClassEClass = createEClass(TJ_CLASS);
    createEReference(tjClassEClass, TJ_CLASS__INTERFACES);
    createEReference(tjClassEClass, TJ_CLASS__FIELDS);

    tjTraitExpressionEClass = createEClass(TJ_TRAIT_EXPRESSION);
    createEReference(tjTraitExpressionEClass, TJ_TRAIT_EXPRESSION__REFERENCES);

    tjTraitReferenceEClass = createEClass(TJ_TRAIT_REFERENCE);
    createEReference(tjTraitReferenceEClass, TJ_TRAIT_REFERENCE__TRAIT);
    createEReference(tjTraitReferenceEClass, TJ_TRAIT_REFERENCE__OPERATIONS);

    tjTraitOperationEClass = createEClass(TJ_TRAIT_OPERATION);
    createEReference(tjTraitOperationEClass, TJ_TRAIT_OPERATION__MEMBER);

    tjTraitOperationForProvidedEClass = createEClass(TJ_TRAIT_OPERATION_FOR_PROVIDED);

    tjHideOperationEClass = createEClass(TJ_HIDE_OPERATION);

    tjRestrictOperationEClass = createEClass(TJ_RESTRICT_OPERATION);

    tjAliasOperationEClass = createEClass(TJ_ALIAS_OPERATION);
    createEAttribute(tjAliasOperationEClass, TJ_ALIAS_OPERATION__NEWNAME);

    tjRenameOperationEClass = createEClass(TJ_RENAME_OPERATION);
    createEAttribute(tjRenameOperationEClass, TJ_RENAME_OPERATION__NEWNAME);

    tjRedirectOperationEClass = createEClass(TJ_REDIRECT_OPERATION);
    createEReference(tjRedirectOperationEClass, TJ_REDIRECT_OPERATION__MEMBER2);

    tjMemberEClass = createEClass(TJ_MEMBER);
    createEReference(tjMemberEClass, TJ_MEMBER__TYPE);
    createEAttribute(tjMemberEClass, TJ_MEMBER__NAME);

    tjFieldEClass = createEClass(TJ_FIELD);
    createEReference(tjFieldEClass, TJ_FIELD__INIT);

    tjMethodDeclarationEClass = createEClass(TJ_METHOD_DECLARATION);
    createEReference(tjMethodDeclarationEClass, TJ_METHOD_DECLARATION__PARAMS);

    tjRequiredMethodEClass = createEClass(TJ_REQUIRED_METHOD);

    tjMethodEClass = createEClass(TJ_METHOD);
    createEAttribute(tjMethodEClass, TJ_METHOD__PRIVATE);
    createEReference(tjMethodEClass, TJ_METHOD__BODY);
  }

  /**
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  private boolean isInitialized = false;

  /**
   * Complete the initialization of the package and its meta-model.  This
   * method is guarded to have no affect on any invocation but its first.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public void initializePackageContents()
  {
    if (isInitialized) return;
    isInitialized = true;

    // Initialize package
    setName(eNAME);
    setNsPrefix(eNS_PREFIX);
    setNsURI(eNS_URI);

    // Obtain other dependent packages
    XtypePackage theXtypePackage = (XtypePackage)EPackage.Registry.INSTANCE.getEPackage(XtypePackage.eNS_URI);
    TypesPackage theTypesPackage = (TypesPackage)EPackage.Registry.INSTANCE.getEPackage(TypesPackage.eNS_URI);
    XbasePackage theXbasePackage = (XbasePackage)EPackage.Registry.INSTANCE.getEPackage(XbasePackage.eNS_URI);

    // Create type parameters

    // Set bounds for type parameters

    // Add supertypes to classes
    tjTraitEClass.getESuperTypes().add(this.getTJDeclaration());
    tjClassEClass.getESuperTypes().add(this.getTJDeclaration());
    tjTraitOperationForProvidedEClass.getESuperTypes().add(this.getTJTraitOperation());
    tjHideOperationEClass.getESuperTypes().add(this.getTjTraitOperationForProvided());
    tjRestrictOperationEClass.getESuperTypes().add(this.getTjTraitOperationForProvided());
    tjAliasOperationEClass.getESuperTypes().add(this.getTjTraitOperationForProvided());
    tjRenameOperationEClass.getESuperTypes().add(this.getTJTraitOperation());
    tjRedirectOperationEClass.getESuperTypes().add(this.getTJTraitOperation());
    tjFieldEClass.getESuperTypes().add(this.getTJMember());
    tjMethodDeclarationEClass.getESuperTypes().add(this.getTJMember());
    tjRequiredMethodEClass.getESuperTypes().add(this.getTJMethodDeclaration());
    tjMethodEClass.getESuperTypes().add(this.getTJMethodDeclaration());

    // Initialize classes and features; add operations and parameters
    initEClass(tjProgramEClass, TJProgram.class, "TJProgram", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEAttribute(getTJProgram_Name(), ecorePackage.getEString(), "name", null, 0, 1, TJProgram.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getTJProgram_ImportSection(), theXtypePackage.getXImportSection(), null, "importSection", null, 0, 1, TJProgram.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getTJProgram_Elements(), this.getTJDeclaration(), null, "elements", null, 0, -1, TJProgram.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjDeclarationEClass, TJDeclaration.class, "TJDeclaration", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEAttribute(getTJDeclaration_Name(), ecorePackage.getEString(), "name", null, 0, 1, TJDeclaration.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getTJDeclaration_TraitExpression(), this.getTJTraitExpression(), null, "traitExpression", null, 0, 1, TJDeclaration.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjTraitEClass, TJTrait.class, "TJTrait", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getTJTrait_Members(), this.getTJMember(), null, "members", null, 0, -1, TJTrait.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjClassEClass, TJClass.class, "TJClass", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getTJClass_Interfaces(), theTypesPackage.getJvmParameterizedTypeReference(), null, "interfaces", null, 0, -1, TJClass.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getTJClass_Fields(), this.getTJField(), null, "fields", null, 0, -1, TJClass.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjTraitExpressionEClass, TJTraitExpression.class, "TJTraitExpression", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getTJTraitExpression_References(), this.getTJTraitReference(), null, "references", null, 0, -1, TJTraitExpression.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjTraitReferenceEClass, TJTraitReference.class, "TJTraitReference", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getTJTraitReference_Trait(), this.getTJTrait(), null, "trait", null, 0, 1, TJTraitReference.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getTJTraitReference_Operations(), this.getTJTraitOperation(), null, "operations", null, 0, -1, TJTraitReference.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjTraitOperationEClass, TJTraitOperation.class, "TJTraitOperation", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getTJTraitOperation_Member(), theTypesPackage.getJvmMember(), null, "member", null, 0, 1, TJTraitOperation.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjTraitOperationForProvidedEClass, TjTraitOperationForProvided.class, "TjTraitOperationForProvided", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

    initEClass(tjHideOperationEClass, TJHideOperation.class, "TJHideOperation", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

    initEClass(tjRestrictOperationEClass, TJRestrictOperation.class, "TJRestrictOperation", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

    initEClass(tjAliasOperationEClass, TJAliasOperation.class, "TJAliasOperation", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEAttribute(getTJAliasOperation_Newname(), ecorePackage.getEString(), "newname", null, 0, 1, TJAliasOperation.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjRenameOperationEClass, TJRenameOperation.class, "TJRenameOperation", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEAttribute(getTJRenameOperation_Newname(), ecorePackage.getEString(), "newname", null, 0, 1, TJRenameOperation.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjRedirectOperationEClass, TJRedirectOperation.class, "TJRedirectOperation", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getTJRedirectOperation_Member2(), theTypesPackage.getJvmMember(), null, "member2", null, 0, 1, TJRedirectOperation.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_COMPOSITE, IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjMemberEClass, TJMember.class, "TJMember", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getTJMember_Type(), theTypesPackage.getJvmTypeReference(), null, "type", null, 0, 1, TJMember.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEAttribute(getTJMember_Name(), ecorePackage.getEString(), "name", null, 0, 1, TJMember.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjFieldEClass, TJField.class, "TJField", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getTJField_Init(), theXbasePackage.getXExpression(), null, "init", null, 0, 1, TJField.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjMethodDeclarationEClass, TJMethodDeclaration.class, "TJMethodDeclaration", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEReference(getTJMethodDeclaration_Params(), theTypesPackage.getJvmFormalParameter(), null, "params", null, 0, -1, TJMethodDeclaration.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    initEClass(tjRequiredMethodEClass, TJRequiredMethod.class, "TJRequiredMethod", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);

    initEClass(tjMethodEClass, TJMethod.class, "TJMethod", !IS_ABSTRACT, !IS_INTERFACE, IS_GENERATED_INSTANCE_CLASS);
    initEAttribute(getTJMethod_Private(), ecorePackage.getEBoolean(), "private", null, 0, 1, TJMethod.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, !IS_UNSETTABLE, !IS_ID, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);
    initEReference(getTJMethod_Body(), theXbasePackage.getXExpression(), null, "body", null, 0, 1, TJMethod.class, !IS_TRANSIENT, !IS_VOLATILE, IS_CHANGEABLE, IS_COMPOSITE, !IS_RESOLVE_PROXIES, !IS_UNSETTABLE, IS_UNIQUE, !IS_DERIVED, IS_ORDERED);

    // Create resource
    createResource(eNS_URI);
  }

} //XtraitjPackageImpl

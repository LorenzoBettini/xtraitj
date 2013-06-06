/**
 */
package xtraitj.xtraitj.util;

import org.eclipse.emf.common.notify.Adapter;
import org.eclipse.emf.common.notify.Notifier;

import org.eclipse.emf.common.notify.impl.AdapterFactoryImpl;

import org.eclipse.emf.ecore.EObject;

import xtraitj.xtraitj.*;

/**
 * <!-- begin-user-doc -->
 * The <b>Adapter Factory</b> for the model.
 * It provides an adapter <code>createXXX</code> method for each class of the model.
 * <!-- end-user-doc -->
 * @see xtraitj.xtraitj.XtraitjPackage
 * @generated
 */
public class XtraitjAdapterFactory extends AdapterFactoryImpl
{
  /**
   * The cached model package.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected static XtraitjPackage modelPackage;

  /**
   * Creates an instance of the adapter factory.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  public XtraitjAdapterFactory()
  {
    if (modelPackage == null)
    {
      modelPackage = XtraitjPackage.eINSTANCE;
    }
  }

  /**
   * Returns whether this factory is applicable for the type of the object.
   * <!-- begin-user-doc -->
   * This implementation returns <code>true</code> if the object is either the model's package or is an instance object of the model.
   * <!-- end-user-doc -->
   * @return whether this factory is applicable for the type of the object.
   * @generated
   */
  @Override
  public boolean isFactoryForType(Object object)
  {
    if (object == modelPackage)
    {
      return true;
    }
    if (object instanceof EObject)
    {
      return ((EObject)object).eClass().getEPackage() == modelPackage;
    }
    return false;
  }

  /**
   * The switch that delegates to the <code>createXXX</code> methods.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @generated
   */
  protected XtraitjSwitch<Adapter> modelSwitch =
    new XtraitjSwitch<Adapter>()
    {
      @Override
      public Adapter caseTJProgram(TJProgram object)
      {
        return createTJProgramAdapter();
      }
      @Override
      public Adapter caseTJDeclaration(TJDeclaration object)
      {
        return createTJDeclarationAdapter();
      }
      @Override
      public Adapter caseTJTrait(TJTrait object)
      {
        return createTJTraitAdapter();
      }
      @Override
      public Adapter caseTJClass(TJClass object)
      {
        return createTJClassAdapter();
      }
      @Override
      public Adapter caseTJTraitExpression(TJTraitExpression object)
      {
        return createTJTraitExpressionAdapter();
      }
      @Override
      public Adapter caseTJTraitReference(TJTraitReference object)
      {
        return createTJTraitReferenceAdapter();
      }
      @Override
      public Adapter caseTJTraitOperation(TJTraitOperation object)
      {
        return createTJTraitOperationAdapter();
      }
      @Override
      public Adapter caseTjTraitOperationForProvided(TjTraitOperationForProvided object)
      {
        return createTjTraitOperationForProvidedAdapter();
      }
      @Override
      public Adapter caseTJHideOperation(TJHideOperation object)
      {
        return createTJHideOperationAdapter();
      }
      @Override
      public Adapter caseTJRestrictOperation(TJRestrictOperation object)
      {
        return createTJRestrictOperationAdapter();
      }
      @Override
      public Adapter caseTJAliasOperation(TJAliasOperation object)
      {
        return createTJAliasOperationAdapter();
      }
      @Override
      public Adapter caseTJRenameOperation(TJRenameOperation object)
      {
        return createTJRenameOperationAdapter();
      }
      @Override
      public Adapter caseTJRedirectOperation(TJRedirectOperation object)
      {
        return createTJRedirectOperationAdapter();
      }
      @Override
      public Adapter caseTJMember(TJMember object)
      {
        return createTJMemberAdapter();
      }
      @Override
      public Adapter caseTJField(TJField object)
      {
        return createTJFieldAdapter();
      }
      @Override
      public Adapter caseTJMethodDeclaration(TJMethodDeclaration object)
      {
        return createTJMethodDeclarationAdapter();
      }
      @Override
      public Adapter caseTJRequiredMethod(TJRequiredMethod object)
      {
        return createTJRequiredMethodAdapter();
      }
      @Override
      public Adapter caseTJMethod(TJMethod object)
      {
        return createTJMethodAdapter();
      }
      @Override
      public Adapter defaultCase(EObject object)
      {
        return createEObjectAdapter();
      }
    };

  /**
   * Creates an adapter for the <code>target</code>.
   * <!-- begin-user-doc -->
   * <!-- end-user-doc -->
   * @param target the object to adapt.
   * @return the adapter for the <code>target</code>.
   * @generated
   */
  @Override
  public Adapter createAdapter(Notifier target)
  {
    return modelSwitch.doSwitch((EObject)target);
  }


  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJProgram <em>TJ Program</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJProgram
   * @generated
   */
  public Adapter createTJProgramAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJDeclaration <em>TJ Declaration</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJDeclaration
   * @generated
   */
  public Adapter createTJDeclarationAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJTrait <em>TJ Trait</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJTrait
   * @generated
   */
  public Adapter createTJTraitAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJClass <em>TJ Class</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJClass
   * @generated
   */
  public Adapter createTJClassAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJTraitExpression <em>TJ Trait Expression</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJTraitExpression
   * @generated
   */
  public Adapter createTJTraitExpressionAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJTraitReference <em>TJ Trait Reference</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJTraitReference
   * @generated
   */
  public Adapter createTJTraitReferenceAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJTraitOperation <em>TJ Trait Operation</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJTraitOperation
   * @generated
   */
  public Adapter createTJTraitOperationAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TjTraitOperationForProvided <em>Tj Trait Operation For Provided</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TjTraitOperationForProvided
   * @generated
   */
  public Adapter createTjTraitOperationForProvidedAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJHideOperation <em>TJ Hide Operation</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJHideOperation
   * @generated
   */
  public Adapter createTJHideOperationAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJRestrictOperation <em>TJ Restrict Operation</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJRestrictOperation
   * @generated
   */
  public Adapter createTJRestrictOperationAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJAliasOperation <em>TJ Alias Operation</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJAliasOperation
   * @generated
   */
  public Adapter createTJAliasOperationAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJRenameOperation <em>TJ Rename Operation</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJRenameOperation
   * @generated
   */
  public Adapter createTJRenameOperationAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJRedirectOperation <em>TJ Redirect Operation</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJRedirectOperation
   * @generated
   */
  public Adapter createTJRedirectOperationAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJMember <em>TJ Member</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJMember
   * @generated
   */
  public Adapter createTJMemberAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJField <em>TJ Field</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJField
   * @generated
   */
  public Adapter createTJFieldAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJMethodDeclaration <em>TJ Method Declaration</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJMethodDeclaration
   * @generated
   */
  public Adapter createTJMethodDeclarationAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJRequiredMethod <em>TJ Required Method</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJRequiredMethod
   * @generated
   */
  public Adapter createTJRequiredMethodAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for an object of class '{@link xtraitj.xtraitj.TJMethod <em>TJ Method</em>}'.
   * <!-- begin-user-doc -->
   * This default implementation returns null so that we can easily ignore cases;
   * it's useful to ignore a case when inheritance will catch all the cases anyway.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @see xtraitj.xtraitj.TJMethod
   * @generated
   */
  public Adapter createTJMethodAdapter()
  {
    return null;
  }

  /**
   * Creates a new adapter for the default case.
   * <!-- begin-user-doc -->
   * This default implementation returns null.
   * <!-- end-user-doc -->
   * @return the new adapter.
   * @generated
   */
  public Adapter createEObjectAdapter()
  {
    return null;
  }

} //XtraitjAdapterFactory

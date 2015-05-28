package xtraitj.jvmmodel;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.emf.ecore.InternalEObject;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.xtext.LanguageInfo;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference;
import org.eclipse.xtext.common.types.JvmType;
import org.eclipse.xtext.common.types.JvmTypeConstraint;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.common.types.JvmUpperBound;
import org.eclipse.xtext.common.types.JvmVisibility;
import org.eclipse.xtext.common.types.JvmWildcardTypeReference;
import org.eclipse.xtext.common.types.TypesFactory;
import org.eclipse.xtext.common.types.access.impl.URIHelperConstants;
import org.eclipse.xtext.common.types.util.TypeReferences;
import org.eclipse.xtext.linking.lazy.LazyLinkingResource;
import org.eclipse.xtext.linking.lazy.LazyURIEncoder;
import org.eclipse.xtext.nodemodel.ICompositeNode;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.nodemodel.util.NodeModelUtils;
import org.eclipse.xtext.util.Strings;
import org.eclipse.xtext.util.Triple;
import org.eclipse.xtext.xbase.compiler.output.ITreeAppendable;
import org.eclipse.xtext.xbase.jvmmodel.IJvmModelAssociator;
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder;
import org.eclipse.xtext.xbase.lib.Procedures;
import org.eclipse.xtext.xbase.typesystem.InferredTypeIndicator;

import com.google.inject.Inject;

/**
 * See https://bugs.eclipse.org/bugs/show_bug.cgi?id=468174
 * 
 * @author bettini
 *
 */
public class PatchedJvmTypesBuilder extends JvmTypesBuilder {

	@Inject
	private IJvmModelAssociator associator;
	
	@Inject
	private TypeReferences references;
	
	@Inject
	private LanguageInfo languageInfo;
	
	@Inject
	private TypesFactory typesFactory;
	
	@Inject
	private LazyURIEncoder encoder;

	/**
	 * Creates a getter method for the given property name and the field name.
	 * 
	 * Example: <code>
	 * public String getPropertyName() {
	 *   return this.fieldName;
	 * }
	 * </code>
	 * 
	 * @return a getter method for a JavaBeans property, <code>null</code> if sourceElement or name are <code>null</code>.
	 */
	/* @Nullable */
	@Override
	public JvmOperation toGetter(/* @Nullable */ final EObject sourceElement, /* @Nullable */ final String propertyName, /* @Nullable */ final String fieldName, /* @Nullable */ JvmTypeReference typeRef) {
		if(sourceElement == null || propertyName == null || fieldName == null) 
			return null;
		JvmOperation result = typesFactory.createJvmOperation();
		result.setVisibility(JvmVisibility.PUBLIC);
		String prefix = (isPrimitiveBoolean(typeRef) ? "is" : "get");
		result.setSimpleName(prefix + Strings.toFirstUpper(propertyName));
		result.setReturnType(cloneWithProxies(typeRef));
		setBody(result, new Procedures.Procedure1<ITreeAppendable>() {
			@Override
			public void apply(/* @Nullable */ ITreeAppendable p) {
				if(p != null) {
					p = p.trace(sourceElement);
					p.append("return this.");
					p.append(fieldName);
					p.append(";");
				}
			}
		});
		return associate(sourceElement, result);
	}

	/**
	 * Detects whether the type reference refers to primitive boolean, first trying without
	 * triggering proxy resolution (looking at the original text reference).
	 * 
	 * https://bugs.eclipse.org/bugs/show_bug.cgi?id=468641
	 * 
	 * @param typeRef
	 * @return
	 */
	private boolean isPrimitiveBoolean(JvmTypeReference typeRef) {
		if (InferredTypeIndicator.isInferred(typeRef)) {
			return false;
		}
		
		ICompositeNode actualNodeFor = NodeModelUtils.findActualNodeFor(typeRef);
		if (actualNodeFor != null) {
			return "boolean".equals(NodeModelUtils.getTokenText(actualNodeFor));
		} else {
			return typeRef.getType()!=null 
					&& !typeRef.getType().eIsProxy() && "boolean".equals(typeRef.getType().getIdentifier());
		}
	}

	/**
	 * Creates a setter method for the given properties name with the standard implementation assigning the passed
	 * parameter to a similarly named field.
	 * 
	 * Example: <code>
	 * public void setFoo(String foo) {
	 *   this.foo = foo;
	 * }
	 * </code>
	 *
	 * @return a setter method for a JavaBeans property with the given name, <code>null</code> if sourceElement or name are <code>null</code>.
	 */
	/* @Nullable */ 
	@Override
	public JvmOperation toSetter(/* @Nullable */ final EObject sourceElement, /* @Nullable */ final String propertyName, /* @Nullable */ final String fieldName, /* @Nullable */ JvmTypeReference typeRef) {
		if(sourceElement == null || propertyName == null || fieldName == null) 
			return null;
		JvmOperation result = typesFactory.createJvmOperation();
		result.setVisibility(JvmVisibility.PUBLIC);
		result.setReturnType(references.getTypeForName(Void.TYPE,sourceElement));
		result.setSimpleName("set" + Strings.toFirstUpper(propertyName));
		result.getParameters().add(toParameter(sourceElement, propertyName, typeRef));
		setBody(result, new Procedures.Procedure1<ITreeAppendable>() {
			@Override
			public void apply(/* @Nullable */ ITreeAppendable p) {
				if(p != null) {
					p = p.trace(sourceElement);
					p.append("this.");
					p.append(fieldName);
					p.append(" = ");
					p.append(propertyName);
					p.append(";");
				}
			}
		});
		return associate(sourceElement, result);
	}


	/**
	 * Creates a deep copy of the given object and associates each copied instance with the
	 * clone. Does not resolve any proxies.
	 *	
	 * @param original the root element to be cloned.
	 * @return a clone of tree rooted in original associated with the original, <code>null</code> if original is <code>null</code>. 
	 */
	@Override
	protected <T extends EObject> T cloneAndAssociate(T original) {
		final boolean canAssociate = languageInfo.isLanguage(original.eResource());
		EcoreUtil.Copier copier = new CrossLinkingAwareCopier<EObject>(canAssociate, original);
		@SuppressWarnings("unchecked")
		T copy = (T) copier.copy(original);
		copier.copyReferences();
		return copy;
	}
	
	/**
	 * Creates a deep copy of the given object and associates each copied instance with the
	 * clone. Does not resolve any proxies.
	 *	
	 * @param original the root element to be cloned.
	 * @return a clone of tree rooted in original associated with the original, <code>null</code> if original is <code>null</code>. 
	 */
	@Override
	protected <T extends JvmTypeReference> T cloneAndAssociate(T original) {
		final boolean canAssociate = languageInfo.isLanguage(original.eResource());
		EcoreUtil.Copier copier = new CrossLinkingAwareCopier<EObject>(canAssociate, original) {
			private static final long serialVersionUID = 1L;

			@Override
			public EObject copy(/* @Nullable */ EObject eObject) {
				EObject result = super.copy(eObject);
				if (result instanceof JvmWildcardTypeReference) {
					boolean upperBoundSeen = false;
					for(JvmTypeConstraint constraint: ((JvmWildcardTypeReference) result).getConstraints()) {
						if (constraint instanceof JvmUpperBound) {
							upperBoundSeen = true;
							break;
						}
					}
					if (!upperBoundSeen) {
						// no upper bound found - seems to be an invalid - assume object as upper bound
						JvmTypeReference object = newObjectReference();
						JvmUpperBound upperBound = typesFactory.createJvmUpperBound();
						upperBound.setTypeReference(object);
						((JvmWildcardTypeReference) result).getConstraints().add(0, upperBound);
					}
				}
				return result;
			}
		};
		@SuppressWarnings("unchecked")
		T copy = (T) copier.copy(original);
		copier.copyReferences();
		return copy;
	}
	
	private JvmTypeReference newObjectReference() {
		JvmType objectType = typesFactory.createJvmGenericType();
		String objectClassName = Object.class.getName();
		((InternalEObject) objectType).eSetProxyURI(URIHelperConstants.OBJECTS_URI.appendSegment(objectClassName).appendFragment(objectClassName));
		JvmParameterizedTypeReference result = typesFactory.createJvmParameterizedTypeReference();
		result.setType(objectType);
		return result;
	}

	/**
	 * A custom copier that modifies the proxy URI so that it points to the new
	 * container.
	 * 
	 * https://bugs.eclipse.org/bugs/show_bug.cgi?id=468174
	 * 
	 * @author Sebastian Zarnekow - Initial contribution and API
	 * @author Lorenzo Bettini - Initial contribution and API
	 *
	 * @param <T>
	 */
	private class CrossLinkingAwareCopier<T extends EObject> extends
			EcoreUtil.Copier {

		private static final long serialVersionUID = 1L;

		final private boolean canAssociate;

		final private T original;

		private EObject copyEObject;

		public CrossLinkingAwareCopier(boolean canAssociate, T original) {
			super(false);
			this.canAssociate = canAssociate;
			this.original = original;
		}

		@Override
		protected void copyReference(EReference eReference, EObject eObject,
				EObject copyEObject) {
			try {
				this.copyEObject = copyEObject;
				super.copyReference(eReference, eObject, copyEObject);
			} finally {
				this.copyEObject = null;
			}
		}

		@Override
		/* @Nullable */
		protected EObject createCopy(/* @Nullable */EObject eObject) {
			EObject result = super.createCopy(eObject);
			if (canAssociate && result != null && eObject != null
					&& !eObject.eIsProxy()) {
				associator.associate(eObject, result);
			}
			return result;
		}

		@Override
		public EObject get(Object k) {
			EObject result = super.get(k);
			if (k instanceof InternalEObject) {
				InternalEObject key = (InternalEObject) k;
				if (result == null && key.eIsProxy()) {
					result = EcoreUtil.create(key.eClass());
					URI uri = EcoreUtil.getURI(key);
					Resource originalResource = original.eResource();
					if (originalResource != null && encoder.isCrossLinkFragment(originalResource,
							uri.fragment())) {
						Triple<EObject, EReference, INode> decodedProxyInfo = encoder
								.decode(originalResource, uri.fragment());
						LazyLinkingResource resource = (LazyLinkingResource) originalResource;
						int newURIFragmentIndex = resource
								.addLazyProxyInformation(copyEObject,
										decodedProxyInfo.getSecond(),
										decodedProxyInfo.getThird());
						URI newURI = uri.trimFragment().appendFragment(
								"|" + newURIFragmentIndex);
						((InternalEObject) result).eSetProxyURI(newURI);
					}
				}
			}
			return result;
		}
	}

}

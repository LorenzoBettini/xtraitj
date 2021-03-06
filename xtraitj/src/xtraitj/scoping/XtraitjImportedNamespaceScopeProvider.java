/**
 * 
 */
package xtraitj.scoping;

import static java.util.Collections.singletonList;

import java.util.List;
import java.util.Set;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EReference;
import org.eclipse.xtext.common.types.JvmDeclaredType;
import org.eclipse.xtext.common.types.JvmTypeParameter;
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator;
import org.eclipse.xtext.naming.QualifiedName;
import org.eclipse.xtext.resource.EObjectDescription;
import org.eclipse.xtext.resource.IEObjectDescription;
import org.eclipse.xtext.resource.ISelectable;
import org.eclipse.xtext.scoping.IScope;
import org.eclipse.xtext.scoping.impl.ImportNormalizer;
import org.eclipse.xtext.scoping.impl.MapBasedScope;
import org.eclipse.xtext.scoping.impl.ScopeBasedSelectable;
import org.eclipse.xtext.util.Strings;
import org.eclipse.xtext.xbase.scoping.XImportSectionNamespaceScopeProvider;

import xtraitj.jvmmodel.XtraitjJvmModelUtil;
import xtraitj.xtraitj.TJMethod;

import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import com.google.inject.Inject;

/**
 * Since we infer several Java methods for the same trait method, in case there
 * are type parameters involved, we must fix the scoping of type parameters
 * so that they refer to the type parameters of the method in the inferred
 * class for the trait.
 * 
 * @author Lorenzo Bettini
 *
 */
public class XtraitjImportedNamespaceScopeProvider extends
		XImportSectionNamespaceScopeProvider {
	
	@Inject private XtraitjJvmModelUtil jvmModelUtil;

	/**
	 * This is copied from the base class, with a fix for the type parameters
	 */
	@Override
	protected IScope getLocalElementsScope(IScope parent, IScope globalScope,
			EObject context, EReference reference) {
		IScope result = parent;
		QualifiedName name = getQualifiedNameOfLocalElement(context);
		boolean ignoreCase = isIgnoreCase(reference);
		ISelectable resourceOnlySelectable = getAllDescriptions(context.eResource());
		ISelectable globalScopeSelectable = new ScopeBasedSelectable(globalScope);
		
		// imports
		List<ImportNormalizer> explicitImports = getImportedNamespaceResolvers(context, ignoreCase);
		if (!explicitImports.isEmpty()) {
			result = createImportScope(result, explicitImports, globalScopeSelectable, reference.getEReferenceType(), ignoreCase);
		}
		
		// local element
		if (name!=null) {
			ImportNormalizer localNormalizer = doCreateImportNormalizer(name, true, ignoreCase); 
			result = createImportScope(result, singletonList(localNormalizer), resourceOnlySelectable, reference.getEReferenceType(), ignoreCase);
		}
		
		// scope for jvm elements
		/* This is the modified part, to retrieve the JvmOperation in the class
		 * inferred for the trait that corresponds to the original method */
		Set<EObject> elements = jvmModelUtil.allJvmElements(context);
		if (context instanceof TJMethod) {
			EObject primaryElement = jvmModelUtil.traitClassInferredMethod((TJMethod) context, elements);
			if (primaryElement != null)
				elements = Sets.newHashSet(primaryElement);
		}
		
		for (EObject derivedJvmElement : elements) {
			// scope for JvmDeclaredTypes
			if (derivedJvmElement instanceof JvmDeclaredType) {
				JvmDeclaredType declaredType = (JvmDeclaredType) derivedJvmElement;
				QualifiedName jvmTypeName = getQualifiedNameOfLocalElement(declaredType);
				if (declaredType.getDeclaringType() == null && !Strings.isEmpty(declaredType.getPackageName())) {
					QualifiedName packageName = this.getQualifiedNameConverter().toQualifiedName(declaredType.getPackageName());
					ImportNormalizer normalizer = doCreateImportNormalizer(packageName, true, ignoreCase);
					result = createImportScope(result, singletonList(normalizer), globalScopeSelectable, reference.getEReferenceType(), ignoreCase);
				}
				if (jvmTypeName != null && !jvmTypeName.equals(name)) {
					ImportNormalizer localNormalizer = doCreateImportNormalizer(jvmTypeName, true, ignoreCase); 
					result = createImportScope(result, singletonList(localNormalizer), resourceOnlySelectable, reference.getEReferenceType(), ignoreCase);
				}
			}
			// scope for JvmTypeParameterDeclarator
			if (derivedJvmElement instanceof JvmTypeParameterDeclarator) {
				JvmTypeParameterDeclarator parameterDeclarator = (JvmTypeParameterDeclarator) derivedJvmElement;
				List<IEObjectDescription> descriptions = null;
				for (JvmTypeParameter param : parameterDeclarator.getTypeParameters()) {
					if (param.getSimpleName() != null) {
						if (descriptions == null)
							descriptions = Lists.newArrayList();
						QualifiedName paramName = QualifiedName.create(param.getSimpleName());
						descriptions.add(EObjectDescription.create(paramName, param));
					}
				}
				if (descriptions != null && !descriptions.isEmpty())
					result = MapBasedScope.createScope(result, descriptions);
			}
		}
		return result;
	}
}

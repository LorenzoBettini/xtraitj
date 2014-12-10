/**
 * 
 */
package xtraitj.typesystem.^override;

import com.google.common.collect.Multimap
import java.util.List
import java.util.Set
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.typesystem.^override.AbstractResolvedOperation
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import org.eclipse.xtext.xbase.typesystem.^override.OverrideTester
import org.eclipse.xtext.xbase.typesystem.^override.ResolvedOperations
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference
import xtraitj.util.XtraitjAnnotatedElementHelper
import java.util.Collections

/**
 * Custom implementation that gives precedence to defined methods over
 * required methods.
 * 
 * @author Lorenzo Bettini
 *
 */
public class DefinedMethodAwareResolvedOperations extends ResolvedOperations {
	
	var private XtraitjAnnotatedElementHelper annotatedElementHelper;

	new(LightweightTypeReference type,
			OverrideTester overrideTester, XtraitjAnnotatedElementHelper annotatedElementHelper) {
		super(type, overrideTester);
		this.annotatedElementHelper = annotatedElementHelper;
	}

	override protected computeDeclaredOperations() {
		val rawType = getRawType();
		if (!(rawType instanceof JvmDeclaredType)) {
			return emptyList();
		}
		val result = newArrayList();
		val operations = (rawType as JvmDeclaredType).getDeclaredOperations();
		for(operation: operations) {
			result.add(createResolvedOperation(operation))
		}
		return Collections.unmodifiableList(result)
	}

	override protected void computeAllOperations(JvmDeclaredType type,
			Multimap<String, AbstractResolvedOperation> processedOperations,
			Set<JvmDeclaredType> processedTypes, List<IResolvedOperation> result) {
		if (type != null && !type.eIsProxy() && processedTypes.add(type)) {
			val operations = type.getDeclaredOperations();
			for(JvmOperation operation: operations) {
				val simpleName = operation.getSimpleName();
//				if (!hasAlreadyBeenRenamed(result, simpleName)) {
					if (processedOperations.containsKey(simpleName)) {
						if (isOverridden(operation, processedOperations.get(simpleName))) {
							
							if (annotatedElementHelper.annotatedDefinedMethod(operation)) {
								if (removeRequiredOperations(result, simpleName)) {
									processedOperations.removeAll(simpleName)
									addAsResolved(operation, processedOperations, simpleName, result);
								}
							}
						} else {
							addAsResolved(operation, processedOperations, simpleName, result);
						}
					} else {
						addAsResolved(operation, processedOperations, simpleName, result);
					}
//				}
			}
			for(JvmTypeReference superType: type.getSuperTypes()) {
				val rawSuperType = superType.getType();
				//if (rawSuperType.simpleName != Object.simpleName) // useful for debugging
				if (rawSuperType instanceof JvmDeclaredType) {
					computeAllOperations(rawSuperType, processedOperations, processedTypes, result);
				}
			}
		}
	}

	/**
	 * Removes the operations that are NOT annotated as defined methods
	 * (if they are declared in an interface inferred for a trait); it returns true
	 * if something has been removed
	 */
	protected def removeRequiredOperations(List<IResolvedOperation> result, String simpleName) {
		result.removeAll(
			result.filter[
				o |
				o.declaration.simpleName == simpleName
				&&
				annotatedElementHelper.annotatedTraitInterface(o.declaration.declaringType)
				&&
				!annotatedElementHelper.annotatedDefinedMethod(o.declaration)
			]
		)
	}

//	protected def hasAlreadyBeenRenamed(List<IResolvedOperation> result, String simpleName) {
//		result.exists[
//			o | 
//			annotatedElementHelper.annotatedRenamedMethodFor(o.declaration, simpleName)
//		]
//	}
	
	private def addAsResolved(JvmOperation operation, Multimap<String, AbstractResolvedOperation> processedOperations, String simpleName, List<IResolvedOperation> result) {
		val resolvedOperation = createResolvedOperation(operation);
		processedOperations.put(simpleName, resolvedOperation);
		result.add(resolvedOperation)
	}
}

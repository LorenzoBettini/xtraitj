/**
 * 
 */
package xtraitj.typesystem.^override;

import com.google.common.collect.Multimap
import java.util.Collections
import java.util.List
import java.util.Set
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.typesystem.^override.AbstractResolvedOperation
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import org.eclipse.xtext.xbase.typesystem.^override.OverrideTester
import org.eclipse.xtext.xbase.typesystem.^override.ResolvedFeatures
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference
import xtraitj.util.XtraitjAnnotatedElementHelper
import com.google.common.collect.Lists
import com.google.common.collect.HashMultimap
import com.google.common.collect.Sets

/**
 * Custom implementation that gives precedence to defined methods over
 * required methods.
 * 
 * @author Lorenzo Bettini
 *
 */
public class DefinedMethodAwareResolvedOperations extends ResolvedFeatures {
	
	var private XtraitjAnnotatedElementHelper annotatedElementHelper;

	new(LightweightTypeReference type,
			OverrideTester overrideTester, XtraitjAnnotatedElementHelper annotatedElementHelper) {
		super(type, overrideTester);
		this.annotatedElementHelper = annotatedElementHelper;
	}

	/**
	 * Temporarily override this method to reproduce the logic of
	 * Xtext 2.7.3; in the future we could override only specific methods.
	 */
	override protected computeAllOperations() {
		val rawType = getRawType();
		if (!(rawType instanceof JvmDeclaredType)) {
			return Collections.emptyList();
		}
		val result = Lists.newArrayList();
		val processed = HashMultimap.create();
		val processedTypes = Sets.newHashSet();
		computeAllOperations(rawType as JvmDeclaredType, processed, processedTypes, result);
		return Collections.unmodifiableList(result);
	}

	/**
	 * This used to be overridded when we were using Xtext 2.7.3; in Xtext 2.8
	 * this is not present anymore since the implementation has changed (see
	 * the note in the previous method)
	 */
	def protected void computeAllOperations(JvmDeclaredType type,
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

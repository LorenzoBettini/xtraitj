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

	override protected void computeAllOperations(JvmDeclaredType type,
			Multimap<String, AbstractResolvedOperation> processedOperations,
			Set<JvmDeclaredType> processedTypes, List<IResolvedOperation> result) {
		if (type != null && !type.eIsProxy() && processedTypes.add(type)) {
			val operations = type.getDeclaredOperations();
			for(JvmOperation operation: operations) {
				val simpleName = operation.getSimpleName();
				var continue = false
				if (processedOperations.containsKey(simpleName)) {
					if (isOverridden(operation, processedOperations.get(simpleName))) {
						if (annotatedElementHelper.annotatedDefinedMethod(operation)) {
							// a defined method has the precedence over existing
							// operations
							processedOperations.removeAll(simpleName);
						} else {
							continue = true;
						}
					}
				}
				if (!continue) {
					val resolvedOperation = createResolvedOperation(operation);
					processedOperations.put(simpleName, resolvedOperation);
					result.add(resolvedOperation);
				}
			}
			for(JvmTypeReference superType: type.getSuperTypes()) {
				val rawSuperType = superType.getType();
				if (rawSuperType instanceof JvmDeclaredType) {
					computeAllOperations(rawSuperType, processedOperations, processedTypes, result);
				}
			}
		}
	}
}

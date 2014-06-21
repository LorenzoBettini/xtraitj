/**
 * 
 */
package xtraitj.typesystem.override;

import java.util.List;
import java.util.Set;

import org.eclipse.xtext.common.types.JvmDeclaredType;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmType;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.xbase.typesystem.override.AbstractResolvedOperation;
import org.eclipse.xtext.xbase.typesystem.override.BottomResolvedOperation;
import org.eclipse.xtext.xbase.typesystem.override.IResolvedOperation;
import org.eclipse.xtext.xbase.typesystem.override.OverrideTester;
import org.eclipse.xtext.xbase.typesystem.override.ResolvedOperations;
import org.eclipse.xtext.xbase.typesystem.references.LightweightTypeReference;

import xtraitj.util.XtraitjAnnotatedElementHelper;

import com.google.common.collect.Multimap;

/**
 * Custom implementation that gives precedence to defined methods over
 * required methods.
 * 
 * @author Lorenzo Bettini
 *
 */
public class DefinedMethodAwareResolvedOperations extends ResolvedOperations {
	
	private XtraitjAnnotatedElementHelper annotatedElementHelper;

	public DefinedMethodAwareResolvedOperations(LightweightTypeReference type,
			OverrideTester overrideTester, XtraitjAnnotatedElementHelper annotatedElementHelper) {
		super(type, overrideTester);
		this.annotatedElementHelper = annotatedElementHelper;
	}

	@Override
	protected void computeAllOperations(JvmDeclaredType type,
			Multimap<String, AbstractResolvedOperation> processedOperations,
			Set<JvmDeclaredType> processedTypes, List<IResolvedOperation> result) {
		if (type != null && !type.eIsProxy() && processedTypes.add(type)) {
			Iterable<JvmOperation> operations = type.getDeclaredOperations();
			for(JvmOperation operation: operations) {
				String simpleName = operation.getSimpleName();
				if (processedOperations.containsKey(simpleName)) {
					if (isOverridden(operation, processedOperations.get(simpleName))) {
						if (annotatedElementHelper.annotatedDefinedMethod(operation)) {
							// a defined method has the precedence over existing
							// operations
							processedOperations.removeAll(simpleName);
						} else {
							continue;
						}
					}
				}
				BottomResolvedOperation resolvedOperation = createResolvedOperation(operation);
				processedOperations.put(simpleName, resolvedOperation);
				result.add(resolvedOperation);
			}
			for(JvmTypeReference superType: type.getSuperTypes()) {
				JvmType rawSuperType = superType.getType();
				if (rawSuperType instanceof JvmDeclaredType) {
					computeAllOperations((JvmDeclaredType) rawSuperType, processedOperations, processedTypes, result);
				}
			}
		}
	}
}

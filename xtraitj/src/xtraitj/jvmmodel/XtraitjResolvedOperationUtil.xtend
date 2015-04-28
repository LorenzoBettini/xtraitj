package xtraitj.jvmmodel

import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation

/**
 * Utility methods for IResolvedOperation
 * 
 * @author Lorenzo Bettini
 * 
 */
class XtraitjResolvedOperationUtil {

	protected new() {
		
	}

	def static getSimpleName(IResolvedOperation resolvedOperation) {
		return resolvedOperation.declaration.simpleName;
	}

	def static getReturnType(IResolvedOperation resolvedOperation) {
		return resolvedOperation.resolvedReturnType.toTypeReference;
	}

	def static getParametersTypes(IResolvedOperation resolvedOperation) {
		return resolvedOperation.resolvedParameterTypes.map[toTypeReference];
	}

}
package xtraitj.jvmmodel

import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation

/**
 * Stores information about instantiated type parametersType
 * 
 * @author Lorenzo Bettini
 * 
 */
class XtraitjJvmOperation {
	private IResolvedOperation resolvedOperation
	
//	private JvmOperation op;
//
//	private JvmTypeReference returnType;
//
//	private List<JvmTypeReference> parametersTypes;

	new(IResolvedOperation resolvedOperation) {
		this.resolvedOperation = resolvedOperation;
	}

	def getOp() {
		return resolvedOperation.declaration;
	}

	def getReturnType() {
		return resolvedOperation.resolvedReturnType.toTypeReference;
	}

	def getParametersTypes() {
		return resolvedOperation.resolvedParameterTypes.map[toTypeReference];
	}

//	/**
//	 * Whether some type parameters are still left (excluding the type parameters
//	 * of a method and the ones that appear in type arguments).
//	 * 
//	 * We need to exclude type parameters occurring in type arguments, since those
//	 * must be considered instantiated, e.g.,
//	 * 
//	 * <pre>
//	 * trait T1&lt;U&gt;
//	 * 
//	 * trait T2&lt;T&gt; uses T1&lt;T&gt;
//	 * </pre>
//	 * 
//	 * In this case occurrences of U should be considered type parameters not instantiated
//	 * while occurrences of T should be considered instantiated
//	 * 
//	 */
//	def hasTypeParametersDeclaredInJvmType(List<JvmTypeReference> typeArguments) {
//		(returnType.hasTypeParameterInJvmType(typeArguments) 
//			|| parametersTypes.exists[hasTypeParameterInJvmType(typeArguments)]
//		)
//	}
//
//	def boolean hasTypeParameterInJvmType(JvmTypeReference ref, List<JvmTypeReference> typeArguments) {
//		if (ref instanceof JvmParameterizedTypeReference) {
//			ref.typeParameterDeclaredInJvmType(typeArguments) ||
//			ref.arguments.exists[typeParameterDeclaredInJvmType(typeArguments)]
//		} else {
//			false
//		}
//	}
//
//	def boolean typeParameterDeclaredInJvmType(JvmTypeReference ref, List<JvmTypeReference> typeArguments) {
//		if (ref == null)
//			return false
//		
//		if (ref instanceof JvmWildcardTypeReference) {
//			return ref.constraints.exists[typeReference.hasTypeParameterInJvmType(typeArguments)]
//		}
//		
//		val type = ref.type
//		if (type instanceof JvmTypeParameter) {
//			type.declarator instanceof JvmType &&
//			!ref.occursInTypeArguments(typeArguments)
//		} else {
//			false
//		}
//	}
//
//	def boolean occursInTypeArguments(JvmTypeReference ref, List<JvmTypeReference> typeArguments) {
//		for (typeArgRef : typeArguments) {
//			if (typeArgRef.type === ref.type)
//				return true
//			
//			if (typeArgRef instanceof JvmParameterizedTypeReference)
//				if (ref.occursInTypeArguments(typeArgRef.arguments))
//					return true
//		}
//		return false
//	}
}
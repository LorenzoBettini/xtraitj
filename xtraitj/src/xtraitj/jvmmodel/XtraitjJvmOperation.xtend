package xtraitj.jvmmodel

import java.util.List
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmWildcardTypeReference
import org.eclipse.xtext.common.types.JvmType

/**
 * Stores information about instantiated type parametersType
 * 
 * @author Lorenzo Bettini
 * 
 */
class XtraitjJvmOperation {
	private JvmOperation op;

	private JvmTypeReference returnType;

	private List<JvmTypeReference> parametersTypes;

	new(JvmOperation op, JvmTypeReference returnType, List<JvmTypeReference> parametersTypes) {
		this.op = op;
		this.returnType = returnType;
		this.parametersTypes = parametersTypes;
	}

	def getOp() {
		return op;
	}

	def getReturnType() {
		return returnType;
	}

	def getParametersTypes() {
		return parametersTypes;
	}

	/**
	 * Whether some type parameters are still left (excluding the type parameters
	 * of a method and the ones that appear in type arguments).
	 * 
	 * We need to exclude type parameters occurring in type arguments, since those
	 * must be considered instantiated, e.g.,
	 * 
	 * <pre>
	 * trait T1&lt;U&gt;
	 * 
	 * trait T2&lt;T&gt; uses T1&lt;T&gt;
	 * </pre>
	 * 
	 * In this case occurrences of U should be considered type parameters not instantiated
	 * while occurrences of T should be considered instantiated
	 * 
	 */
	def hasTypeParametersDeclaredInJvmType(List<JvmTypeReference> typeArguments) {
		(returnType.hasTypeParameterInJvmType(typeArguments) 
			|| parametersTypes.exists[hasTypeParameterInJvmType(typeArguments)]
		)
	}

	def boolean hasTypeParameterInJvmType(JvmTypeReference ref, List<JvmTypeReference> typeArguments) {
		if (ref instanceof JvmParameterizedTypeReference) {
			ref.typeParameterDeclaredInJvmType(typeArguments) ||
			ref.arguments.exists[typeParameterDeclaredInJvmType(typeArguments)]
		} else {
			false
		}
	}

	def boolean typeParameterDeclaredInJvmType(JvmTypeReference ref, List<JvmTypeReference> typeArguments) {
		if (ref == null)
			return false
		
		if (ref instanceof JvmWildcardTypeReference) {
			return ref.constraints.exists[typeReference.hasTypeParameterInJvmType(typeArguments)]
		}
		
		val type = ref.type
		if (type instanceof JvmTypeParameter) {
			type.declarator instanceof JvmType &&
			!ref.occursInTypeArguments(typeArguments)
		} else {
			false
		}
	}

	def boolean occursInTypeArguments(JvmTypeReference ref, List<JvmTypeReference> typeArguments) {
		for (typeArgRef : typeArguments) {
			if (typeArgRef.type === ref.type)
				return true
			
			if (typeArgRef instanceof JvmParameterizedTypeReference)
				if (ref.occursInTypeArguments(typeArgRef.arguments))
					return true
		}
		return false
	}
}
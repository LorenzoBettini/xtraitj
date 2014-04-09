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
	 * of a method)
	 */
	def hasTypeParametersDeclaredInJvmType() {
		(returnType.hasTypeParameterInJvmType || parametersTypes.exists[hasTypeParameterInJvmType])
	}

	def boolean hasTypeParameterInJvmType(JvmTypeReference ref) {
		switch (ref) {
			JvmParameterizedTypeReference: {
				ref.typeParameterDeclaredInJvmType ||
				ref.arguments.exists[typeParameterDeclaredInJvmType]
			}
			JvmWildcardTypeReference: {
				ref.constraints.exists[typeReference.hasTypeParameterInJvmType]
			}
			default: false
		}
	}

	def boolean typeParameterDeclaredInJvmType(JvmTypeReference ref) {
		if (ref == null)
			return false
		
		val type = ref.type
		if (type instanceof JvmTypeParameter) {
			type.declarator instanceof JvmType
		} else {
			false
		}
	}
}
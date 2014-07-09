package xtraitj.types

import com.google.inject.Inject
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.common.types.JvmFormalParameter
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.jvmmodel.XtraitjJvmModelUtil

class XtraitjTraitPrivateSetterOperationWrapper extends XtraitjTraitPrivateOperationWrapper {
	
	@Inject extension XtraitjJvmModelUtil
	@Inject extension JvmTypesBuilder
	
	override String getSimpleName() {
		return super.getSimpleName().toSetterName
	}

	override EList<JvmFormalParameter> getParameters() {
		// builds a parameter based on the return type of the original
		// resolved operation
		if (parameters == null) {
			parameters = superGetParameters()
			val resolvedOperation = getResolvedOperation
			if (resolvedOperation != null)
				parameters += 
					getJvmOperation.toParameter(super.getSimpleName(), 
						resolvedOperation.resolvedReturnType.toTypeReference
					)
		}
		
		return parameters;
	}

	override getReturnType() {
		safeVoidType
	}
}
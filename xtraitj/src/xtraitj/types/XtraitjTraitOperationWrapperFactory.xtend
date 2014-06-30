package xtraitj.types

import com.google.inject.Inject
import com.google.inject.Provider
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import xtraitj.xtraitj.TJTraitOperation

class XtraitjTraitOperationWrapperFactory {
	@Inject Provider<XtraitjTraitRenameOperationWrapper> renameOpProvider
	
	@Inject Provider<XtraitjTraitPrivateOperationWrapper> privateOpProvider
	
	def createRenameOperationWrapper(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		renameOpProvider.get => [
			init(operation, typeReference)
		]	
	}

	def createPrivateOperationWrapper(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		privateOpProvider.get => [
			init(operation, typeReference)
		]	
	}
}
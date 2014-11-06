package xtraitj.types

import com.google.inject.Inject
import com.google.inject.Provider
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import xtraitj.xtraitj.TJTraitOperation

class XtraitjTraitOperationWrapperFactory {
	@Inject Provider<XtraitjTraitRenameOperationWrapper> renameOpProvider
	@Inject Provider<XtraitjTraitRenameGetterOperationWrapper> renameGetterOpProvider
	@Inject Provider<XtraitjTraitRenameSetterOperationWrapper> renameSetterOpProvider
	
	@Inject Provider<XtraitjTraitPrivateOperationWrapper> privateOpProvider
	@Inject Provider<XtraitjTraitPrivateGetterOperationWrapper> privateGetterOpProvider
	@Inject Provider<XtraitjTraitPrivateSetterOperationWrapper> privateSetterOpProvider
	
	def createRenameOperationWrapper(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		renameOpProvider.get => [
			init(operation, typeReference)
		]	
	}

	def createRenameOperationWrapperForGetter(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		renameGetterOpProvider.get => [
			init(operation, typeReference)
		]	
	}

	def createRenameOperationWrapperForSetter(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		renameSetterOpProvider.get => [
			init(operation, typeReference)
		]	
	}

	def createPrivateOperationWrapper(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		privateOpProvider.get => [
			init(operation, typeReference)
		]	
	}

	def createPrivateGetterOperationWrapper(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		privateGetterOpProvider.get => [
			init(operation, typeReference)
		]	
	}

	def createPrivateSetterOperationWrapper(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		privateSetterOpProvider.get => [
			init(operation, typeReference)
		]	
	}
}
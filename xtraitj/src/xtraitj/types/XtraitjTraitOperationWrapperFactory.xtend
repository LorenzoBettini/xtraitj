package xtraitj.types

import com.google.inject.Inject
import com.google.inject.Provider
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import xtraitj.xtraitj.TJTraitOperation

class XtraitjTraitOperationWrapperFactory {
	@Inject Provider<XtraitjTraitOperationWrapper> provider
	
	def create(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		provider.get => [
			init(operation, typeReference)
		]	
	}
}
package xtraitj.jvmmodel

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.typesystem.^override.OverrideHelper
import java.util.List
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import xtraitj.util.XtraitjAnnotatedElementHelper

class XtraitjJvmModelHelper {
	@Inject extension OverrideHelper
	@Inject extension XtraitjAnnotatedElementHelper
	
	val static objectClassName = Object.simpleName
	
	/**
	 * Excludes methods declared in java.lang.Object.
	 * The operations will have type parameters instantiated
	 */
	def getOperations(JvmTypeReference typeRef) {
		typeRef.resolvedOperations.allOperations.filter[
			declaration.declaringType.simpleName != objectClassName
		]
	}

	def getXtraitjResolvedOperations(JvmTypeReference typeRef) {
		val List<IResolvedOperation> requiredFields = newArrayList
		val List<IResolvedOperation> requiredMethods = newArrayList
		val List<IResolvedOperation> definedMethods = newArrayList
		
		for (o : typeRef.operations) {
			val declaration = o.declaration
			if (declaration.annotatedRequiredField)
				requiredFields += o
			else if (declaration.annotatedRequiredMethod)
				requiredMethods += o
			else if (declaration.annotatedDefinedMethod)
				definedMethods += o
		}
		
		new XtraitjResolvedOperations(requiredFields, requiredMethods, definedMethods)
	}
}
package xtraitj.jvmmodel

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.typesystem.^override.OverrideHelper

class XtraitjJvmModelHelper {
	@Inject extension OverrideHelper
	
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
}
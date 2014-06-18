package xtraitj.compiler

import org.eclipse.xtext.xbase.compiler.ErrorSafeExtensions
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmAnnotationReference
import org.eclipse.xtext.common.types.JvmUpperBound
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference

class XtraitjErrorSafeExtensions extends ErrorSafeExtensions {
	
//	override hasErrors(EObject element) {
//		// TODO: only if it's contained in an interface associated to a trait
//		// since we know that we create it in the model generator
//		if (element instanceof JvmAnnotationReference || element instanceof JvmUpperBound 
//			|| element instanceof JvmParameterizedTypeReference
//		)
//			return false
//		return super.hasErrors(element)
//	}
	
}
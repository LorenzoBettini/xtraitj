package xtraitj.compiler

import org.eclipse.xtext.xbase.compiler.ErrorSafeExtensions
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmAnnotationReference

class XtraitjErrorSafeExtensions extends ErrorSafeExtensions {
	
	override hasErrors(EObject element) {
		if (element instanceof JvmAnnotationReference)
			return false
		return super.hasErrors(element)
	}
	
}
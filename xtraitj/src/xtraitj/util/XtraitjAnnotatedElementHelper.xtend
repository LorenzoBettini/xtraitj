package xtraitj.util

import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmTypeReference
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface
import xtraitj.runtime.lib.annotation.XtraitjTraitClass
import org.eclipse.xtext.common.types.JvmMember
import xtraitj.runtime.lib.annotation.XtraitjRequiredField
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod

class XtraitjAnnotatedElementHelper {
	
	def annotatedTraitInterface(JvmTypeReference typeRef) {
		val type = typeRef.type
		if (type instanceof JvmDeclaredType)
			type.annotations.
				exists[
					annotation.identifier == XtraitjTraitInterface.name
				]
		else
			false
	}

	def annotatedTraitClass(JvmTypeReference typeRef) {
		val type = typeRef.type
		if (type instanceof JvmDeclaredType)
			type.annotations.
				exists[
					annotation.identifier == XtraitjTraitClass.name
				]
		else
			false
	}

	def annotatedRequiredField(JvmMember member) {
		member.annotations.
			exists[
				annotation.identifier == XtraitjRequiredField.name
			]
	}

	def annotatedRequiredMethod(JvmMember member) {
		member.annotations.
			exists[
				annotation.identifier == XtraitjRequiredMethod.name
			]
	}

	def annotatedDefinedMethod(JvmMember member) {
		member.annotations.
			exists[
				annotation.identifier == XtraitjDefinedMethod.name
			]
	}
}
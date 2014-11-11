package xtraitj.util

import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmTypeReference
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface
import xtraitj.runtime.lib.annotation.XtraitjTraitClass
import org.eclipse.xtext.common.types.JvmMember
import xtraitj.runtime.lib.annotation.XtraitjRequiredField
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod
import org.eclipse.xtext.common.types.JvmAnnotationReference
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod
import org.eclipse.xtext.common.types.JvmStringAnnotationValue

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

	def annotatedRenamedMethodFor(JvmMember member, String originalName) {
		member.annotations.
			exists[
				annotation.identifier == XtraitjRenamedMethod.name
				&&
				values.filter(JvmStringAnnotationValue).
					map[values].flatten.exists[it == originalName]
			]
	}

	def filterOutXtraitjAnnotations(Iterable<JvmAnnotationReference> annotations) {
		annotations.filter[
			!definedAnnotation
			&&
			!renameAnnotation
			&&
			!requiredMethodAnnotation
			&&
			!requiredFieldAnnotation
		]
	}

	def filterXtraitjAnnotations(Iterable<JvmAnnotationReference> annotations) {
		annotations.filter[
			definedAnnotation
			||
			renameAnnotation
			||
			requiredMethodAnnotation
			||
			requiredFieldAnnotation
		]
	}

	def filterOutXtraitjDefinedAnnotations(Iterable<JvmAnnotationReference> annotations) {
		annotations.filter[
			!definedAnnotation
		]
	}

	def isRenameAnnotation(JvmAnnotationReference ref) {
		ref.annotation.identifier == XtraitjRenamedMethod.name
	}

	def isDefinedAnnotation(JvmAnnotationReference ref) {
		ref.annotation.identifier == XtraitjDefinedMethod.name
	}

	def isRequiredMethodAnnotation(JvmAnnotationReference ref) {
		ref.annotation.identifier == XtraitjRequiredMethod.name
	}

	def isRequiredFieldAnnotation(JvmAnnotationReference ref) {
		ref.annotation.identifier == XtraitjRequiredField.name
	}
}
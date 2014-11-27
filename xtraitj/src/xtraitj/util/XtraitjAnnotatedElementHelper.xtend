package xtraitj.util

import com.google.inject.Singleton
import org.eclipse.xtext.common.types.JvmAnnotationReference
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmMember
import org.eclipse.xtext.common.types.JvmStringAnnotationValue
import org.eclipse.xtext.common.types.JvmTypeReference
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod
import xtraitj.runtime.lib.annotation.XtraitjRequiredField
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod
import xtraitj.runtime.lib.annotation.XtraitjTraitClass
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface

@Singleton
class XtraitjAnnotatedElementHelper {
	
	def annotatedTraitInterface(JvmTypeReference typeRef) {
		val type = typeRef.type
		if (type instanceof JvmDeclaredType)
			annotatedTraitInterface(type)
		else
			false
	}
	
	def annotatedTraitInterface(JvmDeclaredType type) {
		type.annotations.
			exists[
				annotation.identifier == XtraitjTraitInterface.name
			]
	}

	def annotatedTraitClass(JvmTypeReference typeRef) {
		val type = typeRef.type
		if (type instanceof JvmDeclaredType)
			annotatedTraitClass(type)
		else
			false
	}
	
	def annotatedTraitClass(JvmDeclaredType type) {
		type.annotations.
			exists[
				annotation.identifier == XtraitjTraitClass.name
			]
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
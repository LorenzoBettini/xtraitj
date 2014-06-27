package xtraitj.typing

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmType
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.util.Primitives
import org.eclipse.xtext.xbase.typesystem.legacy.StandardTypeReferenceOwner
import org.eclipse.xtext.xbase.typesystem.references.OwnedConverter
import org.eclipse.xtext.xbase.typesystem.util.CommonTypeComputationServices

class XtraitjTypingUtil {
	
	@Inject CommonTypeComputationServices services;
	@Inject extension Primitives
	
	val static objectClassName = Object.simpleName
	
	def sameType(EObject context, JvmTypeReference t1, JvmTypeReference t2) {
		if (t1 == null || t2 == null)
			return false
		// for primitive types, they must be considered the
		// same only if they refer to the same type
		// otherwise int is considered the same as Integer
		// but in Java method signatures they are not the same!
		if (t1.primitive || t2.primitive)
			return t1.type == t2.type
		
		val type1 = t1.toLightweightTypeReference(context)
		val type2 = t2.toLightweightTypeReference(context)
		return type1.isAssignableFrom(type2) && type2.isAssignableFrom(type1)
	}

	def isSubtype(EObject context, JvmTypeReference t1, JvmTypeReference t2) {
		if (t1 == null || t2 == null)
			return false
		// for primitive types, they must be considered the
		// subtype only if they refer to the same type
		// otherwise int is considered subtype of Integer
		// but in Java method signatures they are different!
		if (t1.primitive || t2.primitive)
			return t1.type == t2.type

		val type1 = t1.toLightweightTypeReference(context)
		val type2 = t2.toLightweightTypeReference(context)
		type2.isAssignableFrom(type1)
	}
	
	def toLightweightTypeReference(JvmTypeReference typeRef, EObject context) {
		val converter = new OwnedConverter(new StandardTypeReferenceOwner(services, context))
		converter.toLightweightReference(typeRef)
	}

	def isNotJavaLangObject(JvmType type) {
		type.simpleName != objectClassName
	}
	
}
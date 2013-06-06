package xtraitj.typing

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.xbase.typesystem.legacy.StandardTypeReferenceOwner
import org.eclipse.xtext.xbase.typesystem.references.OwnedConverter
import org.eclipse.xtext.xbase.typesystem.util.CommonTypeComputationServices
import org.eclipse.xtext.common.types.util.Primitives

class TraitJTypingUtil {
	
	@Inject CommonTypeComputationServices services;
	@Inject extension Primitives
	
	def sameType(JvmTypeReference t1, JvmTypeReference t2) {
		if (t1 == null || t2 == null)
			return false
		// for primitive types, they must be considered the
		// same only if they refer to the same type
		// otherwise int is considered the same as Integer
		// but in Java method signatures they are not the same!
		if (t1.primitive || t2.primitive)
			return t1.type == t2.type
		
		val type1 = t1.toLightweightTypeReference
		val type2 = t2.toLightweightTypeReference
		return type1.isAssignableFrom(type2) && type2.isAssignableFrom(type1)
	}

	def isSubtype(JvmTypeReference t1, JvmTypeReference t2) {
		if (t1 == null || t2 == null)
			return false
		// for primitive types, they must be considered the
		// subtype only if they refer to the same type
		// otherwise int is considered subtype of Integer
		// but in Java method signatures they are different!
		if (t1.primitive || t2.primitive)
			return t1.type == t2.type

		val type1 = t1.toLightweightTypeReference
		val type2 = t2.toLightweightTypeReference
		type2.isAssignableFrom(type1)
	}
	
	def toLightweightTypeReference(JvmTypeReference typeRef) {
		val converter = new OwnedConverter(new StandardTypeReferenceOwner(services, typeRef))
		converter.toLightweightReference(typeRef)
	}

}
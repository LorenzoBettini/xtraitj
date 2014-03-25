package xtraitj.compiler

import org.eclipse.xtext.xbase.compiler.TypeReferenceSerializer
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmTypeParameter
import com.google.inject.Inject
import xtraitj.jvmmodel.TraitJJvmModelUtil
import org.eclipse.xtext.common.types.JvmGenericType

/**
 * @author Lorenzo Bettini
 */
class XtraitjTypeReferenceSerializer extends TypeReferenceSerializer {
	
	@Inject extension TraitJJvmModelUtil
	
	override isLocalTypeParameter(EObject context, JvmTypeParameter parameter) {
		/*
		 * For a trait we also infer a class with the same type parameters as the
		 * associated trait; however, the type parameters are declared in the trait
		 * thus, we must consider that isLocalTypeParameter returns true
		 * in this case, otherwise the type parameter is serialized as '?'
		 */
		
		if (context instanceof JvmGenericType) {
			if (context.associatedTrait != null)
				return true;
		}
		
		return super.isLocalTypeParameter(context, parameter)
	}
	
}
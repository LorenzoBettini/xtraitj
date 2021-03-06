package xtraitj.compiler

import org.eclipse.xtext.xbase.compiler.TypeReferenceSerializer
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.common.types.JvmTypeParameter
import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmGenericType
import xtraitj.jvmmodel.XtraitjJvmModelUtil

/**
 * @author Lorenzo Bettini
 */
class XtraitjTypeReferenceSerializer extends TypeReferenceSerializer {
	
	@Inject extension XtraitjJvmModelUtil
	
	override isLocalTypeParameter(EObject context, JvmTypeParameter parameter) {
		/*
		 * For a trait we also generate an interface with the same type parameters as the
		 * associated trait; this interface is created on the fly by the model generator
		 * thus, we must consider that isLocalTypeParameter returns true
		 * in this case, otherwise the type parameter is serialized as '?'.
		 * The same holds for type parameters of methods (in this case we need to
		 * handle the case of an associated Xtraitj class)
		 */
		
		if (context instanceof JvmGenericType) {
			if (context.associatedTrait != null 
					|| context.associatedTJClass != null
					|| context.associatedTraitReference != null)
				return true;
		}
		
		return super.isLocalTypeParameter(context, parameter)
	}
	
}
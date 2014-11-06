/**
 * 
 */
package xtraitj.types;

import com.google.inject.Inject
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.common.types.JvmFormalParameter
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import xtraitj.jvmmodel.XtraitjJvmModelUtil
import xtraitj.util.XtraitjAnnotatedElementHelper

/**
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitRenameSetterOperationWrapper extends XtraitjTraitRenameOperationWrapper {

	@Inject extension XtraitjJvmModelUtil
	@Inject extension JvmTypesBuilder
	@Inject extension XtraitjAnnotatedElementHelper
	
	override processOperationSpecificAnnotations() {
		getAnnotations.removeAll(getAnnotations.filterXtraitjAnnotations)
	}

	override String getSimpleName() {
		return renameOperation.getNewname().toSetterName
	}
	
	override EList<JvmFormalParameter> getParameters() {
		// builds a parameter based on the return type of the original
		// resolved operation
		if (parameters == null) {
			parameters = superGetParameters()
			val resolvedOperation = getResolvedOperation
			if (resolvedOperation != null)
				parameters += 
					getJvmOperation.toParameter(renameOperation.newname, 
						resolvedOperation.resolvedReturnType.toTypeReference
					)
		}
		
		return parameters;
	}

	override getReturnType() {
		safeVoidType
	}
	
}

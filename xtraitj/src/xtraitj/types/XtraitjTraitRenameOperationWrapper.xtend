/**
 * 
 */
package xtraitj.types;

import com.google.inject.Inject
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.xtraitj.TJRenameOperation

/**
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitRenameOperationWrapper extends XtraitjTraitOperationWrapper {

	@Inject extension XtraitjGeneratorExtensions
	
	override processOperationSpecificAnnotations() {
		val jvmOperation = getJvmOperation()
		if (jvmOperation != null)
			getOperation.annotateAsRenamedMethod(this, getJvmOperation().simpleName)
	}

	def getRenameOperation() {
		(operation as TJRenameOperation)
	}

	override String getSimpleName() {
		return renameOperation.getNewname();
	}

//	override String computeIdentifier() {
//		return renameOperation.getNewname();
//	}
	
}

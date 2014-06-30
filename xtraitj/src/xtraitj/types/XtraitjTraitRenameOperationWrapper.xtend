/**
 * 
 */
package xtraitj.types;

import com.google.inject.Inject
import xtraitj.generator.XtraitjGeneratorExtensions
import xtraitj.util.XtraitjAnnotatedElementHelper
import xtraitj.xtraitj.TJRenameOperation

/**
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitRenameOperationWrapper extends XtraitjTraitOperationWrapper {

	@Inject extension XtraitjGeneratorExtensions
	@Inject extension XtraitjAnnotatedElementHelper
	
	override processOperationSpecificAnnotations() {
		// since we can rename an already renamed element, we must remove
		// possible existing rename annotations
		annotations.removeAll(annotations.filter[renameAnnotation])
		getOperation.annotateAsRenamedMethod(this, getJvmOperation().simpleName)
	}

	def getRenameOperation() {
		(operation as TJRenameOperation)
	}

	override String getSimpleName() {
		return renameOperation.getNewname();
	}

	override String computeIdentifier() {
		return renameOperation.getNewname();
	}
	
}

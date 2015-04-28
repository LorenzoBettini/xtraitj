/**
 * 
 */
package xtraitj.types;

import com.google.inject.Inject
import org.eclipse.xtext.common.types.JvmVisibility
import xtraitj.util.XtraitjAnnotatedElementHelper

/**
 * This represents a private operation wrapper that must not be
 * returned when computing all the operations of a type.
 * 
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitPrivateOperationWrapper extends XtraitjTraitOperationWrapper {
	
	@Inject extension XtraitjAnnotatedElementHelper

	override processOperationSpecificAnnotations() {
		getAnnotations.removeAll(getAnnotations.filterXtraitjAnnotations)
	}

	override getVisibility() {
		JvmVisibility.PRIVATE
	}
	
}

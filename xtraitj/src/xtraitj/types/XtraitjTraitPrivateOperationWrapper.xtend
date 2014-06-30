/**
 * 
 */
package xtraitj.types;

import org.eclipse.xtext.common.types.JvmVisibility
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod

/**
 * This represents a private operation wrapper that must not be
 * returned when computing all the operations of a type.
 * 
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitPrivateOperationWrapper extends XtraitjTraitOperationWrapper {

	override processOperationSpecificAnnotations() {
		getAnnotations.removeAll(getAnnotations.filter[it instanceof XtraitjDefinedMethod])
	}

	override getVisibility() {
		JvmVisibility.PRIVATE
	}
	
}

/**
 * 
 */
package xtraitj.types;

import org.eclipse.xtext.common.types.JvmVisibility
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod

/**
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitHideOperationWrapper extends XtraitjTraitOperationWrapper {

	override processOperationSpecificAnnotations() {
		getAnnotations.removeAll(getAnnotations.filter[it instanceof XtraitjDefinedMethod])
	}

	override getVisibility() {
		JvmVisibility.PRIVATE
	}
	
}

/**
 * 
 */
package xtraitj.validation;

import org.eclipse.xtext.xbase.validation.JvmTypeReferencesValidator;

/**
 * Temporary fix for https://bugs.eclipse.org/bugs/show_bug.cgi?id=453286 (see
 * also https://www.eclipse.org/forums/index.php/t/870734/)
 * 
 * @author Lorenzo Bettini
 *
 */
public class XtraitjJvmTypeReferencesValidator extends
		JvmTypeReferencesValidator {

	@Override
	public boolean isLanguageSpecific() {
		return false;
	}
}

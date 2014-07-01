/**
 * 
 */
package xtraitj.types;

import com.google.inject.Inject
import xtraitj.jvmmodel.XtraitjJvmModelUtil

/**
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitRenameGetterOperationWrapper extends XtraitjTraitRenameOperationWrapper {

	@Inject extension XtraitjJvmModelUtil
	
	override String getSimpleName() {
		// don't do that: it triggers scoping
//		return operation.member.simpleName.renameGetterOrSetter(
//			renameOperation.getNewname())
		return renameOperation.getNewname().toGetterName;
	}

}

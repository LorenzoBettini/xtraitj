/**
 * 
 */
package xtraitj.types;

import org.eclipse.xtext.util.Strings
import org.eclipse.xtext.xbase.typesystem.InferredTypeIndicator

/**
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitRenameGetterOperationWrapper extends XtraitjTraitRenameOperationWrapper {

	override String getSimpleName() {
		// when members are not yet resolved we simply use "get" as a prefix
		// later, when they are resolved, we can use the correct prefix
		var prefix = "get";
		if (!isReferredMemberProxyOrNull()) {
			val typeRef = jvmOperation.returnType
			if (typeRef != null && !typeRef.eIsProxy() && !InferredTypeIndicator.isInferred(typeRef) 
					&& typeRef.getType()!=null 
					&& !typeRef.getType().eIsProxy() && "boolean".equals(typeRef.getType().getIdentifier())) {
				prefix = "is";
			}
		}

		return prefix + Strings.toFirstUpper(renameOperation.getNewname());
	}
	
}

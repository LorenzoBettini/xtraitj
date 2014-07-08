package xtraitj.types

import xtraitj.types.XtraitjTraitPrivateOperationWrapper
import org.eclipse.xtext.xbase.typesystem.InferredTypeIndicator
import org.eclipse.xtext.util.Strings

class XtraitjTraitPrivateGetterOperationWrapper extends XtraitjTraitPrivateOperationWrapper {
	
	override String getSimpleName() {
		// when members are not yet resolved we simply use "get" as a prefix
		// later, when they are resolved, we can use the correct prefix
		var prefix = "get";
		if (!isReferredMemberProxy()) {
			val typeRef = jvmOperation.returnType
			if (typeRef != null && !typeRef.eIsProxy() && !InferredTypeIndicator.isInferred(typeRef) 
					&& typeRef.getType()!=null 
					&& !typeRef.getType().eIsProxy() && "boolean".equals(typeRef.getType().getIdentifier())) {
				prefix = "is";
			}
		}

		return prefix + Strings.toFirstUpper(super.getSimpleName());
	}
}
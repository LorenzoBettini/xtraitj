package xtraitj.typesystem.conformance

import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.xbase.typesystem.conformance.TypeConformanceComputer
import org.eclipse.xtext.xbase.typesystem.references.ParameterizedTypeReference
import xtraitj.jvmmodel.XtraitjJvmModelUtil

/**
 * @author Lorenzo Bettini
 */
@Singleton
class XtraitjTypeConformanceComputer extends TypeConformanceComputer {
	
	@Inject extension XtraitjJvmModelUtil
	
	override doIsConformant(ParameterizedTypeReference left, ParameterizedTypeReference right, int flags) {
		val result = super.doIsConformant(left, right, flags)

		if ((result.bitwiseAnd(SUCCESS)) == 0) {
			// let's see if they are associated to the same trait definition
			val leftType = left.getType();
			val rightType = right.getType();
			if (leftType instanceof JvmTypeParameter && rightType instanceof JvmTypeParameter) {
				val leftTypePar = leftType as JvmTypeParameter
				val rightTypePar = rightType as JvmTypeParameter
				if (leftTypePar.simpleName == rightTypePar.simpleName &&
						leftTypePar.declarator.associatedTrait === 
						rightTypePar.declarator.associatedTrait)
					return flags.bitwiseOr(SUCCESS).bitwiseOr(SUBTYPE);
			}
		}

		return result
	}
}
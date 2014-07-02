package xtraitj.types

import java.util.Map
import org.eclipse.xtext.common.types.JvmConstraintOwner
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmWildcardTypeReference
import org.eclipse.xtext.xtype.XFunctionTypeRef
import com.google.inject.Singleton
import com.google.inject.Inject
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder

@Singleton
class XtraitjTypeParameterHelper {
	
	@Inject extension JvmTypesBuilder
	
	/**
	 * It is crucial to rebind the type parameter reference to the
	 * interface inferred for the trait, otherwise the type parameter
	 * will point to the class inferred for the trait and we
	 * get IllegalArgumentException during the typing (the reference owner
	 * is different)
	 */
	def JvmTypeReference rebindTypeParameters(JvmTypeReference typeRef, JvmTypeParameterDeclarator containerTypeDecl, JvmTypeParameterDeclarator containerOperation) {
		typeRef.rebindTypeParameters(containerTypeDecl, containerOperation, newHashMap())
	}

	def JvmTypeReference rebindTypeParameters(JvmTypeReference typeRef, JvmTypeParameterDeclarator containerTypeDecl, 
			JvmTypeParameterDeclarator containerOperation, Map<JvmTypeParameter, JvmTypeParameter> visited
	) {
		val reboundTypeRef = typeRef.cloneWithProxies
		
		if (reboundTypeRef instanceof JvmParameterizedTypeReference) {
			val type = reboundTypeRef.type
			
			if (type instanceof JvmTypeParameter) {
				var typePar = visited.get(type)
				
				if (typePar === null) {
					typePar = findCorrespondingTypeParameter(containerTypeDecl, reboundTypeRef)
					
					// the typePar can now be null if it refers to a method's generic type
					if (typePar === null && containerOperation !== null) {
						typePar = findCorrespondingTypeParameter(containerOperation, reboundTypeRef)
					}					
					
					if (typePar !== null) {
						visited.put(type, typePar)

						rebindConstraintsTypeParameters(typePar, containerTypeDecl, containerOperation, visited)

						reboundTypeRef.type = typePar
					}
				}
			}
			
			// rebind type arguments as well
			val arguments = reboundTypeRef.arguments
			for (i : 0..<arguments.size()) {
				arguments.set(i, arguments.get(i).rebindTypeParameters(containerTypeDecl, containerOperation, visited))
			}
			
			return reboundTypeRef
		}

		if (reboundTypeRef instanceof JvmWildcardTypeReference) {
			reboundTypeRef.rebindConstraintsTypeParameters(containerTypeDecl, containerOperation, visited)
			return reboundTypeRef
		}
		
		if (reboundTypeRef instanceof XFunctionTypeRef) {
			val reboundReturnTypeRef = reboundTypeRef.returnType.rebindTypeParameters(containerTypeDecl, containerOperation, visited)
			reboundTypeRef.returnType = reboundReturnTypeRef
			return reboundTypeRef
		}
		
		return typeRef
	}
	
	def findCorrespondingTypeParameter(JvmTypeParameterDeclarator declarator, JvmParameterizedTypeReference reboundTypeRef) {
		declarator.typeParameters.findFirst[name == reboundTypeRef.type.simpleName]
	}
	
	def rebindConstraintsTypeParameters(JvmConstraintOwner constraintOwner, JvmTypeParameterDeclarator containerDecl, JvmTypeParameterDeclarator containerOperation, Map<JvmTypeParameter, JvmTypeParameter> visited) {
		val constraints = constraintOwner.constraints
		for (i : 0..<constraints.size) {
			val constraint = constraints.get(i)
			constraint.typeReference = constraint.typeReference.rebindTypeParameters(containerDecl, containerOperation, visited)
		}
	}
}
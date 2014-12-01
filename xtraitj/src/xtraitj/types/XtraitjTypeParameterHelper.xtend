package xtraitj.types

import com.google.inject.Inject
import com.google.inject.Singleton
import java.util.Map
import org.eclipse.xtext.common.types.JvmConstraintOwner
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeParameterDeclarator
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmWildcardTypeReference
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xtype.XFunctionTypeRef
import org.eclipse.xtext.common.types.JvmUpperBound

@Singleton
class XtraitjTypeParameterHelper {
	
	@Inject extension JvmTypesBuilder

	def void rebindTypeParameters(JvmOperation op, JvmTypeParameterDeclarator containerTypeDecl) {
		op.returnType = op.returnType.rebindTypeParameters(containerTypeDecl, op)
		for (p : op.parameters) {
			p.parameterType = p.parameterType.rebindTypeParameters(containerTypeDecl, op)
		}
	}

	/**
	 * It is crucial to rebind the type parameter references to the
	 * correct type parameter declarator, otherwise the type parameter
	 * will be the wrong one, leading to failures in the typing of expressions and
	 * IllegalArgumentException during the typing (the reference owner
	 * is different).
	 * 
	 * This is used both for rebinding methods type parameters for wrapper operations, and
	 * for every type parameters in the interfaces created during the model generation.
	 */
	def JvmTypeReference rebindTypeParameters(JvmTypeReference typeRef, JvmTypeParameterDeclarator containerTypeDecl, JvmTypeParameterDeclarator containerOperation) {
		typeRef.rebindTypeParameters(containerTypeDecl, containerOperation, newHashMap())
	}

	def JvmTypeReference rebindTypeParameters(JvmTypeReference typeRef, JvmTypeParameterDeclarator containerTypeDecl, 
			JvmTypeParameterDeclarator containerOperation, Map<JvmTypeParameter, JvmTypeParameter> visited
	) {
		val reboundTypeRef = typeRef.cloneWithProxies
		
		if (reboundTypeRef instanceof JvmParameterizedTypeReference) {
			var type = reboundTypeRef.type
			
			if (type.eIsProxy) {
				// use the original type reference to resolve the type
				// since the cloned one might not be contained in any resource
				type = typeRef.type
			}
			
			if (type instanceof JvmTypeParameter) {
				var typePar = visited.get(type)
				
				if (typePar === null) {
					// the type parameter of a method might shadow the one in the
					// declaring type, so we must inspect the former first
					if (containerOperation !== null) {
						typePar = findCorrespondingTypeParameter(containerOperation, typeRef)
					}

					// the typePar can now be null if it refers to the containing type's type parameter
					if (typePar === null) {
						typePar = findCorrespondingTypeParameter(containerTypeDecl, typeRef)
					}					
					
					if (typePar !== null) {
						visited.put(type, typePar)

						rebindConstraintsTypeParameters(typePar, containerTypeDecl, containerOperation, visited)

						reboundTypeRef.type = typePar
					}
				} else {
					reboundTypeRef.type = typePar
				}
			}
			
			// rebind type arguments as well
			val reboundArgs = reboundTypeRef.arguments
			val originalArgs = (typeRef as JvmParameterizedTypeReference).arguments
			for (i : 0..<reboundArgs.size()) {
				reboundArgs.set(i, originalArgs.get(i).rebindTypeParameters(containerTypeDecl, containerOperation, visited))
			}
			
			return reboundTypeRef
		}

		// IMPORTANT: always start from the original type reference
		// its internal type references might have to be resolved
		// and resolution works only if they're contained in a resource
		// which is not the case for the cloned type reference reboundTypeRef

		if (reboundTypeRef instanceof JvmWildcardTypeReference) {
			reboundTypeRef.rebindConstraintsTypeParameters(typeRef as JvmWildcardTypeReference,
				containerTypeDecl, containerOperation, visited
			)
			return reboundTypeRef
		}
		
		if (reboundTypeRef instanceof XFunctionTypeRef) {
			val origTypeRef = typeRef as XFunctionTypeRef
			val reboundReturnTypeRef = origTypeRef.returnType.rebindTypeParameters(containerTypeDecl, containerOperation, visited)
			reboundTypeRef.returnType = reboundReturnTypeRef
			
			val paramTypes = reboundTypeRef.paramTypes
			val origParamTypes = origTypeRef.paramTypes
			for (i : 0..<paramTypes.size) {
				paramTypes.set(i, origParamTypes.get(i).rebindTypeParameters(containerTypeDecl, containerOperation, visited))
			}
			
			return reboundTypeRef
		}
		
		return typeRef
	}
	
	def findCorrespondingTypeParameter(JvmTypeParameterDeclarator declarator, JvmTypeReference reboundTypeRef) {
		if (declarator === null)
			return null
		declarator.typeParameters.findFirst[name == reboundTypeRef.type.simpleName]
	}
	
	def rebindConstraintsTypeParameters(JvmConstraintOwner constraintOwner, JvmTypeParameterDeclarator containerDecl, JvmTypeParameterDeclarator containerOperation, Map<JvmTypeParameter, JvmTypeParameter> visited) {
		rebindConstraintsTypeParameters(constraintOwner, constraintOwner, containerDecl, containerOperation, visited)
	}
	
	def rebindConstraintsTypeParameters(JvmConstraintOwner newConstraintOwner, JvmConstraintOwner originalConstraintOwner, JvmTypeParameterDeclarator containerDecl, JvmTypeParameterDeclarator containerOperation, Map<JvmTypeParameter, JvmTypeParameter> visited) {
		val constraints = newConstraintOwner.constraints
		val originalConstraints = originalConstraintOwner.constraints
		
		var i = 0
		for (constraint : constraints) {
			
			/*
			 * Due to the way cloneWithProxies is implemented by JvmTypesBuilder
			 * (see
			 * org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder.cloneAndAssociate(T)
			 * org.eclipse.xtext.xbase.jvmmodel.new Copier() {...}.copy(EObject)
			 * )
			 * a wildcard type reference without an upper bound is cloned
			 * by adding java.lang.Object as upper bound.
			 * 
			 * This means that the original wildcard reference with only a lower bound
			 * will not have the corresponding upper bound; in such case we simply
			 * skip the upper bound.
			 * 
			 * Moreover, in our copyTypeParameters
			 * xtraitj.jvmmodel.XtraitjJvmModelInferrer.copyTypeParameters(JvmTypeParameterDeclarator, List<JvmTypeParameter>)
			 * we manually insert an upper bound if it's not explicitly specified,
			 * so the original type parameter might have no constraints at all
			 */
			
			if (constraint instanceof JvmUpperBound) {
				if (!originalConstraints.empty && originalConstraints.get(i) instanceof JvmUpperBound) {
					constraint.typeReference = 
						originalConstraints.get(i).
							typeReference.
								rebindTypeParameters(containerDecl, containerOperation, visited)
					i = i + 1
				}
			} else {
				constraint.typeReference = 
					originalConstraints.get(i).
						typeReference.
							rebindTypeParameters(containerDecl, containerOperation, visited)
				i = i + 1
			}
		}
	}

}
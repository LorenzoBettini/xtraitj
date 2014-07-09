/**
 * 
 */
package xtraitj.types;

import com.google.inject.Inject
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.common.types.JvmAnnotationReference
import org.eclipse.xtext.common.types.JvmFormalParameter
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.common.types.JvmVisibility
import org.eclipse.xtext.common.types.impl.JvmOperationImpl
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import xtraitj.jvmmodel.XtraitjJvmModelHelper
import xtraitj.util.XtraitjModelUtil
import xtraitj.xtraitj.TJTraitOperation
import xtraitj.xtraitj.impl.TJTraitOperationImpl

/**
 * @author Lorenzo Bettini
 *
 */
public abstract class XtraitjTraitOperationWrapper extends JvmOperationImpl {

	var TJTraitOperation operation
	
	var JvmParameterizedTypeReference typeReference;
	
	@Inject XtraitjJvmModelHelper jvmModelHelper;
	
	@Inject extension JvmTypesBuilder
	
	@Inject extension XtraitjTypeParameterHelper
	
	var IResolvedOperation resolvedOperation = null;
	
	var EList<JvmAnnotationReference> annotations = null;

	def void init(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		this.operation = operation;
		this.typeReference = typeReference;
	}

	def TJTraitOperationImpl getOperation() {
		return operation as TJTraitOperationImpl;
	}

	def isReferredMemberProxy() {
		getOperation().basicGetMember().eIsProxy()
	}
	
	def IResolvedOperation getResolvedOperation() {
		if (resolvedOperation == null) {
			val jvmOperation = getJvmOperation()
			if (jvmOperation != null)
				resolvedOperation = jvmModelHelper.getResolvedOperation(typeReference, operation, jvmOperation);
		}
		
		return resolvedOperation;
	}

	def JvmOperation getJvmOperation() {
		return operation.getMember() as JvmOperation;
	}

	override JvmTypeReference getReturnType() {
		if (returnType == null) {
			val resolvedOperation = getResolvedOperation
			if (resolvedOperation != null)
				returnType = resolvedOperation.getResolvedReturnType.toTypeReference.
					rebindOperationTypeParameters
		}
		
		return returnType;
	}

	override EList<JvmTypeParameter> getTypeParameters() {
		if (typeParameters == null) {
			typeParameters = super.getTypeParameters
			val resolvedOperation = getResolvedOperation
			if (resolvedOperation != null)
				typeParameters.addAll(resolvedOperation.resolvedTypeParameters.map[cloneWithProxies])
		}
		return typeParameters
	}

	override EList<JvmFormalParameter> getParameters() {
		// replace original parameter types with the resolved ones
		if (parameters == null) {
			parameters = superGetParameters()
			
			val op = getJvmOperation
			if (op !== null) {
				val iterator = getResolvedOperation.resolvedParameterTypes.iterator
			
				for (p : op.parameters) {
					parameters += p.toParameter(p.name, 
						iterator.next.toTypeReference.rebindOperationTypeParameters
					)
				}
			}
		}
		
		return parameters;
	}
	
	protected def superGetParameters() {
		super.getParameters
	}

	override JvmVisibility getVisibility() {
		val jvmOperation = getJvmOperation()
		if (jvmOperation == null)
			return JvmVisibility.DEFAULT
		return getJvmOperation().getVisibility();
	}

	override getAnnotations() {
		if (annotations == null) {
			val jvmOperation = getJvmOperation()
			annotations = new BasicEList()
			if (jvmOperation != null)
				annotations += jvmOperation.annotations
			processOperationSpecificAnnotations
		}
		return annotations
	}
	
	def abstract void processOperationSpecificAnnotations();
	
	override String getSimpleName() {
		return XtraitjModelUtil.getOperationMemberName(operation)
	}

	override String getQualifiedName(char innerClassDelimiter) {
		val simpleName = getSimpleName();
		if (simpleName == null)
			return null;
		val declaringType = getDeclaringType();
		if (declaringType == null)
			return simpleName;
		return declaringType.getQualifiedName(innerClassDelimiter) + '.' + simpleName;
	}

	/**
	 * Rebinds references to a type parameter of the original operation to the
	 * type parameter of this wrapper operation.
	 */
	def rebindOperationTypeParameters(JvmTypeReference typeRef) {
		typeRef.rebindTypeParameters(null, this)
	}
}

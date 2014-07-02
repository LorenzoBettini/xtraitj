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
import xtraitj.xtraitj.TJTraitOperation
import xtraitj.util.XtraitjModelUtil
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
	
	var IResolvedOperation resolvedOperation = null;
	
	protected var EList<JvmFormalParameter> parameters = null;
	
	protected var EList<JvmTypeParameter> typeParameters = null;
	
	var EList<JvmAnnotationReference> annotations = null;

	def void init(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		this.operation = operation;
		this.typeReference = typeReference;
	}

	def TJTraitOperationImpl getOperation() {
		return operation as TJTraitOperationImpl;
	}
	
	def IResolvedOperation getResolvedOperation() {
		if (resolvedOperation == null) {
			resolvedOperation = jvmModelHelper.getResolvedOperation(typeReference, operation, getJvmOperation());
		}
		
		return resolvedOperation;
	}

	def JvmOperation getJvmOperation() {
		return operation.getMember() as JvmOperation;
	}

	override JvmTypeReference getReturnType() {
		return getResolvedOperation().getResolvedReturnType().toTypeReference();
	}

	override EList<JvmTypeParameter> getTypeParameters() {
		if (typeParameters == null) {
			typeParameters = new BasicEList(
				getResolvedOperation.resolvedTypeParameters
			)
		}
		return typeParameters
	}

	override EList<JvmFormalParameter> getParameters() {
		// replace original parameter types with the resolved ones
		if (parameters == null) {
			parameters = new BasicEList(getJvmOperation.parameters.map[cloneWithProxies])
			val iterator = getResolvedOperation.resolvedParameterTypes.iterator
			for (parameter : parameters) {
				parameter.parameterType = iterator.next.toTypeReference.cloneWithProxies
			}
		}
		
		return parameters;
	}

	override JvmVisibility getVisibility() {
		return getJvmOperation().getVisibility();
	}

	override getAnnotations() {
		if (annotations == null) {
			annotations = new BasicEList(getJvmOperation().annotations)
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
}

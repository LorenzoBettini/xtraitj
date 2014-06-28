/**
 * 
 */
package xtraitj.types;

import com.google.inject.Inject
import org.eclipse.xtext.common.types.impl.JvmOperationImpl
import org.eclipse.xtext.xbase.typesystem.^override.IResolvedOperation
import xtraitj.jvmmodel.XtraitjJvmModelHelper
import xtraitj.xtraitj.TJTraitOperation
import org.eclipse.xtext.common.types.JvmParameterizedTypeReference
import org.eclipse.xtext.common.types.JvmOperation
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.emf.common.util.EList
import org.eclipse.xtext.common.types.JvmTypeParameter
import org.eclipse.xtext.common.types.JvmFormalParameter
import org.eclipse.xtext.common.types.JvmVisibility
import xtraitj.xtraitj.TJRenameOperation
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.eclipse.xtext.common.types.JvmAnnotationReference
import xtraitj.generator.XtraitjGeneratorExtensions

/**
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitOperationWrapper extends JvmOperationImpl {

	var TJTraitOperation operation
	
	var JvmParameterizedTypeReference typeReference;
	
	@Inject XtraitjJvmModelHelper jvmModelHelper;
	
	@Inject extension JvmTypesBuilder
	
	@Inject extension XtraitjGeneratorExtensions
	
	var IResolvedOperation resolvedOperation = null;
	
	var EList<JvmFormalParameter> parameters = null;
	
	var EList<JvmAnnotationReference> annotations = null;

	def void init(TJTraitOperation operation,
			JvmParameterizedTypeReference typeReference) {
		this.operation = operation;
		this.typeReference = typeReference;
	}

	def TJTraitOperation getOperation() {
		return operation;
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
		return getJvmOperation().getTypeParameters();
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
			if (operation instanceof TJRenameOperation) {
				getOperation.annotateAsRenamedMethod(this, getJvmOperation().simpleName)
			}
		}
		return annotations
	}

	override String getSimpleName() {
		if (operation instanceof TJRenameOperation) {
			return operation.getNewname();
		}
		return super.getSimpleName();
	}

	override String computeIdentifier() {
		if (operation instanceof TJRenameOperation) {
			return operation.getNewname();
		}
		return super.computeIdentifier();
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

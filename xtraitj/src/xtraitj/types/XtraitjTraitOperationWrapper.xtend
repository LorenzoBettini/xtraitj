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

/**
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitOperationWrapper extends JvmOperationImpl {

	var TJTraitOperation operation
	
	var JvmParameterizedTypeReference typeReference;
	
	@Inject XtraitjJvmModelHelper jvmModelHelper;
	
	var IResolvedOperation resolvedOperation = null;

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
		return getJvmOperation().getParameters();
	}

	override JvmVisibility getVisibility() {
		return getJvmOperation().getVisibility();
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

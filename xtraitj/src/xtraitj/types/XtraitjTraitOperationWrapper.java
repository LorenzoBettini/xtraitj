/**
 * 
 */
package xtraitj.types;

import org.eclipse.emf.common.util.EList;
import org.eclipse.xtext.common.types.JvmDeclaredType;
import org.eclipse.xtext.common.types.JvmFormalParameter;
import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmTypeParameter;
import org.eclipse.xtext.common.types.JvmTypeReference;
import org.eclipse.xtext.common.types.JvmVisibility;
import org.eclipse.xtext.common.types.impl.JvmOperationImpl;

import xtraitj.xtraitj.TJRenameOperation;
import xtraitj.xtraitj.TJTraitOperation;

/**
 * @author Lorenzo Bettini
 *
 */
public class XtraitjTraitOperationWrapper extends JvmOperationImpl {

	private TJTraitOperation operation;

	public XtraitjTraitOperationWrapper(TJTraitOperation operation) {
		super();
		this.operation = operation;
	}

	protected JvmOperation getJvmOperation() {
		return (JvmOperation) operation.getMember();
	}

	@Override
	public JvmTypeReference getReturnType() {
		return getJvmOperation().getReturnType();
	}

	@Override
	public EList<JvmTypeParameter> getTypeParameters() {
		return getJvmOperation().getTypeParameters();
	}

	@Override
	public EList<JvmFormalParameter> getParameters() {
		return getJvmOperation().getParameters();
	}

	@Override
	public JvmVisibility getVisibility() {
		return getJvmOperation().getVisibility();
	}

	@Override
	public String getSimpleName() {
		if (operation instanceof TJRenameOperation) {
			return ((TJRenameOperation) operation).getNewname();
		}
		return super.getSimpleName();
	}

	@Override
	protected String computeIdentifier() {
		if (operation instanceof TJRenameOperation) {
			return ((TJRenameOperation) operation).getNewname();
		}
		return super.computeIdentifier();
	}
	
	@Override
	public String getQualifiedName(char innerClassDelimiter) {
		String simpleName = getSimpleName();
		if (simpleName == null)
			return null;
		JvmDeclaredType declaringType = getDeclaringType();
		if (declaringType == null)
			return simpleName;
		return declaringType.getQualifiedName(innerClassDelimiter) + '.' + simpleName;
	}
}

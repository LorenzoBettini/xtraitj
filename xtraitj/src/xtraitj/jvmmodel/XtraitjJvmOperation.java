/**
 * 
 */
package xtraitj.jvmmodel;

import java.util.List;

import org.eclipse.xtext.common.types.JvmOperation;
import org.eclipse.xtext.common.types.JvmTypeReference;

/**
 * Stores information about instantiated type parametersType
 * 
 * @author Lorenzo Bettini
 * 
 */
public class XtraitjJvmOperation {

	private JvmOperation op;

	private JvmTypeReference returnType;

	private List<JvmTypeReference> parametersType;

	public XtraitjJvmOperation(JvmOperation op, JvmTypeReference returnType,
			List<JvmTypeReference> parameters) {
		super();
		this.op = op;
		this.returnType = returnType;
		this.parametersType = parameters;
	}

	public JvmOperation getOp() {
		return op;
	}

	public JvmTypeReference getReturnType() {
		return returnType;
	}

	public List<JvmTypeReference> getParametersType() {
		return parametersType;
	}

}

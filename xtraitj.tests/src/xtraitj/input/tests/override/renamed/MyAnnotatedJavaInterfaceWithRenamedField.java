package xtraitj.input.tests.override.renamed;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
public interface MyAnnotatedJavaInterfaceWithRenamedField extends
		MyAnnotatedJavaInterfaceWithDefined {

	@Override
	@XtraitjDefinedMethod
	String getRequired();

	@XtraitjRenamedMethod("getField")
	@XtraitjRequiredField
	String getRenamedField();

}

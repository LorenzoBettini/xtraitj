package xtraitj.input.tests.override.renamed;

import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
public interface MyAnnotatedJavaInterfaceWithRequirements {

	@XtraitjRequiredField
	String getField();

	@XtraitjRequiredMethod
	String getRequired();

}

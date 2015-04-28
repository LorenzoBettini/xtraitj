package xtraitj.input.tests.override.renamed;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
public interface MyAnnotatedJavaInterfaceWithDefined extends
		MyAnnotatedJavaInterfaceWithRequirements {

	@XtraitjDefinedMethod
	String getRequired();

	@XtraitjDefinedMethod
	String getDefined();

}

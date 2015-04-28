package xtraitj.input.tests.override.renamed;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
public interface MyAnnotatedJavaInterfaceWithRenamed extends
		MyAnnotatedJavaInterfaceWithDefined {

	@XtraitjDefinedMethod
	String getRequired();

	@XtraitjRenamedMethod("getDefined")
	String getRenamed();

}

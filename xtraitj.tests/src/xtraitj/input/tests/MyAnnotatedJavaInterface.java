package xtraitj.input.tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
public interface MyAnnotatedJavaInterface {

	@XtraitjRequiredField
	String getField();

	@XtraitjRequiredMethod
	String getRequired();

	@XtraitjDefinedMethod
	String getDefined();

	String notAnnotatedMethod();
}

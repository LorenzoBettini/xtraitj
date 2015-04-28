package xtraitj.input.tests;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
public class MyAnnotatedJavaClass {

	@XtraitjRequiredField
	String getField() {
		return "test";
	}

	@XtraitjRequiredMethod
	String getRequired() {
		return "test";
	}

	@XtraitjDefinedMethod
	String getDefined() {
		return "test";
	}

	String notAnnotatedMethod() {
		return "test";
	}
}

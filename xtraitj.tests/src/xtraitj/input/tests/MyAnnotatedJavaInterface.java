package xtraitj.input.tests;

import com.google.inject.Inject;
import com.google.inject.name.Named;

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
	
	@Inject
	String notXtraitjAnnotatedMethod();
	
	@Inject
	@XtraitjDefinedMethod
	@Named(value = "foo")
	String methodWithManyAnnotations();
}

package xtraitj.input.tests;

import java.util.List;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
public interface MyGenericAnnotatedJavaInterface<T> {

	@XtraitjRequiredField
	T getField();

	@XtraitjRequiredMethod
	T getRequired(List<T> l);

	@XtraitjDefinedMethod
	T getDefined(List<T> l);

	String notAnnotatedMethod();
}

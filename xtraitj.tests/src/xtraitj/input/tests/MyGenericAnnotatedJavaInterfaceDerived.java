package xtraitj.input.tests;

import java.util.List;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
public interface MyGenericAnnotatedJavaInterfaceDerived<T> extends
		MyGenericAnnotatedJavaInterface<T> {

	@XtraitjRequiredField
	T getField2();

	@XtraitjRequiredMethod
	T getRequired2(List<T> l);

	@XtraitjDefinedMethod
	T getDefined2(List<T> l);

	String notAnnotatedMethod();
}

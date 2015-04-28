package xtraitj.input.tests;

import java.util.List;

import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

/**
 * This overrides a method in the super interface annotated as defined method with
 * one annotated as required.
 * 
 * @author Lorenzo Bettini
 *
 * @param <T>
 */
@XtraitjTraitInterface
public interface MyGenericAnnotatedJavaInterfaceOverridesDefinedWithRequired<T> extends
		MyGenericAnnotatedJavaInterface<T> {

	@XtraitjRequiredMethod
	T getDefined(List<T> l);

	String notAnnotatedMethod();
}

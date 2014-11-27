package xtraitj.input.tests.override.required;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
public interface ProvidesMethod {

	@XtraitjDefinedMethod
	void m();
}

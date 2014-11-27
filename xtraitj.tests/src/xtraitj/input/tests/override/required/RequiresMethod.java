package xtraitj.input.tests.override.required;

import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
public interface RequiresMethod {

	@XtraitjRequiredMethod
	void m();
}

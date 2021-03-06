package xtraitj.input.tests;

import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
public class MyAnnotatedRenamedMethod {

	@XtraitjRenamedMethod("original")
	String newName() {
		return "test";
	}

	String notAnnotated() {
		return "test";
	}
}

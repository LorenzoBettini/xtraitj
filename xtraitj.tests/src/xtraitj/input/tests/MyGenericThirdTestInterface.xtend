package xtraitj.input.tests

import java.util.List

interface MyGenericThirdTestInterface<T3> extends MyGenericSecondTestInterface<T3> {
	def T3 m3(List<T3> l);
}
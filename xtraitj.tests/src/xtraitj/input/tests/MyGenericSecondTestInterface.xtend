package xtraitj.input.tests

import java.util.List

interface MyGenericSecondTestInterface<T2> extends MyGenericFirstTestInterface<T2> {
	def T2 m2(List<T2> l);
}
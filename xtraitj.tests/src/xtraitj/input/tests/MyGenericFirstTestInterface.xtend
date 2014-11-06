package xtraitj.input.tests

import java.util.List

interface MyGenericFirstTestInterface<T1> {
	def T1 m1(List<T1> l);
}
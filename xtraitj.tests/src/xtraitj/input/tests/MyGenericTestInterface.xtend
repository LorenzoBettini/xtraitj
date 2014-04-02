package xtraitj.input.tests

import java.util.List

interface MyGenericTestInterface<T> {
	def int m(List<T> l);
}
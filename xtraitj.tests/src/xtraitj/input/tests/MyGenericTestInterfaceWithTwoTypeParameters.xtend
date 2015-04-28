package xtraitj.input.tests

import java.util.List

interface MyGenericTestInterfaceWithTwoTypeParameters<T,V> {
	def T m1(List<V> l);
	def V m2(List<T> p1, T p2);
}
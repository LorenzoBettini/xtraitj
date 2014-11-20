These are Java classes generated from this input

package xtraitj.input.tests.generated;

trait T1Gen<T> {
	T required(T t);
	
	T provided(T t) {
		return required(t)
	} 
}

We use it to test that Xtraitj programs can also access annotated generated Java code without the original .xtraitj source.
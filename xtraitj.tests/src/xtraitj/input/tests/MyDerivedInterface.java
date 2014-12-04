package xtraitj.input.tests;

import java.util.List;

public interface MyDerivedInterface<U> extends MyBaseInterface<U> {
	List<U> m(int i);
}

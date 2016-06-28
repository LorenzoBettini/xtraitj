package xtraitj.example.examples.lifo;

import java.util.LinkedList;
import java.util.List;

public class ManualLifo<T> implements ILifo<T> {

	private List<T> collection = new LinkedList<T>();

	@Override
	public boolean isNotEmpty() {
		return !collection.isEmpty();
	}

	@Override
	public void push(T o) {
		collection.add(o);
	}

	@Override
	public void pop() {
		if (isNotEmpty())
			collection.remove(0);
	}

	@Override
	public T top() {
		if (isNotEmpty())
			return null;
		return collection.get(0);
	}

}

package xtraitj.example.examples.stack;

import java.util.LinkedList;
import java.util.List;

public class ManualStack<T> implements IStack<T> {

	private List<T> collection = new LinkedList<T>();

	@Override
	public boolean isEmpty() {
		return collection.isEmpty();
	}

	@Override
	public void push(T o) {
		collection.add(o);
	}

	@Override
	public T pop() {
		if (isEmpty())
			return null;
		return collection.remove(0);
	}

}

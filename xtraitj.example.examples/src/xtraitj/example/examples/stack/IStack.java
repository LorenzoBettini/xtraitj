package xtraitj.example.examples.stack;

public interface IStack<T> {
	boolean isEmpty();
	void push(T o);
	T pop();
}

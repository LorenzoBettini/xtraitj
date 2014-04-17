package xtraitj.example.examples.lifo;

public interface ILifo<T> {
	boolean isNotEmpty();
	void push(T o);
	void pop();
	T top();
}

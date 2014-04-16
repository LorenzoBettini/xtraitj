package xtraitj.example.examples.lifo;

public interface ILifo {
	boolean isNotEmpty();
	void push(Object o);
	void pop();
	Object top();
}

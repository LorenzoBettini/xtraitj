package xtraitj.example.examples.stack.tests;

import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

import xtraitj.example.examples.stack.IStack;

public abstract class AbstractStackTest<T> {
	
	IStack<T> stack;
	
	@Before
	public void setUp() {
		stack = createCStack();
	}
	
	protected abstract IStack<T> createCStack();

	@Test
	public void testEmptyStack() {
		assertTrue(stack.isEmpty());
		assertNull(stack.pop());
	}
	
}

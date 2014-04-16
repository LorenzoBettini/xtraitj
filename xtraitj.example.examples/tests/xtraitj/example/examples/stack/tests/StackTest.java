package xtraitj.example.examples.stack.tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

import xtraitj.example.examples.stack.CStack;
import xtraitj.example.examples.stack.IStack;

public class StackTest {
	
	IStack stack;
	
	@Before
	public void setUp() {
		stack = new CStack();
	}

	@Test
	public void testEmptyStack() {
		assertTrue(stack.isEmpty());
		assertNull(stack.pop());
	}
	
	@Test
	public void testPushAndPop() {
		stack.push("foo");
		stack.push(10);
		assertEquals(10, stack.pop());
		assertEquals("foo", stack.pop());
	}

}

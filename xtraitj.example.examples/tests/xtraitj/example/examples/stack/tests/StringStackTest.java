package xtraitj.example.examples.stack.tests;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import xtraitj.example.examples.stack.CStack;
import xtraitj.example.examples.stack.IStack;

public class StringStackTest extends AbstractStackTest<String> {
	
	@Override
	protected IStack<String> createCStack() {
		return new CStack<String>();
	}

	@Test
	public void testPushAndPop() {
		stack.push("foo");
		stack.push("10");
		assertEquals("10", stack.pop());
		assertEquals("foo", stack.pop());
	}


}

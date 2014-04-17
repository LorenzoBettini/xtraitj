package xtraitj.example.examples.stack.tests;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import xtraitj.example.examples.stack.CStack;
import xtraitj.example.examples.stack.IStack;

public class IntegerStackTest extends AbstractStackTest<Integer> {
	
	@Override
	protected IStack<Integer> createCStack() {
		return new CStack<Integer>();
	}

	@Test
	public void testPushAndPop() {
		stack.push(0);
		stack.push(10);
		assertEquals(new Integer(10), stack.pop());
		assertEquals(new Integer(0), stack.pop());
	}


}

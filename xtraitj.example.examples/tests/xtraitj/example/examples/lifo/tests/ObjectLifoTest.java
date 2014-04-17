package xtraitj.example.examples.lifo.tests;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import xtraitj.example.examples.lifo.CLifo;
import xtraitj.example.examples.lifo.ILifo;

public class ObjectLifoTest extends AbstractLifoTest<Object> {

	@Override
	protected ILifo<Object> createLifo() {
		return new CLifo<Object>();
	}
	
	@Test
	public void testPushAndPop() {
		lifo.push("foo");
		lifo.push(10);
		
		assertEquals(10, lifo.top());
		
		lifo.pop();
		
		assertEquals("foo", lifo.top());
	}
	
}

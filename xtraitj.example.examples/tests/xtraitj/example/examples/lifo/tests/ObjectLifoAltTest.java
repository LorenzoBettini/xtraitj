package xtraitj.example.examples.lifo.tests;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import xtraitj.example.examples.lifo.CLifoAlt;
import xtraitj.example.examples.lifo.ILifo;

public class ObjectLifoAltTest extends AbstractLifoTest<Object> {

	@Override
	protected ILifo<Object> createLifo() {
		return new CLifoAlt<Object>();
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

package xtraitj.example.examples.lifo.tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;

import org.junit.Before;
import org.junit.Test;

import xtraitj.example.examples.lifo.ILifo;

public abstract class AbstractLifoTest {
	
	ILifo lifo;
	
	protected abstract ILifo createLifo();
	
	@Before
	public void setUp() {
		lifo = createLifo();
	}

	@Test
	public void testEmptyLifo() {
		assertFalse(lifo.isNotEmpty());
		assertNull(lifo.top());
	}
	
	@Test
	public void testPopOnEmptyLifoDoesNotThrow() {
		lifo.pop();
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

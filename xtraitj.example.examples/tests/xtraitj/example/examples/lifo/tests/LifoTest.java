package xtraitj.example.examples.lifo.tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

import xtraitj.example.examples.lifo.CLifo;
import xtraitj.example.examples.lifo.ILifo;

public class LifoTest {
	
	ILifo lifo;
	
	@Before
	public void setUp() {
		lifo = new CLifo();
	}

	@Test
	public void testEmptyLifo() {
		assertTrue(lifo.isEmpty());
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

package xtraitj.example.examples.lifo.tests;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;

import org.junit.Before;
import org.junit.Test;

import xtraitj.example.examples.lifo.ILifo;

public abstract class AbstractLifoTest<T> {
	
	ILifo<T> lifo;
	
	protected abstract ILifo<T> createLifo();
	
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
	
}

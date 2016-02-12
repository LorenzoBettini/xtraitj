package xtraitj.performance.tests;

import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;

import xtraitj.example.examples.stack.IStack;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public abstract class AbstractXtraitjStackPerformanceTest {

	private IStack<String> stackOfString;

	@Before
	public void setup() {
		stackOfString = createStack();
	}

	protected abstract IStack<String> createStack();

	@Test
	public void aWarmpUp() {
		testPerformance(10);
	}

	@Test
	public void test10() {
		testPerformance(10);
	}

	@Test
	public void test100() {
		testPerformance(100);
	}

	@Test
	public void test1000() {
		testPerformance(1000);
	}

	@Test
	public void test10000() {
		testPerformance(10000);
	}

	@Test
	public void test100000() {
		testPerformance(100000);
	}

	protected void testPerformance(int numOfElements) {
		for (int i = 0; i < numOfElements; i++) {
			stackOfString.push("element " + i);
		}
		for (int i = 0; i < numOfElements; i++) {
			stackOfString.pop();
		}
		assertTrue(stackOfString.isEmpty());
	}
}

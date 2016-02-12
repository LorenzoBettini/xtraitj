package xtraitj.performance.tests;

import static org.junit.Assert.assertFalse;

import org.junit.Before;
import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;

import xtraitj.example.examples.lifo.ILifo;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public abstract class AbstractXtraitjLifoPerformanceTest {

	private ILifo<String> lifoOfString;

	@Before
	public void setup() {
		lifoOfString = createLifo();
	}

	protected abstract ILifo<String> createLifo();

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
			lifoOfString.push("element " + i);
		}
		for (int i = 0; i < numOfElements; i++) {
			lifoOfString.pop();
		}
		assertFalse(lifoOfString.isNotEmpty());
	}
}

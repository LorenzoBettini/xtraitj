package xtraitj.performance.tests;

import java.util.LinkedList;
import java.util.List;

import org.junit.FixMethodOrder;
import org.junit.Test;
import org.junit.runners.MethodSorters;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public abstract class AbstractXtraitjIterablePerformanceTest {

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

	@Test
	public void test1000000() {
		testPerformance(1000000);
	}

	protected abstract void testPerformance(int numOfElements);

	protected List<Integer> createCollection(int numOfElements) {
		List<Integer> result = new LinkedList<Integer>();
		for (int i = 0; i < numOfElements; ++i) {
			result.add(i);
		}
		return result;
	}
}

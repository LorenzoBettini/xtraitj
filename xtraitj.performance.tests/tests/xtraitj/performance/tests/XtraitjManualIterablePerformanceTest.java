package xtraitj.performance.tests;

import java.util.List;

import org.junit.Assert;

import com.google.common.base.Function;
import com.google.common.base.Joiner;
import com.google.common.collect.Iterables;

public class XtraitjManualIterablePerformanceTest extends AbstractXtraitjIterablePerformanceTest {

	@Override
	protected void testPerformance(int numOfElements) {
		List<Integer> list = createCollection(numOfElements); 
		Iterable<String> mapped = Iterables.transform(list, new Function<Integer, String>() {
			@Override
			public String apply(Integer p) {
				return ""+p;
			}
		});
		String joined = Joiner.on(", ").join(mapped);
		Assert.assertNotNull(joined);
	}

}

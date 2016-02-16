package xtraitj.performance.tests;

import java.util.List;

import org.eclipse.xtext.xbase.lib.Functions.Function1;
import org.junit.Assert;

import xtraitj.example.examples.extensions.IterableWithExtensions;

public class XtraitjTraitIterablePerformanceTest extends AbstractXtraitjIterablePerformanceTest {

	@Override
	protected void testPerformance(int numOfElements) {
		List<Integer> list = createCollection(numOfElements); 
		Iterable<String> mapped = new IterableWithExtensions<Integer>(list).map(new Function1<Integer, String>() {
			@Override
			public String apply(Integer p) {
				return ""+p;
			}
		});
		String joined = new IterableWithExtensions<String>(mapped).join(", ");
		Assert.assertNotNull(joined);
	}

}

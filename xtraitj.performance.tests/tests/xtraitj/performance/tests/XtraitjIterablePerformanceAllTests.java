package xtraitj.performance.tests;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({
	XtraitjTraitIterablePerformanceTest.class,
	XtraitjManualIterablePerformanceTest.class
})
public class XtraitjIterablePerformanceAllTests {

}

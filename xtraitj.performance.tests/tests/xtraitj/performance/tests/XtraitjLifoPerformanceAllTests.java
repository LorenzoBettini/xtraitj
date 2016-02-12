package xtraitj.performance.tests;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import org.junit.runners.Suite.SuiteClasses;

@RunWith(Suite.class)
@SuiteClasses({
	XtraitjManualLifoPerformanceTest.class,
	XtraitjTraitLifoPerformanceTest.class
})
public class XtraitjLifoPerformanceAllTests {

}

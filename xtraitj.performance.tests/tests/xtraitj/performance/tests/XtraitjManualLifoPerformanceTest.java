package xtraitj.performance.tests;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import xtraitj.example.examples.lifo.ILifo;
import xtraitj.example.examples.lifo.ManualLifo;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class XtraitjManualLifoPerformanceTest extends AbstractXtraitjLifoPerformanceTest {

	protected ILifo<String> createLifo() {
		return new ManualLifo<String>();
	}

}

package xtraitj.performance.tests;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import xtraitj.example.examples.lifo.CLifoAlt;
import xtraitj.example.examples.lifo.ILifo;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class XtraitjTraitLifoPerformanceTest extends AbstractXtraitjLifoPerformanceTest {

	protected ILifo<String> createLifo() {
		return new CLifoAlt<String>();
	}

}

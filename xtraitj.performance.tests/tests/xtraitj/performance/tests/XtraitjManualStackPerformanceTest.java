package xtraitj.performance.tests;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.ManualStack;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class XtraitjManualStackPerformanceTest extends AbstractXtraitjStackPerformanceTest {

	protected IStack<String> createStack() {
		return new ManualStack<String>();
	}

}

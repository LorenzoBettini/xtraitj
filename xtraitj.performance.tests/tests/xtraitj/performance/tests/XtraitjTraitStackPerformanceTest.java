package xtraitj.performance.tests;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

import xtraitj.example.examples.stack.CStack;
import xtraitj.example.examples.stack.IStack;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class XtraitjTraitStackPerformanceTest extends AbstractXtraitjStackPerformanceTest {

	protected IStack<String> createStack() {
		return new CStack<String>();
	}

}

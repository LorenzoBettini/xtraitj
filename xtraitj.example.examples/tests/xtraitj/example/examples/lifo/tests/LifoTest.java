package xtraitj.example.examples.lifo.tests;

import xtraitj.example.examples.lifo.CLifo;
import xtraitj.example.examples.lifo.ILifo;

public class LifoTest extends AbstractLifoTest {

	@Override
	protected ILifo createLifo() {
		return new CLifo();
	}
	
}

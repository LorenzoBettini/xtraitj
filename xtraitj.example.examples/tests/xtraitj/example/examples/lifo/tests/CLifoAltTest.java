package xtraitj.example.examples.lifo.tests;

import xtraitj.example.examples.lifo.CLifoAlt;
import xtraitj.example.examples.lifo.ILifo;

public class CLifoAltTest extends AbstractLifoTest {

	@Override
	protected ILifo createLifo() {
		return new CLifoAlt();
	}
	
}

package xtraitj.example.examples.stack.tests.traits;

import org.junit.Before;
import xtraitj.example.examples.stack.IStack;

@SuppressWarnings("all")
public interface TStackSetup2 {
  public abstract IStack<String> getFixture();
  
  public abstract void setFixture(final IStack<String> fixture);
  
  @Before
  public abstract void setup();
}

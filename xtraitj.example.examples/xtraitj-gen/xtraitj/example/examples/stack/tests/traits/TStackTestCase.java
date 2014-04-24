package xtraitj.example.examples.stack.tests.traits;

import org.junit.Test;
import xtraitj.example.examples.stack.IStack;

@SuppressWarnings("all")
public interface TStackTestCase {
  public abstract IStack<String> getFixture();
  
  public abstract void setFixture(final IStack<String> fixture);
  
  @Test
  public abstract void testNotEmpty();
  
  @Test
  public abstract void testContents();
}

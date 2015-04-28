package xtraitj.example.examples.stack.tests.traits;

import org.junit.Test;
import xtraitj.example.examples.stack.IStack;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TStackTestCase {
  @XtraitjRequiredField
  public abstract IStack<String> getFixture();
  
  @XtraitjRequiredFieldSetter
  public abstract void setFixture(final IStack<String> fixture);
  
  @Test
  @XtraitjDefinedMethod
  public abstract void testNotEmpty();
  
  @Test
  @XtraitjDefinedMethod
  public abstract void testContents();
}

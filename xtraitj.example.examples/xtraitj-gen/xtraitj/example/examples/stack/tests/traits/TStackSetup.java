package xtraitj.example.examples.stack.tests.traits;

import org.junit.Before;
import xtraitj.example.examples.stack.IStack;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TStackSetup {
  @XtraitjRequiredField
  public abstract IStack<String> getFixture();
  
  @XtraitjRequiredFieldSetter
  public abstract void setFixture(final IStack<String> fixture);
  
  @Before
  @XtraitjDefinedMethod
  public abstract void setup();
}

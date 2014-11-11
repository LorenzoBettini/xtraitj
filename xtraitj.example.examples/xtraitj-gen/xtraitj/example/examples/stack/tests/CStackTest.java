package xtraitj.example.examples.stack.tests;

import org.junit.Before;
import org.junit.Test;
import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.tests.traits.TStackSetup;
import xtraitj.example.examples.stack.tests.traits.TStackSetupImpl;
import xtraitj.example.examples.stack.tests.traits.TStackTestCase;
import xtraitj.example.examples.stack.tests.traits.TStackTestCaseImpl;

@SuppressWarnings("all")
public class CStackTest implements TStackTestCase, TStackSetup {
  private IStack<String> fixture;
  
  public IStack<String> getFixture() {
    return this.fixture;
  }
  
  public void setFixture(final IStack<String> fixture) {
    this.fixture = fixture;
  }
  
  private TStackTestCaseImpl _TStackTestCase = new TStackTestCaseImpl(this);
  
  @Test
  public void testNotEmpty() {
    _TStackTestCase._testNotEmpty();
  }
  
  @Test
  public void testContents() {
    _TStackTestCase._testContents();
  }
  
  private TStackSetupImpl _TStackSetup = new TStackSetupImpl(this);
  
  @Before
  public void setup() {
    _TStackSetup._setup();
  }
}

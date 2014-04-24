package xtraitj.example.examples.stack.tests;

import org.junit.Before;
import org.junit.Test;
import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.tests.traits.TStackSetup2;
import xtraitj.example.examples.stack.tests.traits.TStackTestCase;
import xtraitj.example.examples.stack.tests.traits.impl.TStackSetup2Impl;
import xtraitj.example.examples.stack.tests.traits.impl.TStackTestCaseImpl;

@SuppressWarnings("all")
public class CStackTest2 implements TStackTestCase, TStackSetup2 {
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
  
  private TStackSetup2Impl _TStackSetup2 = new TStackSetup2Impl(this);
  
  @Before
  public void setup() {
    _TStackSetup2._setup();
  }
}

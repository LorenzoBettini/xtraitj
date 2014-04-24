package xtraitj.example.examples.stack.tests.traits.impl;

import org.junit.Before;
import xtraitj.example.examples.stack.CStack;
import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.tests.traits.TStackSetup2;

@SuppressWarnings("all")
public class TStackSetup2Impl implements TStackSetup2 {
  private TStackSetup2 _delegate;
  
  public TStackSetup2Impl(final TStackSetup2 delegate) {
    this._delegate = delegate;
  }
  
  public IStack<String> getFixture() {
    return _delegate.getFixture();
  }
  
  public void setFixture(final IStack<String> fixture) {
    _delegate.setFixture(fixture);
  }
  
  @Before
  public void setup() {
    _delegate.setup();
  }
  
  public void _setup() {
    CStack<String> _cStack = new CStack<String>();
    this.setFixture(_cStack);
    IStack<String> _fixture = this.getFixture();
    _fixture.push("bar");
    IStack<String> _fixture_1 = this.getFixture();
    _fixture_1.push("foo");
  }
}

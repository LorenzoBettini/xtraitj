package xtraitj.example.examples.stack.tests.traits.impl;

import java.util.ArrayList;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.junit.Before;
import xtraitj.example.examples.stack.CStack;
import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.tests.traits.TStackSetup;

@SuppressWarnings("all")
public class TStackSetupImpl implements TStackSetup {
  private TStackSetup _delegate;
  
  public TStackSetupImpl(final TStackSetup delegate) {
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
    ArrayList<String> _newArrayList = CollectionLiterals.<String>newArrayList("foo", "bar");
    CStack<String> _cStack = new CStack<String>(_newArrayList);
    this.setFixture(_cStack);
  }
}

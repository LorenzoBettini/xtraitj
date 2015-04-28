package xtraitj.example.examples.stack.tests.traits;

import org.junit.Assert;
import org.junit.Test;
import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.tests.traits.TStackTestCase;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TStackTestCaseImpl implements TStackTestCase {
  private TStackTestCase _delegate;
  
  public TStackTestCaseImpl(final TStackTestCase delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public IStack<String> getFixture() {
    return _delegate.getFixture();
  }
  
  public void setFixture(final IStack<String> fixture) {
    _delegate.setFixture(fixture);
  }
  
  @XtraitjDefinedMethod
  @Test
  public void testNotEmpty() {
    _delegate.testNotEmpty();
  }
  
  public void _testNotEmpty() {
    IStack<String> _fixture = this.getFixture();
    boolean _isEmpty = _fixture.isEmpty();
    Assert.assertFalse(_isEmpty);
  }
  
  @XtraitjDefinedMethod
  @Test
  public void testContents() {
    _delegate.testContents();
  }
  
  public void _testContents() {
    IStack<String> _fixture = this.getFixture();
    String _pop = _fixture.pop();
    Assert.assertEquals("foo", _pop);
    IStack<String> _fixture_1 = this.getFixture();
    String _pop_1 = _fixture_1.pop();
    Assert.assertEquals("bar", _pop_1);
    IStack<String> _fixture_2 = this.getFixture();
    String _pop_2 = _fixture_2.pop();
    Assert.assertNull(_pop_2);
  }
}

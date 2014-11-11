package xtraitj.example.examples.stack;

import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.TStackUtilities;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TStackUtilitiesImpl implements TStackUtilities {
  private TStackUtilities _delegate;
  
  public TStackUtilitiesImpl(final TStackUtilities delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjDefinedMethod
  public <U extends Object> String toString(final IStack<U> stack) {
    return _delegate.toString(stack);
  }
  
  public <U extends Object> String _toString(final IStack<U> stack) {
    final StringBuffer buffer = new StringBuffer();
    while ((!stack.isEmpty())) {
      {
        Object _pop = stack.pop();
        String _string = _pop.toString();
        buffer.append(_string);
        buffer.append("\n");
      }
    }
    return buffer.toString();
  }
}

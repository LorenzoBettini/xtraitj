package xtraitj.example.examples.stack.traits.impl;

import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.traits.TStackUtilities;

@SuppressWarnings("all")
public class TStackUtilitiesImpl implements TStackUtilities {
  private TStackUtilities _delegate;
  
  public TStackUtilitiesImpl(final TStackUtilities delegate) {
    this._delegate = delegate;
  }
  
  public <U> String toString(final IStack<U> stack) {
    return _delegate.toString(stack);
  }
  
  public <U> String _toString(final IStack<U> stack) {
    final StringBuffer buffer = new StringBuffer();
    boolean _isEmpty = stack.isEmpty();
    boolean _not = (!_isEmpty);
    boolean _while = _not;
    while (_while) {
      {
        U _pop = stack.pop();
        String _string = _pop.toString();
        buffer.append(_string);
        buffer.append("\n");
      }
      boolean _isEmpty_1 = stack.isEmpty();
      boolean _not_1 = (!_isEmpty_1);
      _while = _not_1;
    }
    return buffer.toString();
  }
}

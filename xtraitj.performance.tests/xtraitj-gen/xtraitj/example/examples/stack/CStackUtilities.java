package xtraitj.example.examples.stack;

import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.TStackUtilities;
import xtraitj.example.examples.stack.TStackUtilitiesImpl;

@SuppressWarnings("all")
public class CStackUtilities implements TStackUtilities {
  private TStackUtilitiesImpl _TStackUtilities = new TStackUtilitiesImpl(this);
  
  public <U extends Object> String toString(final IStack<U> stack) {
    return _TStackUtilities._toString(stack);
  }
}

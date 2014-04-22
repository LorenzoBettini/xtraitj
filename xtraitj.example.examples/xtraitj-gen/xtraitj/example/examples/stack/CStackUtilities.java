package xtraitj.example.examples.stack;

import xtraitj.example.examples.stack.IStack;
import xtraitj.example.examples.stack.traits.TStackUtilities;
import xtraitj.example.examples.stack.traits.impl.TStackUtilitiesImpl;

@SuppressWarnings("all")
public class CStackUtilities implements TStackUtilities {
  private TStackUtilitiesImpl _TStackUtilities = new TStackUtilitiesImpl(this);
  
  public <U> String toString(final IStack<U> stack) {
    return _TStackUtilities._toString(stack);
  }
}

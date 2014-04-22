package xtraitj.example.examples.stack.traits;

import xtraitj.example.examples.stack.IStack;

@SuppressWarnings("all")
public interface TStackUtilities {
  public abstract <U> String toString(final IStack<U> stack);
}

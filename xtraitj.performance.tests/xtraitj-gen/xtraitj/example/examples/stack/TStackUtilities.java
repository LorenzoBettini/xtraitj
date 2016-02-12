package xtraitj.example.examples.stack;

import xtraitj.example.examples.stack.IStack;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TStackUtilities {
  @XtraitjDefinedMethod
  public abstract <U extends Object> String toString(final IStack<U> stack);
}

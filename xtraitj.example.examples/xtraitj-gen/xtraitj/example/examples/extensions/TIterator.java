package xtraitj.example.examples.extensions;

import java.util.Iterator;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

/**
 * Acts as a wrapper for a Java Iterator
 */
@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TIterator<E extends Object> {
  @XtraitjRequiredField
  public abstract Iterator<E> getIterator();
  
  public abstract void setIterator(final Iterator<E> iterator);
  
  @XtraitjDefinedMethod
  public abstract boolean hasNext();
  
  @XtraitjDefinedMethod
  public abstract E next();
  
  @XtraitjDefinedMethod
  public abstract void remove();
}

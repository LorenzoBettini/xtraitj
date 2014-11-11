package xtraitj.example.examples.stack;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TStack<T extends Object> {
  @XtraitjRequiredField
  public abstract List<T> getCollection();
  
  public abstract void setCollection(final List<T> collection);
  
  @XtraitjDefinedMethod
  public abstract boolean isEmpty();
  
  @XtraitjDefinedMethod
  public abstract void push(final T o);
  
  @XtraitjDefinedMethod
  public abstract T pop();
}

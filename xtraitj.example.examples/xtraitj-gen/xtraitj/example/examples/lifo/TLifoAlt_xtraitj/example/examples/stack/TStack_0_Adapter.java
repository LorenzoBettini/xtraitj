package xtraitj.example.examples.lifo.TLifoAlt_xtraitj.example.examples.stack;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public interface TStack_0_Adapter<T extends Object> {
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("pop")
  public abstract T old_pop();
  
  @XtraitjRequiredField
  public abstract List<T> getCollection();
  
  public abstract void setCollection(final List<T> collection);
  
  @XtraitjDefinedMethod
  public abstract boolean isEmpty();
  
  @XtraitjDefinedMethod
  public abstract void push(final T o);
}

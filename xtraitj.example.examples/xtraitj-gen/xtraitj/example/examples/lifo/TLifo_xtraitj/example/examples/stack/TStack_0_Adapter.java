package xtraitj.example.examples.lifo.TLifo_xtraitj.example.examples.stack;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public interface TStack_0_Adapter<V extends Object> {
  @XtraitjRequiredField
  public abstract List<V> getCollection();
  
  public abstract void setCollection(final List<V> collection);
  
  @XtraitjDefinedMethod
  public abstract boolean isEmpty();
  
  @XtraitjDefinedMethod
  public abstract void push(final V o);
}

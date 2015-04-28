package xtraitj.example.examples.lifo;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface TLifo_TStack_0_Adapter<V extends Object> {
  @XtraitjRequiredField
  public abstract List<V> getCollection();
  
  @XtraitjRequiredFieldSetter
  public abstract void setCollection(final List<V> collection);
  
  @XtraitjDefinedMethod
  public abstract boolean isEmpty();
  
  @XtraitjDefinedMethod
  public abstract void push(final V o);
}

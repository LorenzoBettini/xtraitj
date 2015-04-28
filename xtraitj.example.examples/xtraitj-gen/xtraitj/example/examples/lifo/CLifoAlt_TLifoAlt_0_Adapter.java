package xtraitj.example.examples.lifo;

import java.util.List;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface CLifoAlt_TLifoAlt_0_Adapter<T extends Object> {
  @XtraitjRequiredField
  public abstract List<T> getCollection();
  
  @XtraitjRequiredFieldSetter
  public abstract void setCollection(final List<T> collection);
  
  @XtraitjDefinedMethod
  public abstract void pop();
  
  @XtraitjDefinedMethod
  public abstract T top();
  
  @XtraitjDefinedMethod
  public abstract boolean isEmpty();
  
  @XtraitjDefinedMethod
  public abstract void push(final T o);
}

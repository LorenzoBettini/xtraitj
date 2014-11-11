package xtraitj.example.examples.extensions;

import java.util.Iterator;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public interface TTransformerIterator_TIterator_0_Adapter<T extends Object, R extends Object> {
  @XtraitjRequiredField
  public abstract Iterator<T> getIterator();
  
  public abstract void setIterator(final Iterator<T> iterator);
  
  @XtraitjDefinedMethod
  public abstract boolean hasNext();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("next")
  public abstract T origNext();
  
  @XtraitjDefinedMethod
  public abstract void remove();
}

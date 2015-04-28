package xtraitj.example.examples.extensions;

import java.util.Iterator;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface TTransformerIterator_TIterator_0_Adapter<T extends Object, R extends Object> {
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("next")
  public abstract T origNext();
  
  @XtraitjRequiredField
  public abstract Iterator<T> getIterator();
  
  @XtraitjRequiredFieldSetter
  public abstract void setIterator(final Iterator<T> iterator);
  
  @XtraitjDefinedMethod
  public abstract boolean hasNext();
  
  @XtraitjDefinedMethod
  public abstract void remove();
}

package xtraitj.example.examples.extensions;

import java.util.Iterator;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;

@SuppressWarnings("all")
public interface StringIterableWithExtensions_TIterable_0_Adapter {
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getDelegate")
  public abstract Iterable<String> getIterable();
  
  @XtraitjRequiredFieldSetter
  public abstract void setIterable(final Iterable<String> iterable);
  
  @XtraitjDefinedMethod
  public abstract Iterator<String> iterator();
}

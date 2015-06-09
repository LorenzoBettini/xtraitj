package xtraitj.example.examples.extensions;

import java.util.Iterator;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredFieldSetter;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TIterable<T extends Object> {
  @XtraitjRequiredField
  public abstract Iterable<T> getDelegate();
  
  @XtraitjRequiredFieldSetter
  public abstract void setDelegate(final Iterable<T> delegate);
  
  @XtraitjDefinedMethod
  public abstract Iterator<T> iterator();
}

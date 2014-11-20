package xtraitj.input.tests.generated;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface T1Gen<T extends Object> {
  @XtraitjDefinedMethod
  public abstract T provided(final T t);
  
  @XtraitjRequiredMethod
  public abstract T required(final T t);
}

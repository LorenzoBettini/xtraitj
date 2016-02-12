package xtraitj.example.examples.lifo;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TNegateIsEmpty {
  @XtraitjDefinedMethod
  public abstract boolean isNotEmpty();
  
  @XtraitjRequiredMethod
  public abstract boolean isEmpty();
}

package xtraitj.example.examples.lifo.CLifoAlt_xtrait.example.examples.util;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface TNegate_1_Adapter<T extends Object> {
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("op")
  public abstract boolean isEmpty();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("notOp")
  public abstract boolean isNotEmpty();
}

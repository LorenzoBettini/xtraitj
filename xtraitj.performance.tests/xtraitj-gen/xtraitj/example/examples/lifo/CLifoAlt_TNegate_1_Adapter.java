package xtraitj.example.examples.lifo;

import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public interface CLifoAlt_TNegate_1_Adapter<T extends Object> {
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("op")
  public abstract boolean isEmpty();
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("notOp")
  public abstract boolean isNotEmpty();
}

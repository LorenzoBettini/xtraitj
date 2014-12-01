package xtraitj.example.examples.lifo;

import xtraitj.example.examples.lifo.TLifoAlt_TStack_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TLifoAlt<T extends Object> extends TLifoAlt_TStack_0_Adapter<T> {
  @XtraitjDefinedMethod
  public abstract void pop();
  
  @XtraitjDefinedMethod
  public abstract T top();
}

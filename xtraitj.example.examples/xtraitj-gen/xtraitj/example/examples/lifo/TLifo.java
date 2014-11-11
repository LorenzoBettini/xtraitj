package xtraitj.example.examples.lifo;

import xtraitj.example.examples.lifo.TLifo_xtraitj.example.examples.stack.TStack_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitInterface;

@XtraitjTraitInterface
@SuppressWarnings("all")
public interface TLifo<V extends Object> extends TStack_0_Adapter<V> {
  @XtraitjDefinedMethod
  public abstract void pop();
  
  @XtraitjDefinedMethod
  public abstract V top();
}

package xtraitj.examples.example.lifo.traits;

import xtraitj.examples.example.lifo.traits.TLifo_TStack_0_Adapter;

@SuppressWarnings("all")
public interface TLifo extends TLifo_TStack_0_Adapter {
  public abstract void pop();
  
  public abstract Object top();
  
  public abstract boolean isEmpty();
  
  public abstract void push(final Object o);
}

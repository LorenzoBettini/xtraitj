package xtraitj.example.examples.lifo.traits;

import xtraitj.example.examples.lifo.traits.TLifoAlt_TStack_0_Adapter;

@SuppressWarnings("all")
public interface TLifoAlt extends TLifoAlt_TStack_0_Adapter {
  public abstract void pop();
  
  public abstract Object top();
  
  public abstract boolean isEmpty();
  
  public abstract void push(final Object o);
  
  public abstract Object old_pop();
}

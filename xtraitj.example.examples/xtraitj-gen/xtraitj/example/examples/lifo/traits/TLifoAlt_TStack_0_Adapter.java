package xtraitj.example.examples.lifo.traits;

import java.util.List;

@SuppressWarnings("all")
public interface TLifoAlt_TStack_0_Adapter {
  public abstract List<Object> getCollection();
  
  public abstract void setCollection(final List<Object> collection);
  
  public abstract boolean isEmpty();
  
  public abstract void push(final Object o);
  
  public abstract Object old_pop();
}

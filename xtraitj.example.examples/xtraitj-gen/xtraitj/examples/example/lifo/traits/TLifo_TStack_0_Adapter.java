package xtraitj.examples.example.lifo.traits;

import java.util.List;

@SuppressWarnings("all")
public interface TLifo_TStack_0_Adapter {
  public abstract List<Object> getCollection();
  
  public abstract void setCollection(final List<Object> collection);
  
  public abstract boolean isEmpty();
  
  public abstract void push(final Object o);
}

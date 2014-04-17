package xtraitj.example.examples.lifo.traits;

import java.util.List;

@SuppressWarnings("all")
public interface TLifo_TStack_0_Adapter<V> {
  public abstract List<V> getCollection();
  
  public abstract void setCollection(final List<V> collection);
  
  public abstract boolean isEmpty();
  
  public abstract void push(final V o);
}

package xtraitj.example.examples.lifo.traits;

import java.util.List;
import xtraitj.example.examples.lifo.traits.TLifo_TStack_0_Adapter;

@SuppressWarnings("all")
public interface TLifo<V> extends TLifo_TStack_0_Adapter<V> {
  public abstract void pop();
  
  public abstract V top();
  
  public abstract boolean isEmpty();
  
  public abstract void push(final V o);
  
  public abstract List<V> getCollection();
  
  public abstract void setCollection(final List<V> collection);
}

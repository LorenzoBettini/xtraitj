package xtraitj.example.examples.lifo.traits;

import java.util.List;
import xtraitj.example.examples.lifo.traits.TLifoAlt_TStack_0_Adapter;

@SuppressWarnings("all")
public interface TLifoAlt<T> extends TLifoAlt_TStack_0_Adapter<T> {
  public abstract void pop();
  
  public abstract T top();
  
  public abstract boolean isEmpty();
  
  public abstract void push(final T o);
  
  public abstract T old_pop();
  
  public abstract List<T> getCollection();
  
  public abstract void setCollection(final List<T> collection);
}

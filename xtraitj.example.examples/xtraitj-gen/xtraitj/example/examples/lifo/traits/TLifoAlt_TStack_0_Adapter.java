package xtraitj.example.examples.lifo.traits;

import java.util.List;

@SuppressWarnings("all")
public interface TLifoAlt_TStack_0_Adapter<T> {
  public abstract List<T> getCollection();
  
  public abstract void setCollection(final List<T> collection);
  
  public abstract boolean isEmpty();
  
  public abstract void push(final T o);
  
  public abstract T old_pop();
}

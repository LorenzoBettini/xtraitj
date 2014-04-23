package xtraitj.example.examples.lifo.traits;

import java.util.List;

@SuppressWarnings("all")
public interface CLifoAlt_TLifoAlt_0_Adapter<T> {
  public abstract void pop();
  
  public abstract T top();
  
  public abstract boolean isEmpty();
  
  public abstract void push(final T o);
  
  public abstract List<T> getCollection();
  
  public abstract void setCollection(final List<T> collection);
}

package xtraitj.example.examples.stack.traits;

import java.util.List;

@SuppressWarnings("all")
public interface TStack<T> {
  public abstract List<T> getCollection();
  
  public abstract void setCollection(final List<T> collection);
  
  public abstract boolean isEmpty();
  
  public abstract void push(final T o);
  
  public abstract T pop();
}

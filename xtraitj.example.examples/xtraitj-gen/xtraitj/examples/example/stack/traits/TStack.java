package xtraitj.examples.example.stack.traits;

import java.util.List;

@SuppressWarnings("all")
public interface TStack {
  public abstract List<Object> getCollection();
  
  public abstract void setCollection(final List<Object> collection);
  
  public abstract boolean isEmpty();
  
  public abstract void push(final Object o);
  
  public abstract Object pop();
}

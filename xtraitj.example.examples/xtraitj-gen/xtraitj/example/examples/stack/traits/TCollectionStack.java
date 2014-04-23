package xtraitj.example.examples.stack.traits;

import java.util.Collection;
import java.util.List;
import xtraitj.example.examples.stack.traits.TStack;

@SuppressWarnings("all")
public interface TCollectionStack<T extends Collection<U>, U> extends TStack<Collection<U>> {
  public abstract boolean isEmpty();
  
  public abstract void push(final Collection<U> o);
  
  public abstract Collection<U> pop();
  
  public abstract List<Collection<U>> getCollection();
  
  public abstract void setCollection(final List<Collection<U>> collection);
}

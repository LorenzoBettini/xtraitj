package xtraitj.example.examples.extensions.traits;

import java.util.Iterator;

@SuppressWarnings("all")
public interface TIterator<E> {
  public abstract Iterator<E> getIterator();
  
  public abstract void setIterator(final Iterator<E> iterator);
  
  public abstract boolean hasNext();
  
  public abstract E next();
  
  public abstract void remove();
}

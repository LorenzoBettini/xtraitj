package xtraitj.example.examples.extensions.traits;

import java.util.Iterator;

@SuppressWarnings("all")
public interface TTransformerIterator_TIterator_0_Adapter<T, R> {
  public abstract Iterator<T> getIterator();
  
  public abstract void setIterator(final Iterator<T> iterator);
  
  public abstract boolean hasNext();
  
  public abstract T origNext();
  
  public abstract void remove();
}

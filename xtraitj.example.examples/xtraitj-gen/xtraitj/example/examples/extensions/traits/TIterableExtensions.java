package xtraitj.example.examples.extensions.traits;

@SuppressWarnings("all")
public interface TIterableExtensions<T> {
  public abstract Iterable<T> getIterable();
  
  public abstract void setIterable(final Iterable<T> iterable);
  
  public abstract T head();
  
  public abstract T last();
  
  public abstract String join(final CharSequence separator);
}

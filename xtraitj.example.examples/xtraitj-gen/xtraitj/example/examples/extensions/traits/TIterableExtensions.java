package xtraitj.example.examples.extensions.traits;

import java.util.List;
import org.eclipse.xtext.xbase.lib.Functions.Function1;

@SuppressWarnings("all")
public interface TIterableExtensions<T> {
  public abstract Iterable<T> getIterable();
  
  public abstract void setIterable(final Iterable<T> iterable);
  
  public abstract T head();
  
  public abstract T last();
  
  public abstract String join(final CharSequence separator);
  
  public abstract <R> List<R> mapToList(final Function1<? super T,? extends R> mapper);
}

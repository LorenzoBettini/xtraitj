package xtraitj.example.examples.extensions;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.example.examples.extensions.TIterable;
import xtraitj.example.examples.extensions.TIterableExtensions;
import xtraitj.example.examples.extensions.TIterableExtensionsImpl;
import xtraitj.example.examples.extensions.TIterableImpl;

@SuppressWarnings("all")
public class IterableWithExtensions<T extends Object> implements Iterable<T>, TIterableExtensions<T>, TIterable<T> {
  private Iterable<T> iterable;
  
  public Iterable<T> getIterable() {
    return this.iterable;
  }
  
  public void setIterable(final Iterable<T> iterable) {
    this.iterable = iterable;
  }
  
  private Iterable<T> delegate;
  
  public Iterable<T> getDelegate() {
    return this.delegate;
  }
  
  public void setDelegate(final Iterable<T> delegate) {
    this.delegate = delegate;
  }
  
  public IterableWithExtensions(final Iterable<T> col) {
    this.iterable = col;
    this.delegate = this.iterable;
  }
  
  public IterableWithExtensions(final Collection<T> col) {
    this.iterable = col;
    this.delegate = this.iterable;
  }
  
  private TIterableExtensionsImpl<T> _TIterableExtensions = new TIterableExtensionsImpl(this);
  
  public T head() {
    return _TIterableExtensions._head();
  }
  
  public T last() {
    return _TIterableExtensions._last();
  }
  
  public String join(final CharSequence separator) {
    return _TIterableExtensions._join(separator);
  }
  
  public <R extends Object> List<R> mapToList(final Function1<? super T, ? extends R> mapper) {
    return _TIterableExtensions._mapToList(mapper);
  }
  
  public <R extends Object> Iterable<R> map(final Function1<? super T, ? extends R> mapper) {
    return _TIterableExtensions._map(mapper);
  }
  
  private TIterableImpl<T> _TIterable = new TIterableImpl(this);
  
  public Iterator<T> iterator() {
    return _TIterable._iterator();
  }
}

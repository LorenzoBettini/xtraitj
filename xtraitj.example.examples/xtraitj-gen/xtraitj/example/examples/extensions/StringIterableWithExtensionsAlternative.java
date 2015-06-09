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
public class StringIterableWithExtensionsAlternative implements Iterable<String>, TIterableExtensions<String>, TIterable<String> {
  private Iterable<String> iterable;
  
  public Iterable<String> getIterable() {
    return this.iterable;
  }
  
  public void setIterable(final Iterable<String> iterable) {
    this.iterable = iterable;
  }
  
  private Iterable<String> delegate;
  
  public Iterable<String> getDelegate() {
    return this.delegate;
  }
  
  public void setDelegate(final Iterable<String> delegate) {
    this.delegate = delegate;
  }
  
  public StringIterableWithExtensionsAlternative(final Collection<String> col) {
    this.iterable = col;
    this.delegate = this.iterable;
  }
  
  private TIterableExtensionsImpl<String> _TIterableExtensions = new TIterableExtensionsImpl(this);
  
  public String head() {
    return _TIterableExtensions._head();
  }
  
  public String last() {
    return _TIterableExtensions._last();
  }
  
  public String join(final CharSequence separator) {
    return _TIterableExtensions._join(separator);
  }
  
  public <R extends Object> List<R> mapToList(final Function1<? super String, ? extends R> mapper) {
    return _TIterableExtensions._mapToList(mapper);
  }
  
  public <R extends Object> Iterable<R> map(final Function1<? super String, ? extends R> mapper) {
    return _TIterableExtensions._map(mapper);
  }
  
  private TIterableImpl<String> _TIterable = new TIterableImpl(this);
  
  public Iterator<String> iterator() {
    return _TIterable._iterator();
  }
}

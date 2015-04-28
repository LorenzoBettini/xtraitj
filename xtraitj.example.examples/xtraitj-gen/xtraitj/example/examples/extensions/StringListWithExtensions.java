package xtraitj.example.examples.extensions;

import java.util.List;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.example.examples.extensions.TIterableExtensions;
import xtraitj.example.examples.extensions.TIterableExtensionsImpl;

@SuppressWarnings("all")
public class StringListWithExtensions implements TIterableExtensions<String> {
  private Iterable<String> iterable;
  
  public Iterable<String> getIterable() {
    return this.iterable;
  }
  
  public void setIterable(final Iterable<String> iterable) {
    this.iterable = iterable;
  }
  
  public StringListWithExtensions(final Iterable<String> iterable) {
    this.iterable = iterable;
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
}

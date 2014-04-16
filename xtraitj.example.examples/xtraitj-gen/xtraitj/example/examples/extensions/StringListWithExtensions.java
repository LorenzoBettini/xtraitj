package xtraitj.example.examples.extensions;

import xtraitj.example.examples.extensions.traits.TIterableExtensions;
import xtraitj.example.examples.extensions.traits.impl.TIterableExtensionsImpl;

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
}

package xtraitj.example.examples.extensions;

import java.util.Iterator;
import xtraitj.example.examples.extensions.TIterator;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

/**
 * Acts as a wrapper for a Java Iterator
 */
@XtraitjTraitClass
@SuppressWarnings("all")
public class TIteratorImpl<E extends Object> implements TIterator<E> {
  private TIterator<E> _delegate;
  
  public TIteratorImpl(final TIterator<E> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public Iterator<E> getIterator() {
    return _delegate.getIterator();
  }
  
  public void setIterator(final Iterator<E> iterator) {
    _delegate.setIterator(iterator);
  }
  
  @XtraitjDefinedMethod
  public boolean hasNext() {
    return _delegate.hasNext();
  }
  
  public boolean _hasNext() {
    Iterator<E> _iterator = this.getIterator();
    return _iterator.hasNext();
  }
  
  @XtraitjDefinedMethod
  public E next() {
    return _delegate.next();
  }
  
  public E _next() {
    Iterator<E> _iterator = this.getIterator();
    return _iterator.next();
  }
  
  @XtraitjDefinedMethod
  public void remove() {
    _delegate.remove();
  }
  
  public void _remove() {
    Iterator<E> _iterator = this.getIterator();
    _iterator.remove();
  }
}

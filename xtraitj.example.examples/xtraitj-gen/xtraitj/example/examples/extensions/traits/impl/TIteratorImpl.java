package xtraitj.example.examples.extensions.traits.impl;

import java.util.Iterator;
import xtraitj.example.examples.extensions.traits.TIterator;

/**
 * Acts as a wrapper for a Java Iterator
 */
@SuppressWarnings("all")
public class TIteratorImpl<E> implements TIterator<E> {
  private TIterator<E> _delegate;
  
  public TIteratorImpl(final TIterator<E> delegate) {
    this._delegate = delegate;
  }
  
  public Iterator<E> getIterator() {
    return _delegate.getIterator();
  }
  
  public void setIterator(final Iterator<E> iterator) {
    _delegate.setIterator(iterator);
  }
  
  public boolean hasNext() {
    return _delegate.hasNext();
  }
  
  public boolean _hasNext() {
    Iterator<E> _iterator = this.getIterator();
    return _iterator.hasNext();
  }
  
  public E next() {
    return _delegate.next();
  }
  
  public E _next() {
    Iterator<E> _iterator = this.getIterator();
    return _iterator.next();
  }
  
  public void remove() {
    _delegate.remove();
  }
  
  public void _remove() {
    Iterator<E> _iterator = this.getIterator();
    _iterator.remove();
  }
}

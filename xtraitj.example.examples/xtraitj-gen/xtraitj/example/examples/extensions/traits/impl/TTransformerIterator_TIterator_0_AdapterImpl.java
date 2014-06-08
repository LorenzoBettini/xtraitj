package xtraitj.example.examples.extensions.traits.impl;

import java.util.Iterator;
import xtraitj.example.examples.extensions.traits.TIterator;
import xtraitj.example.examples.extensions.traits.TTransformerIterator_TIterator_0_Adapter;
import xtraitj.example.examples.extensions.traits.impl.TIteratorImpl;

@SuppressWarnings("all")
public class TTransformerIterator_TIterator_0_AdapterImpl<T, R> implements TTransformerIterator_TIterator_0_Adapter<T, R>, TIterator<T> {
  private TTransformerIterator_TIterator_0_Adapter<T, R> _delegate;
  
  private TIteratorImpl<T> _TIterator_0;
  
  public TTransformerIterator_TIterator_0_AdapterImpl(final TTransformerIterator_TIterator_0_Adapter<T, R> delegate) {
    this._delegate = delegate;
    _TIterator_0 = new TIteratorImpl(this);
  }
  
  public Iterator<T> getIterator() {
    return _delegate.getIterator();
  }
  
  public void setIterator(final Iterator<T> iterator) {
    _delegate.setIterator(iterator);
  }
  
  public boolean hasNext() {
    return _delegate.hasNext();
  }
  
  public boolean _hasNext() {
    return _TIterator_0._hasNext();
  }
  
  public T next() {
    return this.origNext();
  }
  
  public T origNext() {
    return _delegate.origNext();
  }
  
  public T _origNext() {
    return _TIterator_0._next();
  }
  
  public void remove() {
    _delegate.remove();
  }
  
  public void _remove() {
    _TIterator_0._remove();
  }
}

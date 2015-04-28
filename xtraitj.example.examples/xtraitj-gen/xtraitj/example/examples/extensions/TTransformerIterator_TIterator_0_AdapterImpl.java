package xtraitj.example.examples.extensions;

import java.util.Iterator;
import xtraitj.example.examples.extensions.TIterator;
import xtraitj.example.examples.extensions.TIteratorImpl;
import xtraitj.example.examples.extensions.TTransformerIterator_TIterator_0_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class TTransformerIterator_TIterator_0_AdapterImpl<T extends Object, R extends Object> implements TTransformerIterator_TIterator_0_Adapter<T, R>, TIterator<T> {
  private TTransformerIterator_TIterator_0_Adapter<T, R> _delegate;
  
  private TIteratorImpl<T> _TIterator_0;
  
  public TTransformerIterator_TIterator_0_AdapterImpl(final TTransformerIterator_TIterator_0_Adapter<T, R> delegate) {
    this._delegate = delegate;
    _TIterator_0 = new TIteratorImpl(this);
  }
  
  public T next() {
    return this.origNext();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("next")
  public T origNext() {
    return _delegate.origNext();
  }
  
  public T _origNext() {
    return _TIterator_0._next();
  }
  
  @XtraitjDefinedMethod
  public boolean hasNext() {
    return _delegate.hasNext();
  }
  
  public boolean _hasNext() {
    return _TIterator_0._hasNext();
  }
  
  @XtraitjDefinedMethod
  public void remove() {
    _delegate.remove();
  }
  
  public void _remove() {
    _TIterator_0._remove();
  }
  
  @XtraitjRequiredField
  public Iterator<T> getIterator() {
    return _delegate.getIterator();
  }
  
  public void setIterator(final Iterator<T> iterator) {
    _delegate.setIterator(iterator);
  }
}

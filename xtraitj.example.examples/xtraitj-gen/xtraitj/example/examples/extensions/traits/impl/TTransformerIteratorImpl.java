package xtraitj.example.examples.extensions.traits.impl;

import java.util.Iterator;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.example.examples.extensions.traits.TTransformerIterator;
import xtraitj.example.examples.extensions.traits.impl.TTransformerIterator_TIterator_0_AdapterImpl;

@SuppressWarnings("all")
public class TTransformerIteratorImpl<T, R> implements TTransformerIterator<T,R> {
  private TTransformerIterator<T,R> _delegate;
  
  private TTransformerIterator_TIterator_0_AdapterImpl<T,R> _TTransformerIterator_TIterator_0;
  
  public TTransformerIteratorImpl(final TTransformerIterator<T,R> delegate) {
    this._delegate = delegate;
    _TTransformerIterator_TIterator_0 = new TTransformerIterator_TIterator_0_AdapterImpl(delegate);
  }
  
  public Function1<? super T,? extends R> getFunction() {
    return _delegate.getFunction();
  }
  
  public void setFunction(final Function1<? super T,? extends R> function) {
    _delegate.setFunction(function);
  }
  
  public R next() {
    return _delegate.next();
  }
  
  public R _next() {
    final T o = this.origNext();
    Function1<? super T,? extends R> _function = this.getFunction();
    return _function.apply(o);
  }
  
  public boolean hasNext() {
    return _delegate.hasNext();
  }
  
  public boolean _hasNext() {
    return _TTransformerIterator_TIterator_0._hasNext();
  }
  
  public T origNext() {
    return _delegate.origNext();
  }
  
  public T _origNext() {
    return _TTransformerIterator_TIterator_0._origNext();
  }
  
  public void remove() {
    _delegate.remove();
  }
  
  public void _remove() {
    _TTransformerIterator_TIterator_0._remove();
  }
  
  public Iterator<T> getIterator() {
    return _delegate.getIterator();
  }
  
  public void setIterator(final Iterator<T> iterator) {
    _delegate.setIterator(iterator);
  }
}

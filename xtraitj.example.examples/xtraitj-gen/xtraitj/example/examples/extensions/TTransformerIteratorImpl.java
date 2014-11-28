package xtraitj.example.examples.extensions;

import java.util.Iterator;
import org.eclipse.xtext.xbase.lib.Functions.Function1;
import xtraitj.example.examples.extensions.TTransformerIterator;
import xtraitj.example.examples.extensions.TTransformerIterator_TIterator_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TTransformerIteratorImpl<T extends Object, R extends Object> implements TTransformerIterator<T, R> {
  private TTransformerIterator<T, R> _delegate;
  
  private TTransformerIterator_TIterator_0_AdapterImpl<T, R> _TIterator_0;
  
  public TTransformerIteratorImpl(final TTransformerIterator<T, R> delegate) {
    this._delegate = delegate;
    _TIterator_0 = new TTransformerIterator_TIterator_0_AdapterImpl(delegate);
  }
  
  @XtraitjRequiredField
  public Function1<? super T, ? extends R> getFunction() {
    return _delegate.getFunction();
  }
  
  public void setFunction(final Function1<? super T, ? extends R> function) {
    _delegate.setFunction(function);
  }
  
  @XtraitjDefinedMethod
  public R next() {
    return _delegate.next();
  }
  
  public R _next() {
    final T o = this.origNext();
    Function1<? super T, ? extends R> _function = this.getFunction();
    return _function.apply(o);
  }
  
  @XtraitjDefinedMethod
  public T origNext() {
    return _delegate.origNext();
  }
  
  public T _origNext() {
    return _TIterator_0._origNext();
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

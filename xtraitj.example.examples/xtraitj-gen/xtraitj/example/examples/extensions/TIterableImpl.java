package xtraitj.example.examples.extensions;

import java.util.Iterator;
import xtraitj.example.examples.extensions.TIterable;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TIterableImpl<T extends Object> implements TIterable<T> {
  private TIterable<T> _delegate;
  
  public TIterableImpl(final TIterable<T> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public Iterable<T> getDelegate() {
    return _delegate.getDelegate();
  }
  
  public void setDelegate(final Iterable<T> delegate) {
    _delegate.setDelegate(delegate);
  }
  
  @XtraitjDefinedMethod
  public Iterator<T> iterator() {
    return _delegate.iterator();
  }
  
  public Iterator<T> _iterator() {
    Iterable<T> _delegate = this.getDelegate();
    return _delegate.iterator();
  }
}

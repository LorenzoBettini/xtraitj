package xtraitj.example.examples.extensions;

import java.util.Iterator;
import xtraitj.example.examples.extensions.StringIterableWithExtensions_TIterable_0_Adapter;
import xtraitj.example.examples.extensions.TIterable;
import xtraitj.example.examples.extensions.TIterableImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class StringIterableWithExtensions_TIterable_0_AdapterImpl implements StringIterableWithExtensions_TIterable_0_Adapter, TIterable<String> {
  private StringIterableWithExtensions_TIterable_0_Adapter _delegate;
  
  private TIterableImpl<String> _TIterable_0;
  
  public StringIterableWithExtensions_TIterable_0_AdapterImpl(final StringIterableWithExtensions_TIterable_0_Adapter delegate) {
    this._delegate = delegate;
    _TIterable_0 = new TIterableImpl(this);
  }
  
  public Iterable<String> getDelegate() {
    return this.getIterable();
  }
  
  @XtraitjRequiredField
  @XtraitjRenamedMethod("getDelegate")
  public Iterable<String> getIterable() {
    return _delegate.getIterable();
  }
  
  public void setDelegate(final Iterable<String> iterable) {
    this.setIterable(iterable);
  }
  
  public void setIterable(final Iterable<String> iterable) {
    _delegate.setIterable(iterable);
  }
  
  @XtraitjDefinedMethod
  public Iterator<String> iterator() {
    return _delegate.iterator();
  }
  
  public Iterator<String> _iterator() {
    return _TIterable_0._iterator();
  }
}

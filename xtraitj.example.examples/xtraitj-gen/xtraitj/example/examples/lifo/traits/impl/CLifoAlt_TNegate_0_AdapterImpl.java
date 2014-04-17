package xtraitj.example.examples.lifo.traits.impl;

import xtrait.example.examples.util.traits.TNegate;
import xtrait.example.examples.util.traits.impl.TNegateImpl;
import xtraitj.example.examples.lifo.traits.CLifoAlt_TNegate_0_Adapter;

@SuppressWarnings("all")
public class CLifoAlt_TNegate_0_AdapterImpl<T> implements CLifoAlt_TNegate_0_Adapter<T>, TNegate {
  private CLifoAlt_TNegate_0_Adapter<T> _delegate;
  
  private TNegateImpl _TNegate_1;
  
  public CLifoAlt_TNegate_0_AdapterImpl(final CLifoAlt_TNegate_0_Adapter<T> delegate) {
    this._delegate = delegate;
    _TNegate_1 = new TNegateImpl(this);
  }
  
  public boolean notOp() {
    return this.isNotEmpty();
  }
  
  public boolean isNotEmpty() {
    return _delegate.isNotEmpty();
  }
  
  public boolean _isNotEmpty() {
    return _TNegate_1._notOp();
  }
  
  public boolean op() {
    return this.isEmpty();
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
}

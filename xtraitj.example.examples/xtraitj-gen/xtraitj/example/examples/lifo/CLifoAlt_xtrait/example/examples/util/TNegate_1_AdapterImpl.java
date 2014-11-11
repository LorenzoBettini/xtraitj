package xtraitj.example.examples.lifo.CLifoAlt_xtrait.example.examples.util;

import xtrait.example.examples.util.TNegate;
import xtrait.example.examples.util.TNegateImpl;
import xtraitj.example.examples.lifo.CLifoAlt_xtrait.example.examples.util.TNegate_1_Adapter;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRenamedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;

@SuppressWarnings("all")
public class TNegate_1_AdapterImpl<T extends Object> implements TNegate_1_Adapter<T>, TNegate {
  private TNegate_1_Adapter<T> _delegate;
  
  private TNegateImpl _TNegate_1;
  
  public TNegate_1_AdapterImpl(final TNegate_1_Adapter<T> delegate) {
    this._delegate = delegate;
    _TNegate_1 = new TNegateImpl(this);
  }
  
  public boolean op() {
    return this.isEmpty();
  }
  
  @XtraitjRequiredMethod
  @XtraitjRenamedMethod("op")
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean notOp() {
    return this.isNotEmpty();
  }
  
  @XtraitjDefinedMethod
  @XtraitjRenamedMethod("notOp")
  public boolean isNotEmpty() {
    return _delegate.isNotEmpty();
  }
  
  public boolean _isNotEmpty() {
    return _TNegate_1._notOp();
  }
}

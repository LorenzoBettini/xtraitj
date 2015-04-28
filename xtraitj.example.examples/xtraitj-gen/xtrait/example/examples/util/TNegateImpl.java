package xtrait.example.examples.util;

import xtrait.example.examples.util.TNegate;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

/**
 * A simple trait that negates a boolean operation
 */
@XtraitjTraitClass
@SuppressWarnings("all")
public class TNegateImpl implements TNegate {
  private TNegate _delegate;
  
  public TNegateImpl(final TNegate delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredMethod
  public boolean op() {
    return _delegate.op();
  }
  
  @XtraitjDefinedMethod
  public boolean notOp() {
    return _delegate.notOp();
  }
  
  public boolean _notOp() {
    boolean _op = this.op();
    return (!_op);
  }
}

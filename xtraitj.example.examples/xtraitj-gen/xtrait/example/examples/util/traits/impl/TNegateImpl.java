package xtrait.example.examples.util.traits.impl;

import xtrait.example.examples.util.traits.TNegate;

/**
 * A simple trait that negates a boolean operation
 */
@SuppressWarnings("all")
public class TNegateImpl implements TNegate {
  private TNegate _delegate;
  
  public TNegateImpl(final TNegate delegate) {
    this._delegate = delegate;
  }
  
  public boolean op() {
    return _delegate.op();
  }
  
  public boolean notOp() {
    return _delegate.notOp();
  }
  
  public boolean _notOp() {
    boolean _op = this.op();
    return (!_op);
  }
}

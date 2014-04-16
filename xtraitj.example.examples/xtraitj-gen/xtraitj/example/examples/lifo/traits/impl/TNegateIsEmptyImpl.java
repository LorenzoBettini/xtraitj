package xtraitj.example.examples.lifo.traits.impl;

import xtraitj.example.examples.lifo.traits.TNegateIsEmpty;

@SuppressWarnings("all")
public class TNegateIsEmptyImpl implements TNegateIsEmpty {
  private TNegateIsEmpty _delegate;
  
  public TNegateIsEmptyImpl(final TNegateIsEmpty delegate) {
    this._delegate = delegate;
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean isNotEmpty() {
    return _delegate.isNotEmpty();
  }
  
  public boolean _isNotEmpty() {
    boolean _isEmpty = this.isEmpty();
    return (!_isEmpty);
  }
}

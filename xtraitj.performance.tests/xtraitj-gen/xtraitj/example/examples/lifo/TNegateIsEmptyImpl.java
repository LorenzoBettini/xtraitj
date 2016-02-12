package xtraitj.example.examples.lifo;

import xtraitj.example.examples.lifo.TNegateIsEmpty;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TNegateIsEmptyImpl implements TNegateIsEmpty {
  private TNegateIsEmpty _delegate;
  
  public TNegateIsEmptyImpl(final TNegateIsEmpty delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredMethod
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  @XtraitjDefinedMethod
  public boolean isNotEmpty() {
    return _delegate.isNotEmpty();
  }
  
  public boolean _isNotEmpty() {
    boolean _isEmpty = this.isEmpty();
    return (!_isEmpty);
  }
}

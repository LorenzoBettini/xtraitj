package xtraitj.input.tests.generated;

import xtraitj.input.tests.generated.T1Gen;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjRequiredMethod;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class T1GenImpl<T extends Object> implements T1Gen<T> {
  private T1Gen<T> _delegate;
  
  public T1GenImpl(final T1Gen<T> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public T getF() {
    return _delegate.getF();
  }
  
  public void setF(final T f) {
    _delegate.setF(f);
  }
  
  @XtraitjRequiredMethod
  public T required(final T t) {
    return _delegate.required(t);
  }
  
  @XtraitjDefinedMethod
  public T provided(final T t) {
    return _delegate.provided(t);
  }
  
  public T _provided(final T t) {
    return this.required(t);
  }
}

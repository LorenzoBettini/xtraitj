package my.traits.traits.impl;

import com.google.common.base.Objects;
import java.util.List;
import my.traits.traits.T;

@SuppressWarnings("all")
public class TImpl implements T {
  private T _delegate;
  
  public TImpl(final T delegate) {
    this._delegate = delegate;
  }
  
  public String getS() {
    return _delegate.getS();
  }
  
  public void setS(final String s) {
    _delegate.setS(s);
  }
  
  public List<? extends String> getStrings() {
    return _delegate.getStrings();
  }
  
  public void setStrings(final List<? extends String> strings) {
    _delegate.setStrings(strings);
  }
  
  public String m() {
    return _delegate.m();
  }
  
  public String _m() {
    List<? extends String> _strings = this.getStrings();
    boolean _notEquals = (!Objects.equal(_strings, null));
    if (_notEquals) {
      List<? extends String> _strings_1 = this.getStrings();
      return _strings_1.toString();
    } else {
      return this.getS();
    }
  }
}

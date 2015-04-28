package xtraitj.example.examples.lifo;

import java.util.List;
import xtraitj.example.examples.lifo.CLifoAlt_TLifoAlt_0_Adapter;
import xtraitj.example.examples.lifo.TLifoAlt;
import xtraitj.example.examples.lifo.TLifoAltImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class CLifoAlt_TLifoAlt_0_AdapterImpl<T extends Object> implements CLifoAlt_TLifoAlt_0_Adapter<T>, TLifoAlt<T> {
  private CLifoAlt_TLifoAlt_0_Adapter<T> _delegate;
  
  private TLifoAltImpl<T> _TLifoAlt_0;
  
  public CLifoAlt_TLifoAlt_0_AdapterImpl(final CLifoAlt_TLifoAlt_0_Adapter<T> delegate) {
    this._delegate = delegate;
    _TLifoAlt_0 = new TLifoAltImpl(this);
  }
  
  public T old_pop() {
    return _TLifoAlt_0._old_pop();
  }
  
  @XtraitjDefinedMethod
  public void pop() {
    _delegate.pop();
  }
  
  public void _pop() {
    _TLifoAlt_0._pop();
  }
  
  @XtraitjDefinedMethod
  public T top() {
    return _delegate.top();
  }
  
  public T _top() {
    return _TLifoAlt_0._top();
  }
  
  @XtraitjDefinedMethod
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TLifoAlt_0._isEmpty();
  }
  
  @XtraitjDefinedMethod
  public void push(final T o) {
    _delegate.push(o);
  }
  
  public void _push(final T o) {
    _TLifoAlt_0._push(o);
  }
  
  @XtraitjRequiredField
  public List<T> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<T> collection) {
    _delegate.setCollection(collection);
  }
}

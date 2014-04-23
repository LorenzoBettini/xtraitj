package xtraitj.example.examples.lifo.traits.impl;

import java.util.List;
import xtraitj.example.examples.lifo.traits.CLifoAlt_TLifoAlt_0_Adapter;
import xtraitj.example.examples.lifo.traits.TLifoAlt;
import xtraitj.example.examples.lifo.traits.impl.TLifoAltImpl;

@SuppressWarnings("all")
public class CLifoAlt_TLifoAlt_0_AdapterImpl<T> implements CLifoAlt_TLifoAlt_0_Adapter<T>, TLifoAlt<T> {
  private CLifoAlt_TLifoAlt_0_Adapter<T> _delegate;
  
  private TLifoAltImpl<T> _TLifoAlt_0;
  
  public CLifoAlt_TLifoAlt_0_AdapterImpl(final CLifoAlt_TLifoAlt_0_Adapter<T> delegate) {
    this._delegate = delegate;
    _TLifoAlt_0 = new TLifoAltImpl(this);
  }
  
  public void pop() {
    _delegate.pop();
  }
  
  public void _pop() {
    _TLifoAlt_0._pop();
  }
  
  public T top() {
    return _delegate.top();
  }
  
  public T _top() {
    return _TLifoAlt_0._top();
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TLifoAlt_0._isEmpty();
  }
  
  public void push(final T o) {
    _delegate.push(o);
  }
  
  public void _push(final T o) {
    _TLifoAlt_0._push(o);
  }
  
  public T old_pop() {
    return _TLifoAlt_0._old_pop();
  }
  
  public List<T> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<T> collection) {
    _delegate.setCollection(collection);
  }
}

package xtraitj.example.examples.lifo;

import java.util.List;
import xtraitj.example.examples.lifo.TLifo_TStack_0_Adapter;
import xtraitj.example.examples.stack.TStack;
import xtraitj.example.examples.stack.TStackImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;

@SuppressWarnings("all")
public class TLifo_TStack_0_AdapterImpl<V extends Object> implements TLifo_TStack_0_Adapter<V>, TStack<V> {
  private TLifo_TStack_0_Adapter<V> _delegate;
  
  private TStackImpl<V> _TStack_0;
  
  public TLifo_TStack_0_AdapterImpl(final TLifo_TStack_0_Adapter<V> delegate) {
    this._delegate = delegate;
    _TStack_0 = new TStackImpl(this);
  }
  
  public V pop() {
    return _TStack_0._pop();
  }
  
  @XtraitjDefinedMethod
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TStack_0._isEmpty();
  }
  
  @XtraitjDefinedMethod
  public void push(final V o) {
    _delegate.push(o);
  }
  
  public void _push(final V o) {
    _TStack_0._push(o);
  }
  
  @XtraitjRequiredField
  public List<V> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<V> collection) {
    _delegate.setCollection(collection);
  }
}

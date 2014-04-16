package xtraitj.examples.example.lifo.traits.impl;

import java.util.List;
import xtraitj.examples.example.lifo.traits.TLifo_TStack_0_Adapter;
import xtraitj.examples.example.stack.traits.TStack;
import xtraitj.examples.example.stack.traits.impl.TStackImpl;

@SuppressWarnings("all")
public class TLifo_TStack_0_AdapterImpl implements TLifo_TStack_0_Adapter, TStack {
  private TLifo_TStack_0_Adapter _delegate;
  
  private TStackImpl _TStack_0;
  
  public TLifo_TStack_0_AdapterImpl(final TLifo_TStack_0_Adapter delegate) {
    this._delegate = delegate;
    _TStack_0 = new TStackImpl(this);
  }
  
  public List<Object> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<Object> collection) {
    _delegate.setCollection(collection);
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TStack_0._isEmpty();
  }
  
  public void push(final Object o) {
    _delegate.push(o);
  }
  
  public void _push(final Object o) {
    _TStack_0._push(o);
  }
  
  public Object pop() {
    return _TStack_0._pop();
  }
}

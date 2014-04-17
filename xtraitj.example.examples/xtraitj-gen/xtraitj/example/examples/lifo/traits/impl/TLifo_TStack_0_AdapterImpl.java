package xtraitj.example.examples.lifo.traits.impl;

import java.util.List;
import xtraitj.example.examples.lifo.traits.TLifo_TStack_0_Adapter;
import xtraitj.example.examples.stack.traits.TStack;
import xtraitj.example.examples.stack.traits.impl.TStackImpl;

@SuppressWarnings("all")
public class TLifo_TStack_0_AdapterImpl<V> implements TLifo_TStack_0_Adapter<V>, TStack<V> {
  private TLifo_TStack_0_Adapter<V> _delegate;
  
  private TStackImpl<V> _TStack_0;
  
  public TLifo_TStack_0_AdapterImpl(final TLifo_TStack_0_Adapter<V> delegate) {
    this._delegate = delegate;
    _TStack_0 = new TStackImpl(this);
  }
  
  public List<V> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<V> collection) {
    _delegate.setCollection(collection);
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TStack_0._isEmpty();
  }
  
  public void push(final V o) {
    _delegate.push(o);
  }
  
  public void _push(final V o) {
    _TStack_0._push(o);
  }
  
  public V pop() {
    return _TStack_0._pop();
  }
}

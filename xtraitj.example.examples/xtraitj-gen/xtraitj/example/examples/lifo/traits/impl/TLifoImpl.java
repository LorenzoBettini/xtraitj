package xtraitj.example.examples.lifo.traits.impl;

import java.util.List;
import xtraitj.example.examples.lifo.traits.TLifo;
import xtraitj.example.examples.lifo.traits.impl.TLifo_TStack_0_AdapterImpl;

@SuppressWarnings("all")
public class TLifoImpl<V> implements TLifo<V> {
  private TLifo<V> _delegate;
  
  private TLifo_TStack_0_AdapterImpl<V> _TLifo_TStack_0;
  
  public TLifoImpl(final TLifo<V> delegate) {
    this._delegate = delegate;
    _TLifo_TStack_0 = new TLifo_TStack_0_AdapterImpl(delegate);
  }
  
  public void pop() {
    _delegate.pop();
  }
  
  public void _pop() {
    boolean _isEmpty = this.isEmpty();
    boolean _not = (!_isEmpty);
    if (_not) {
      List<V> _collection = this.getCollection();
      _collection.remove(0);
    }
  }
  
  public V top() {
    return _delegate.top();
  }
  
  public V _top() {
    boolean _isEmpty = this.isEmpty();
    if (_isEmpty) {
      return null;
    }
    List<V> _collection = this.getCollection();
    return _collection.get(0);
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TLifo_TStack_0._isEmpty();
  }
  
  public void push(final V o) {
    _delegate.push(o);
  }
  
  public void _push(final V o) {
    _TLifo_TStack_0._push(o);
  }
  
  public List<V> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<V> collection) {
    _delegate.setCollection(collection);
  }
}

package xtraitj.examples.example.lifo.traits.impl;

import java.util.List;
import xtraitj.examples.example.lifo.traits.TLifo;
import xtraitj.examples.example.lifo.traits.impl.TLifo_TStack_0_AdapterImpl;

@SuppressWarnings("all")
public class TLifoImpl implements TLifo {
  private TLifo _delegate;
  
  private TLifo_TStack_0_AdapterImpl _TLifo_TStack_0;
  
  public TLifoImpl(final TLifo delegate) {
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
      List<Object> _collection = this.getCollection();
      _collection.remove(0);
    }
  }
  
  public Object top() {
    return _delegate.top();
  }
  
  public Object _top() {
    boolean _isEmpty = this.isEmpty();
    if (_isEmpty) {
      return null;
    }
    List<Object> _collection = this.getCollection();
    return _collection.get(0);
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TLifo_TStack_0._isEmpty();
  }
  
  public void push(final Object o) {
    _delegate.push(o);
  }
  
  public void _push(final Object o) {
    _TLifo_TStack_0._push(o);
  }
  
  public List<Object> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<Object> collection) {
    _delegate.setCollection(collection);
  }
}

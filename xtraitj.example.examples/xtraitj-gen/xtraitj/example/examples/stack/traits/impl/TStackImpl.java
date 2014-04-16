package xtraitj.example.examples.stack.traits.impl;

import java.util.List;
import xtraitj.example.examples.stack.traits.TStack;

@SuppressWarnings("all")
public class TStackImpl implements TStack {
  private TStack _delegate;
  
  public TStackImpl(final TStack delegate) {
    this._delegate = delegate;
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
    List<Object> _collection = this.getCollection();
    int _size = _collection.size();
    return (_size == 0);
  }
  
  public void push(final Object o) {
    _delegate.push(o);
  }
  
  public void _push(final Object o) {
    List<Object> _collection = this.getCollection();
    _collection.add(0, o);
  }
  
  public Object pop() {
    return _delegate.pop();
  }
  
  public Object _pop() {
    boolean _isEmpty = this.isEmpty();
    if (_isEmpty) {
      return null;
    }
    List<Object> _collection = this.getCollection();
    return _collection.remove(0);
  }
}

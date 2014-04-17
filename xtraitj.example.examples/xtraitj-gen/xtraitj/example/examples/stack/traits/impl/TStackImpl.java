package xtraitj.example.examples.stack.traits.impl;

import java.util.List;
import xtraitj.example.examples.stack.traits.TStack;

@SuppressWarnings("all")
public class TStackImpl<T> implements TStack<T> {
  private TStack<T> _delegate;
  
  public TStackImpl(final TStack<T> delegate) {
    this._delegate = delegate;
  }
  
  public List<T> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<T> collection) {
    _delegate.setCollection(collection);
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    List<T> _collection = this.getCollection();
    int _size = _collection.size();
    return (_size == 0);
  }
  
  public void push(final T o) {
    _delegate.push(o);
  }
  
  public void _push(final T o) {
    List<T> _collection = this.getCollection();
    _collection.add(0, o);
  }
  
  public T pop() {
    return _delegate.pop();
  }
  
  public T _pop() {
    boolean _isEmpty = this.isEmpty();
    if (_isEmpty) {
      return null;
    }
    List<T> _collection = this.getCollection();
    return _collection.remove(0);
  }
}

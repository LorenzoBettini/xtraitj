package xtraitj.example.examples.lifo.traits.impl;

import java.util.List;
import xtraitj.example.examples.lifo.traits.TLifoAlt;
import xtraitj.example.examples.lifo.traits.impl.TLifoAlt_TStack_0_AdapterImpl;

@SuppressWarnings("all")
public class TLifoAltImpl<T> implements TLifoAlt<T> {
  private TLifoAlt<T> _delegate;
  
  private TLifoAlt_TStack_0_AdapterImpl<T> _TLifoAlt_TStack_0;
  
  public TLifoAltImpl(final TLifoAlt<T> delegate) {
    this._delegate = delegate;
    _TLifoAlt_TStack_0 = new TLifoAlt_TStack_0_AdapterImpl(delegate);
  }
  
  public void pop() {
    _delegate.pop();
  }
  
  public void _pop() {
    this.old_pop();
  }
  
  public T top() {
    return _delegate.top();
  }
  
  public T _top() {
    boolean _isEmpty = this.isEmpty();
    if (_isEmpty) {
      return null;
    }
    List<T> _collection = this.getCollection();
    return _collection.get(0);
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TLifoAlt_TStack_0._isEmpty();
  }
  
  public void push(final T o) {
    _delegate.push(o);
  }
  
  public void _push(final T o) {
    _TLifoAlt_TStack_0._push(o);
  }
  
  public T old_pop() {
    return _delegate.old_pop();
  }
  
  public T _old_pop() {
    return _TLifoAlt_TStack_0._old_pop();
  }
  
  public List<T> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<T> collection) {
    _delegate.setCollection(collection);
  }
}

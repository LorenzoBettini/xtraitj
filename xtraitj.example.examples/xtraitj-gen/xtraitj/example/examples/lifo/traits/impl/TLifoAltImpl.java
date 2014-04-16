package xtraitj.example.examples.lifo.traits.impl;

import java.util.List;
import xtraitj.example.examples.lifo.traits.TLifoAlt;
import xtraitj.example.examples.lifo.traits.impl.TLifoAlt_TStack_0_AdapterImpl;

@SuppressWarnings("all")
public class TLifoAltImpl implements TLifoAlt {
  private TLifoAlt _delegate;
  
  private TLifoAlt_TStack_0_AdapterImpl _TLifoAlt_TStack_0;
  
  public TLifoAltImpl(final TLifoAlt delegate) {
    this._delegate = delegate;
    _TLifoAlt_TStack_0 = new TLifoAlt_TStack_0_AdapterImpl(delegate);
  }
  
  public void pop() {
    _delegate.pop();
  }
  
  public void _pop() {
    this.old_pop();
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
    return _TLifoAlt_TStack_0._isEmpty();
  }
  
  public void push(final Object o) {
    _delegate.push(o);
  }
  
  public void _push(final Object o) {
    _TLifoAlt_TStack_0._push(o);
  }
  
  public Object old_pop() {
    return _delegate.old_pop();
  }
  
  public Object _old_pop() {
    return _TLifoAlt_TStack_0._old_pop();
  }
  
  public List<Object> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<Object> collection) {
    _delegate.setCollection(collection);
  }
}

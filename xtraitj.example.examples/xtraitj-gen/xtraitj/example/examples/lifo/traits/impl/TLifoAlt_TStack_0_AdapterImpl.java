package xtraitj.example.examples.lifo.traits.impl;

import java.util.List;
import xtraitj.example.examples.lifo.traits.TLifoAlt_TStack_0_Adapter;
import xtraitj.example.examples.stack.traits.TStack;
import xtraitj.example.examples.stack.traits.impl.TStackImpl;

@SuppressWarnings("all")
public class TLifoAlt_TStack_0_AdapterImpl<T> implements TLifoAlt_TStack_0_Adapter<T>, TStack<T> {
  private TLifoAlt_TStack_0_Adapter<T> _delegate;
  
  private TStackImpl<T> _TStack_0;
  
  public TLifoAlt_TStack_0_AdapterImpl(final TLifoAlt_TStack_0_Adapter<T> delegate) {
    this._delegate = delegate;
    _TStack_0 = new TStackImpl(this);
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
    return _TStack_0._isEmpty();
  }
  
  public void push(final T o) {
    _delegate.push(o);
  }
  
  public void _push(final T o) {
    _TStack_0._push(o);
  }
  
  public T pop() {
    return this.old_pop();
  }
  
  public T old_pop() {
    return _delegate.old_pop();
  }
  
  public T _old_pop() {
    return _TStack_0._pop();
  }
}

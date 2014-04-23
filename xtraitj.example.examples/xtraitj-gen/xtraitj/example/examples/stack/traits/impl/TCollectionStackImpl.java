package xtraitj.example.examples.stack.traits.impl;

import java.util.Collection;
import java.util.List;
import xtraitj.example.examples.stack.traits.TCollectionStack;
import xtraitj.example.examples.stack.traits.impl.TStackImpl;

@SuppressWarnings("all")
public class TCollectionStackImpl<T extends Collection<U>, U> implements TCollectionStack<T,U> {
  private TCollectionStack<T,U> _delegate;
  
  private TStackImpl<Collection<U>> _TStack;
  
  public TCollectionStackImpl(final TCollectionStack<T,U> delegate) {
    this._delegate = delegate;
    _TStack = new TStackImpl(delegate);
  }
  
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TStack._isEmpty();
  }
  
  public void push(final Collection<U> o) {
    _delegate.push(o);
  }
  
  public void _push(final Collection<U> o) {
    _TStack._push(o);
  }
  
  public Collection<U> pop() {
    return _delegate.pop();
  }
  
  public Collection<U> _pop() {
    return _TStack._pop();
  }
  
  public List<Collection<U>> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<Collection<U>> collection) {
    _delegate.setCollection(collection);
  }
}

package xtraitj.example.examples.stack;

import java.util.Collection;
import java.util.List;
import xtraitj.example.examples.stack.TCollectionStack;
import xtraitj.example.examples.stack.TStackImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TCollectionStackImpl<T extends Collection<U>, U extends Object> implements TCollectionStack<T, U> {
  private TCollectionStack<T, U> _delegate;
  
  private TStackImpl<Collection<U>> _TStack;
  
  public TCollectionStackImpl(final TCollectionStack<T, U> delegate) {
    this._delegate = delegate;
    _TStack = new TStackImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TStack._isEmpty();
  }
  
  @XtraitjDefinedMethod
  public void push(final Collection<U> o) {
    _delegate.push(o);
  }
  
  public void _push(final Collection<U> o) {
    _TStack._push(o);
  }
  
  @XtraitjDefinedMethod
  public Collection<U> pop() {
    return _delegate.pop();
  }
  
  public Collection<U> _pop() {
    return _TStack._pop();
  }
  
  @XtraitjRequiredField
  public List<Collection<U>> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<Collection<U>> collection) {
    _delegate.setCollection(collection);
  }
}

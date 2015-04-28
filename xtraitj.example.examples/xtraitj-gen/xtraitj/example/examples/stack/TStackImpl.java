package xtraitj.example.examples.stack;

import java.util.List;
import xtraitj.example.examples.stack.TStack;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TStackImpl<T extends Object> implements TStack<T> {
  private TStack<T> _delegate;
  
  public TStackImpl(final TStack<T> delegate) {
    this._delegate = delegate;
  }
  
  @XtraitjRequiredField
  public List<T> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<T> collection) {
    _delegate.setCollection(collection);
  }
  
  @XtraitjDefinedMethod
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    List<T> _collection = this.getCollection();
    int _size = _collection.size();
    return (_size == 0);
  }
  
  @XtraitjDefinedMethod
  public void push(final T o) {
    _delegate.push(o);
  }
  
  public void _push(final T o) {
    List<T> _collection = this.getCollection();
    _collection.add(0, o);
  }
  
  @XtraitjDefinedMethod
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

package xtraitj.example.examples.lifo;

import java.util.List;
import xtraitj.example.examples.lifo.TLifoAlt;
import xtraitj.example.examples.lifo.TLifoAlt_TStack_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TLifoAltImpl<T extends Object> implements TLifoAlt<T> {
  private TLifoAlt<T> _delegate;
  
  private TLifoAlt_TStack_0_AdapterImpl<T> _TStack_0;
  
  public TLifoAltImpl(final TLifoAlt<T> delegate) {
    this._delegate = delegate;
    _TStack_0 = new TLifoAlt_TStack_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public void pop() {
    _delegate.pop();
  }
  
  public void _pop() {
    this.old_pop();
  }
  
  @XtraitjDefinedMethod
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
  
  @XtraitjDefinedMethod
  public T old_pop() {
    return _delegate.old_pop();
  }
  
  public T _old_pop() {
    return _TStack_0._old_pop();
  }
  
  @XtraitjDefinedMethod
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TStack_0._isEmpty();
  }
  
  @XtraitjDefinedMethod
  public void push(final T o) {
    _delegate.push(o);
  }
  
  public void _push(final T o) {
    _TStack_0._push(o);
  }
  
  @XtraitjRequiredField
  public List<T> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<T> collection) {
    _delegate.setCollection(collection);
  }
}

package xtraitj.example.examples.lifo;

import java.util.List;
import xtraitj.example.examples.lifo.TLifo;
import xtraitj.example.examples.lifo.TLifo_xtraitj.example.examples.stack.TStack_0_AdapterImpl;
import xtraitj.runtime.lib.annotation.XtraitjDefinedMethod;
import xtraitj.runtime.lib.annotation.XtraitjRequiredField;
import xtraitj.runtime.lib.annotation.XtraitjTraitClass;

@XtraitjTraitClass
@SuppressWarnings("all")
public class TLifoImpl<V extends Object> implements TLifo<V> {
  private TLifo<V> _delegate;
  
  private TStack_0_AdapterImpl<V> _TStack_0;
  
  public TLifoImpl(final TLifo<V> delegate) {
    this._delegate = delegate;
    _TStack_0 = new TStack_0_AdapterImpl(delegate);
  }
  
  @XtraitjDefinedMethod
  public void pop() {
    _delegate.pop();
  }
  
  public void _pop() {
    boolean _isEmpty = this.isEmpty();
    boolean _not = (!_isEmpty);
    if (_not) {
      List<V> _collection = this.getCollection();
      _collection.remove(0);
    }
  }
  
  @XtraitjDefinedMethod
  public V top() {
    return _delegate.top();
  }
  
  public V _top() {
    boolean _isEmpty = this.isEmpty();
    if (_isEmpty) {
      return null;
    }
    List<V> _collection = this.getCollection();
    return _collection.get(0);
  }
  
  @XtraitjDefinedMethod
  public boolean isEmpty() {
    return _delegate.isEmpty();
  }
  
  public boolean _isEmpty() {
    return _TStack_0._isEmpty();
  }
  
  @XtraitjDefinedMethod
  public void push(final V o) {
    _delegate.push(o);
  }
  
  public void _push(final V o) {
    _TStack_0._push(o);
  }
  
  @XtraitjRequiredField
  public List<V> getCollection() {
    return _delegate.getCollection();
  }
  
  public void setCollection(final List<V> collection) {
    _delegate.setCollection(collection);
  }
}

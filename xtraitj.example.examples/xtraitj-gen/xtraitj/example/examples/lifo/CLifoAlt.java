package xtraitj.example.examples.lifo;

import java.util.ArrayList;
import java.util.List;
import xtraitj.example.examples.lifo.ILifo;
import xtraitj.example.examples.lifo.traits.CLifoAlt_TNegate_0_Adapter;
import xtraitj.example.examples.lifo.traits.TLifoAlt;
import xtraitj.example.examples.lifo.traits.impl.CLifoAlt_TNegate_0_AdapterImpl;
import xtraitj.example.examples.lifo.traits.impl.TLifoAltImpl;

@SuppressWarnings("all")
public class CLifoAlt<T> implements ILifo<T>, TLifoAlt<T>, CLifoAlt_TNegate_0_Adapter<T> {
  private List<T> collection = new ArrayList<T>();
  
  public List<T> getCollection() {
    return this.collection;
  }
  
  public void setCollection(final List<T> collection) {
    this.collection = collection;
  }
  
  private TLifoAltImpl<T> _TLifoAlt = new TLifoAltImpl(this);
  
  public void pop() {
    _TLifoAlt._pop();
  }
  
  public T top() {
    return _TLifoAlt._top();
  }
  
  public boolean isEmpty() {
    return _TLifoAlt._isEmpty();
  }
  
  public void push(final T o) {
    _TLifoAlt._push(o);
  }
  
  public T old_pop() {
    return _TLifoAlt._old_pop();
  }
  
  private CLifoAlt_TNegate_0_AdapterImpl<T> _CLifoAlt_TNegate_0 = new CLifoAlt_TNegate_0_AdapterImpl(this);
  
  public boolean isNotEmpty() {
    return _CLifoAlt_TNegate_0._isNotEmpty();
  }
}

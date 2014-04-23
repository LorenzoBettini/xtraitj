package xtraitj.example.examples.lifo;

import java.util.ArrayList;
import java.util.List;
import xtraitj.example.examples.lifo.ILifo;
import xtraitj.example.examples.lifo.traits.CLifoAlt_TLifoAlt_0_Adapter;
import xtraitj.example.examples.lifo.traits.CLifoAlt_TNegate_1_Adapter;
import xtraitj.example.examples.lifo.traits.impl.CLifoAlt_TLifoAlt_0_AdapterImpl;
import xtraitj.example.examples.lifo.traits.impl.CLifoAlt_TNegate_1_AdapterImpl;

@SuppressWarnings("all")
public class CLifoAlt<T> implements ILifo<T>, CLifoAlt_TLifoAlt_0_Adapter<T>, CLifoAlt_TNegate_1_Adapter<T> {
  private List<T> collection = new ArrayList<T>();
  
  public List<T> getCollection() {
    return this.collection;
  }
  
  public void setCollection(final List<T> collection) {
    this.collection = collection;
  }
  
  private CLifoAlt_TLifoAlt_0_AdapterImpl<T> _CLifoAlt_TLifoAlt_0 = new CLifoAlt_TLifoAlt_0_AdapterImpl(this);
  
  public void pop() {
    _CLifoAlt_TLifoAlt_0._pop();
  }
  
  public T top() {
    return _CLifoAlt_TLifoAlt_0._top();
  }
  
  public boolean isEmpty() {
    return _CLifoAlt_TLifoAlt_0._isEmpty();
  }
  
  public void push(final T o) {
    _CLifoAlt_TLifoAlt_0._push(o);
  }
  
  private CLifoAlt_TNegate_1_AdapterImpl<T> _CLifoAlt_TNegate_1 = new CLifoAlt_TNegate_1_AdapterImpl(this);
  
  public boolean isNotEmpty() {
    return _CLifoAlt_TNegate_1._isNotEmpty();
  }
}

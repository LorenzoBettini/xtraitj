package xtraitj.example.examples.lifo;

import java.util.ArrayList;
import java.util.List;
import xtraitj.example.examples.lifo.CLifoAlt_TLifoAlt_0_Adapter;
import xtraitj.example.examples.lifo.CLifoAlt_TLifoAlt_0_AdapterImpl;
import xtraitj.example.examples.lifo.CLifoAlt_xtrait.example.examples.util.TNegate_1_Adapter;
import xtraitj.example.examples.lifo.CLifoAlt_xtrait.example.examples.util.TNegate_1_AdapterImpl;
import xtraitj.example.examples.lifo.ILifo;

@SuppressWarnings("all")
public class CLifoAlt<T extends Object> implements ILifo<T>, CLifoAlt_TLifoAlt_0_Adapter<T>, TNegate_1_Adapter<T> {
  private List<T> collection = new ArrayList<T>();
  
  public List<T> getCollection() {
    return this.collection;
  }
  
  public void setCollection(final List<T> collection) {
    this.collection = collection;
  }
  
  private CLifoAlt_TLifoAlt_0_AdapterImpl<T> _TLifoAlt_0 = new CLifoAlt_TLifoAlt_0_AdapterImpl(this);
  
  public void pop() {
    _TLifoAlt_0._pop();
  }
  
  public T top() {
    return _TLifoAlt_0._top();
  }
  
  public boolean isEmpty() {
    return _TLifoAlt_0._isEmpty();
  }
  
  public void push(final T o) {
    _TLifoAlt_0._push(o);
  }
  
  private TNegate_1_AdapterImpl<T> _TNegate_1 = new TNegate_1_AdapterImpl(this);
  
  public boolean isNotEmpty() {
    return _TNegate_1._isNotEmpty();
  }
}

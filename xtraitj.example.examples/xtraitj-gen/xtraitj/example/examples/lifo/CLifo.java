package xtraitj.example.examples.lifo;

import java.util.ArrayList;
import java.util.List;
import xtraitj.example.examples.lifo.ILifo;
import xtraitj.example.examples.lifo.traits.TLifo;
import xtraitj.example.examples.lifo.traits.TNegateIsEmpty;
import xtraitj.example.examples.lifo.traits.impl.TLifoImpl;
import xtraitj.example.examples.lifo.traits.impl.TNegateIsEmptyImpl;

@SuppressWarnings("all")
public class CLifo<T> implements ILifo<T>, TLifo<T>, TNegateIsEmpty {
  private List<T> collection = new ArrayList<T>();
  
  public List<T> getCollection() {
    return this.collection;
  }
  
  public void setCollection(final List<T> collection) {
    this.collection = collection;
  }
  
  private TLifoImpl<T> _TLifo = new TLifoImpl(this);
  
  public void pop() {
    _TLifo._pop();
  }
  
  public T top() {
    return _TLifo._top();
  }
  
  public boolean isEmpty() {
    return _TLifo._isEmpty();
  }
  
  public void push(final T o) {
    _TLifo._push(o);
  }
  
  private TNegateIsEmptyImpl _TNegateIsEmpty = new TNegateIsEmptyImpl(this);
  
  public boolean isNotEmpty() {
    return _TNegateIsEmpty._isNotEmpty();
  }
}

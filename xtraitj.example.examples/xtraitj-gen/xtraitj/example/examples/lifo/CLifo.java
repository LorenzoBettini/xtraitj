package xtraitj.example.examples.lifo;

import java.util.ArrayList;
import java.util.List;
import xtraitj.example.examples.lifo.ILifo;
import xtraitj.example.examples.lifo.traits.TLifo;
import xtraitj.example.examples.lifo.traits.TNegateIsEmpty;
import xtraitj.example.examples.lifo.traits.impl.TLifoImpl;
import xtraitj.example.examples.lifo.traits.impl.TNegateIsEmptyImpl;

@SuppressWarnings("all")
public class CLifo implements ILifo, TLifo, TNegateIsEmpty {
  private List<Object> collection = new ArrayList<Object>();
  
  public List<Object> getCollection() {
    return this.collection;
  }
  
  public void setCollection(final List<Object> collection) {
    this.collection = collection;
  }
  
  private TLifoImpl _TLifo = new TLifoImpl(this);
  
  public void pop() {
    _TLifo._pop();
  }
  
  public Object top() {
    return _TLifo._top();
  }
  
  public boolean isEmpty() {
    return _TLifo._isEmpty();
  }
  
  public void push(final Object o) {
    _TLifo._push(o);
  }
  
  private TNegateIsEmptyImpl _TNegateIsEmpty = new TNegateIsEmptyImpl(this);
  
  public boolean isNotEmpty() {
    return _TNegateIsEmpty._isNotEmpty();
  }
}
